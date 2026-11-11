const {before, beforeEach, after, test} = require('node:test');
const {readFileSync} = require('node:fs');
const path = require('node:path');
const {initializeTestEnvironment, assertSucceeds, assertFails} = require('@firebase/rules-unit-testing');
const {doc, setDoc, getDoc, getDocs, collection, query, where, updateDoc, deleteDoc, writeBatch, serverTimestamp, Timestamp} = require('firebase/firestore');
let env;
const day = '2026-10-31';
const id = `move-walk_${day}`;
const schedule = () => ({activityId:'move-walk', title:'Đi bộ giữa giờ', groupId:'move', dateKey:day,
  minuteOfDay:600, reminderEnabled:true, createdAt:serverTimestamp(), updatedAt:serverTimestamp()});
const db = (uid) => uid ? env.authenticatedContext(uid).firestore() : env.unauthenticatedContext().firestore();
const scheduleRef = (client, owner='alice', key=id) => doc(client, `users/${owner}/schedules/${key}`);
const proposalRef = (client) => doc(client, 'activityProposals/alice~wrist-break');
const proposal = () => ({
  ownerUid:'alice', title:'Giãn cổ tay', groupId:'move', minutes:2,
  description:'Giãn cổ tay trong giờ nghỉ.', status:'pending', createdAt:serverTimestamp(),
});

before(async () => {
  if (!process.env.FIRESTORE_EMULATOR_HOST) throw new Error('Tests require Firebase Emulator; never run on production.');
  env = await initializeTestEnvironment({projectId:process.env.POWER9_RULES_TEST_PROJECT || 'demo-power9', firestore:{
    rules:readFileSync(path.join(__dirname,'../firestore.rules'),'utf8')}});
});
beforeEach(async () => {
  await env.clearFirestore();
  await env.withSecurityRulesDisabled(async (context) => {
    await setDoc(doc(context.firestore(), 'activities/move-walk'), {
      title:'Đi bộ giữa giờ', groupId:'move', minutes:3, published:true});
    await setDoc(doc(context.firestore(), 'activities/hidden'), {title:'Hidden', groupId:'move', published:false});
    await setDoc(doc(context.firestore(), 'activities/eat-lunch'), {
      title:'Sắp xếp bữa trưa', groupId:'eat', minutes:5, published:true});
    await setDoc(doc(context.firestore(), 'users/admin'), {role:'admin'});
  });
});
after(async () => { if (env) await env.cleanup(); });

test('users can initialize their own role without granting themselves admin', async () => {
  const alice = doc(db('alice'), 'users/alice');
  await assertFails(setDoc(alice, {role:'admin'}));
  await assertSucceeds(setDoc(alice, {role:'user'}));
  await assertSucceeds(getDoc(alice));
  await assertFails(getDoc(doc(db('bob'), 'users/alice')));
  await assertFails(updateDoc(alice, {role:'admin'}));
  await assertFails(updateDoc(doc(db('admin'), 'users/admin'), {role:'user'}));
});

test('proposal is visible to its owner and admin, never another user', async () => {
  await assertFails(setDoc(proposalRef(db(null)), proposal()));
  await assertFails(setDoc(proposalRef(db('bob')), proposal()));
  await assertFails(setDoc(proposalRef(db('alice')), {...proposal(), status:'approved'}));
  await assertSucceeds(getDoc(proposalRef(db('alice'))));
  await assertSucceeds(setDoc(proposalRef(db('alice')), proposal()));
  await assertSucceeds(getDoc(proposalRef(db('alice'))));
  await assertSucceeds(getDocs(query(collection(db('alice'),'activityProposals'),where('ownerUid','==','alice'))));
  await assertFails(getDocs(collection(db('alice'),'activityProposals')));
  await assertFails(getDoc(proposalRef(db('bob'))));
  await assertSucceeds(getDoc(proposalRef(db('admin'))));
});

test('only admin can make a reasoned pending-to-final decision once', async () => {
  await setDoc(proposalRef(db('alice')), proposal());
  const decision = () => ({status:'approved', reason:'Phù hợp với danh mục.',
    reviewerUid:'admin', reviewedAt:serverTimestamp()});
  await assertFails(updateDoc(proposalRef(db('alice')), decision()));
  const admin = proposalRef(db('admin'));
  await assertFails(updateDoc(admin, {...decision(), reason:''}));
  await assertFails(updateDoc(admin, {...decision(), ownerUid:'bob'}));
  await assertSucceeds(updateDoc(admin, decision()));
  const result = await assertSucceeds(getDoc(proposalRef(db('alice'))));
  if (result.get('status') !== 'approved') throw new Error('Decision missing from owner read');
  await assertFails(updateDoc(admin, {...decision(), status:'rejected'}));
});

