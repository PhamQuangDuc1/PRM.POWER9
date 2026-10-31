const {before, beforeEach, after, test} = require('node:test');
const {readFileSync} = require('node:fs');
const path = require('node:path');
const {initializeTestEnvironment, assertSucceeds, assertFails} = require('@firebase/rules-unit-testing');
const {doc, setDoc, getDoc, getDocs, collection, query, where, updateDoc, deleteDoc, serverTimestamp, Timestamp} = require('firebase/firestore');
let env;
const day = '2026-10-31';
const id = `move-walk_${day}`;
const schedule = () => ({activityId:'move-walk', title:'Đi bộ giữa giờ', groupId:'move', dateKey:day,
  minuteOfDay:600, reminderEnabled:true, createdAt:serverTimestamp(), updatedAt:serverTimestamp()});
const db = (uid) => uid ? env.authenticatedContext(uid).firestore() : env.unauthenticatedContext().firestore();
const scheduleRef = (client, owner='alice', key=id) => doc(client, `users/${owner}/schedules/${key}`);

before(async () => {
  if (!process.env.FIRESTORE_EMULATOR_HOST) throw new Error('Tests require Firebase Emulator; never run on production.');
  env = await initializeTestEnvironment({projectId:'demo-power9', firestore:{
    rules:readFileSync(path.join(__dirname,'../firestore.rules'),'utf8')}});
});
beforeEach(async () => {
  await env.clearFirestore();
  await env.withSecurityRulesDisabled(async (context) => {
    await setDoc(doc(context.firestore(), 'activities/move-walk'), {
      title:'Đi bộ giữa giờ', groupId:'move', published:true});
    await setDoc(doc(context.firestore(), 'activities/hidden'), {title:'Hidden', groupId:'move', published:false});
  });
});
after(async () => { if (env) await env.cleanup(); });

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
