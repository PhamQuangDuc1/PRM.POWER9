// Read only one test user's schedule/completion for the explicitly selected day.
// Never print the uid, FID, auth credentials or raw API body.
const fs=require('node:fs'),path=require('node:path');
(async()=>{
 const phase=process.argv[2],day=process.argv[3];
 if(!/^(before|created|updated|cancelled|deleted|completion-retained|cleaned)$/.test(phase)||!/^\d{4}-\d{2}-\d{2}$/.test(day))throw Error('Invalid phase/day');
 const accountFile=process.env.POWER9_CRUD_TEST_ACCOUNT_FILE;
 if(!accountFile)throw Error('Set the ignored test account file explicitly');
 const local=JSON.parse(fs.readFileSync(accountFile,'utf8'));
 if(local.projectId!=='power9-office-se180724')throw Error('Wrong test project');
 const base=path.join(process.env.APPDATA,'npm/node_modules/firebase-tools/lib');
 const account=require(path.join(base,'auth.js')).getGlobalDefaultAccount();
 await require(path.join(base,'requireAuth.js')).requireAuth({project:local.projectId,user:account.user,tokens:account.tokens});
 const {Client}=require(path.join(base,'apiv2.js'));const api=new Client({urlPrefix:'https://firestore.googleapis.com',apiVersion:'v1'});
 const id='move-walk_'+day;
 const get=async collection=>{
  try {const r=await api.get('/projects/'+local.projectId+'/databases/(default)/documents/users/'+encodeURIComponent(local.recipientUid)+'/'+collection+'/'+encodeURIComponent(id));return {exists:true,fields:r.body.fields};}
  catch(e){if(e.status===404||e.context?.response?.statusCode===404)return {exists:false};throw Error('Scoped Firestore read failed');}
 };
 const schedule=await get('schedules'),completion=await get('completions');
 const read=(row,key)=>row.fields?.[key]?Object.values(row.fields[key])[0]:null;
 const record={phase,dateKey:day,source:'read-only Firestore API, exact current test-user document paths',scheduleExists:schedule.exists,completionExists:completion.exists,minuteOfDay:read(schedule,'minuteOfDay'),createdAt:read(schedule,'createdAt'),updatedAt:read(schedule,'updatedAt'),completionSource:read(completion,'source'),durationSeconds:read(completion,'durationSeconds'),ownerUidExported:false,credentialsExported:false};
 fs.mkdirSync('evidence/flows/crud',{recursive:true});fs.writeFileSync('evidence/flows/crud/'+phase+'.json',JSON.stringify(record,null,2)+'\n');console.log(JSON.stringify(record));
})().catch(()=>{console.log('SCOPED_CRUD_SERVER_READ_UNVERIFIED');process.exitCode=1});