test('admin publishes an approved proposal once for catalog readers', async () => {
  await setDoc(proposalRef(db('alice')), proposal());
  const publish = (client, id, overrides = {}) => {
    const batch = writeBatch(client);
    batch.set(doc(client, 'activities', id), {
      title:'Giãn cổ tay', groupId:'move', groupName:'Vận động', minutes:2,
      purpose:'Giãn cổ tay trong giờ nghỉ.', steps:[], note:'', rank:1000,
      published:true, ...overrides,
    });
    batch.update(proposalRef(client), {publishedActivityId:id});
    return batch.commit();
  };
  const admin = db('admin');
  await assertFails(publish(admin, 'new-wrist-break'));
  await updateDoc(proposalRef(admin), {
    status:'approved', reason:'Phù hợp với danh mục.',
    reviewerUid:'admin', reviewedAt:serverTimestamp(),
  });
  await assertFails(publish(db('alice'), 'new-wrist-break'));
  await assertFails(publish(admin, 'new-wrist-break', {minutes:3}));
  await assertSucceeds(publish(admin, 'new-wrist-break'));
  await assertFails(publish(admin, 'duplicate-wrist-break'));
  const activity = await assertSucceeds(getDoc(doc(db('bob'), 'activities/new-wrist-break')));
  if (activity.get('title') !== 'Giãn cổ tay') throw new Error('Published catalog item missing');
});

const reportId='a'.repeat(64);
const reportRef=(client,uid='alice')=>doc(client,`users/${uid}/reports/${reportId}`);
const reportData=()=>({dateKey:day,fileName:`Power9-${day}-${'a'.repeat(12)}.pdf`,
  storagePath:`reports/alice/${reportId}.pdf`,byteLength:1234,sha256:reportId,createdAt:serverTimestamp()});
test('report metadata is owner-only and immutable',async()=>{
  await assertSucceeds(setDoc(reportRef(db('alice')),reportData()));
  await assertSucceeds(getDoc(reportRef(db('alice'))));
  await assertFails(getDoc(reportRef(db('bob'))));
  await assertFails(getDoc(reportRef(db(null))));
  await assertFails(updateDoc(reportRef(db('alice')),{byteLength:2345}));
});
test('report metadata rejects foreign storage path and extra fields',async()=>{
  await assertFails(setDoc(reportRef(db('alice')),{...reportData(),storagePath:`reports/bob/${reportId}.pdf`}));
  await assertFails(setDoc(reportRef(db('alice')),{...reportData(),downloadUrl:'https://example.invalid'}));
  await assertFails(setDoc(reportRef(db('alice')),{...reportData(),byteLength:11*1024*1024}));
});
test('owner can record metadata for a device-only Assignment PDF', async () => {
  const localReport = {...reportData(), storagePath:null};
  await assertFails(setDoc(reportRef(db('bob')), localReport));
  await assertSucceeds(setDoc(reportRef(db('alice')), localReport));
  const saved = await assertSucceeds(getDoc(reportRef(db('alice'))));
  if (saved.get('storagePath') !== null) throw new Error('Expected device-only PDF');
  await assertFails(updateDoc(reportRef(db('alice')), {storagePath:reportData().storagePath}));
});

test('owner can create, read, update and delete their own schedule', async () => {
  const ref = scheduleRef(db('alice'));
  await assertSucceeds(setDoc(ref,schedule()));
  await assertSucceeds(getDoc(ref));
  await assertSucceeds(updateDoc(ref,{minuteOfDay:660,updatedAt:serverTimestamp()}));
  await assertSucceeds(deleteDoc(ref));
});
test('another user cannot read, write or delete the owner schedule', async () => {
  await setDoc(scheduleRef(db('alice')),schedule());
  const ref = scheduleRef(db('bob'));
  await assertFails(getDoc(ref));
  await assertFails(setDoc(ref,schedule()));
  await assertFails(deleteDoc(ref));
});
test('signed-out clients cannot access catalog or schedules', async () => {
  await assertFails(getDoc(doc(db(), 'activities/move-walk')));
  await assertFails(setDoc(scheduleRef(db()),schedule()));
});
test('catalog query requires published filter and client cannot change catalog', async () => {
  const client = db('alice');
  await assertSucceeds(getDocs(query(collection(client,'activities'),where('published','==',true))));
  await assertFails(getDocs(collection(client,'activities')));
  await assertFails(setDoc(doc(client,'activities/move-walk'),{published:true}));
  await assertFails(getDoc(doc(client,'activities/hidden')));
});
test('admin manages catalog and archived activities disappear from user queries', async () => {
  const admin = db('admin');
  const user = db('alice');
  const ref = doc(admin, 'activities/new-catalog-item');
  const data = {title:'Giãn vai', groupId:'move', groupName:'Vận động', minutes:2,
    purpose:'Thả lỏng vai trong giờ nghỉ.', steps:['Đứng lên.','Thả lỏng vai.'],
    note:'', rank:1000, published:true};
  await assertFails(setDoc(doc(user, ref.path), data));
  await assertFails(setDoc(ref, {...data, steps:[123]}));
  await assertSucceeds(setDoc(ref, data));
  await assertSucceeds(updateDoc(ref, {title:'Giãn vai nhẹ'}));
  await assertFails(updateDoc(doc(user, ref.path), {published:false}));
  await assertSucceeds(updateDoc(ref, {published:false}));
  await assertFails(updateDoc(doc(admin, 'activities/eat-lunch'), {published:false}));
  await assertFails(getDoc(doc(user, ref.path)));
  await assertSucceeds(getDoc(ref));
  await assertSucceeds(updateDoc(ref, {published:true}));
  const visible = await assertSucceeds(getDoc(doc(user, ref.path)));
  if (visible.get('title') !== 'Giãn vai nhẹ') throw new Error('Restored activity missing');
});

test('admin broadcasts validated immutable announcements to signed-in users', async () => {
  const ref = (client) => doc(client, 'announcements/demo');
  const message = {title:'Tin Power9', body:'Chào mọi người!', createdAt:serverTimestamp()};
  await assertFails(setDoc(ref(db('alice')), message));
  await assertFails(setDoc(ref(db('admin')), {...message, body:''}));
  await assertSucceeds(setDoc(ref(db('admin')), message));
  await assertSucceeds(getDoc(ref(db('alice'))));
  await assertFails(getDoc(ref(db())));
  await assertFails(updateDoc(ref(db('admin')), {title:'Đã sửa'}));
});
test('reminder without time, wrong type or unknown field is denied', async () => {
  const ref = scheduleRef(db('alice'));
  await assertFails(setDoc(ref,{...schedule(),minuteOfDay:null}));
  await assertFails(setDoc(ref,{...schedule(),minuteOfDay:'10:00'}));
  await assertFails(setDoc(ref,{...schedule(),role:'admin'}));
});
test('no-reminder schedule permits no time', async () => {
  await assertSucceeds(setDoc(scheduleRef(db('alice')),{
    ...schedule(),minuteOfDay:null,reminderEnabled:false}));
});
test('random document ID cannot bypass one activity per day', async () => {
  await assertFails(setDoc(scheduleRef(db('alice'),'alice','random-id'),schedule()));
});
test('owner cannot forge catalog title or rewrite creation time', async () => {
  const ref = scheduleRef(db('alice'));
  await assertFails(setDoc(ref,{...schedule(),title:'Forged title'}));
  await setDoc(ref,schedule());
  await assertFails(updateDoc(ref,{createdAt:Timestamp.fromMillis(0),updatedAt:serverTimestamp()}));
});

const completion=(source='timer',durationSeconds=45)=>({activityId:'move-walk',title:'Đi bộ giữa giờ',
  groupId:'move',dateKey:day,source,durationSeconds,createdAt:serverTimestamp()});
const completionRef=(client,owner='alice')=>doc(client,`users/${owner}/completions/${id}`);

test('owner can record 45 actual seconds; records cannot be overwritten',async()=>{
  const ref=completionRef(db('alice'));
  await assertSucceeds(setDoc(ref,completion()));
  await assertSucceeds(getDoc(ref));
  await assertFails(updateDoc(ref,{durationSeconds:180}));
});
test('deleting completion keeps the separately stored schedule',async()=>{
  const client=db('alice');
  await setDoc(scheduleRef(client),schedule());
  await setDoc(completionRef(client),completion());
  await assertSucceeds(deleteDoc(completionRef(client)));
  const plan=await assertSucceeds(getDoc(scheduleRef(client)));
  if(!plan.exists()) throw new Error('Schedule was lost');
});
test('another user cannot read, delete or create an owner completion',async()=>{
  await setDoc(completionRef(db('alice')),completion());
  await assertFails(getDoc(completionRef(db('bob'))));
  await assertFails(deleteDoc(completionRef(db('bob'))));
  await assertFails(setDoc(completionRef(db('bob')),completion()));
});
test('zero, excessive or nonnumeric measured duration is rejected',async()=>{
  const ref=completionRef(db('alice'));
  for(const duration of [0,181,'45']) await assertFails(setDoc(ref,completion('timer',duration)));
});
test('check-in does not invent a measured duration',async()=>{
  const ref=completionRef(db('alice'));
  await assertFails(setDoc(ref,completion('checkin',180)));
  await assertSucceeds(setDoc(ref,completion('checkin',null)));
});
test('unknown completion source or random ID is rejected',async()=>{
  const client=db('alice');
  await assertFails(setDoc(completionRef(client),completion('admin',45)));
  await assertFails(setDoc(doc(client,'users/alice/completions/random'),completion()));
});
