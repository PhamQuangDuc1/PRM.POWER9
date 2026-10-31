const {before,after,test}=require('node:test');
const {readFileSync}=require('node:fs');
const path=require('node:path');
const {initializeTestEnvironment,assertSucceeds,assertFails}=require('@firebase/rules-unit-testing');
const {ref,uploadBytes,getBytes,deleteObject}=require('firebase/storage');
let env;
const file='b'.repeat(64)+'.pdf';
const bytes=new Uint8Array([37,80,68,70,45,49,46,55]);
const metadata={contentType:'application/pdf',customMetadata:{dateKey:'2026-11-01',schemaVersion:'1'}};
const client=uid=>uid?env.authenticatedContext(uid).storage():env.unauthenticatedContext().storage();
before(async()=>{
  if(!process.env.FIREBASE_STORAGE_EMULATOR_HOST) throw new Error('Storage emulator is required; never run on production');
  env=await initializeTestEnvironment({projectId:'demo-power9',storage:{rules:readFileSync(path.join(__dirname,'../storage.rules'),'utf8')}});
});
after(async()=>{if(env)await env.cleanup();});
test('owner can upload/read PDF; other users and anonymous clients cannot',async()=>{
  await assertSucceeds(uploadBytes(ref(client('alice'),`reports/alice/${file}`),bytes,metadata));
  await assertSucceeds(getBytes(ref(client('alice'),`reports/alice/${file}`)));
  await assertFails(getBytes(ref(client('bob'),`reports/alice/${file}`)));
  await assertFails(getBytes(ref(client(null),`reports/alice/${file}`)));
  await assertFails(uploadBytes(ref(client('bob'),`reports/alice/${file}`),bytes,metadata));
});
test('wrong MIME, invalid filename and oversized files are denied',async()=>{
  const storage=client('alice');
  await assertFails(uploadBytes(ref(storage,`reports/alice/${file}`),bytes,{...metadata,contentType:'text/plain'}));
  await assertFails(uploadBytes(ref(storage,'reports/alice/report.pdf'),bytes,metadata));
  await assertFails(uploadBytes(ref(storage,`reports/alice/${file}`),new Uint8Array(10*1024*1024+1),metadata));
  await assertSucceeds(deleteObject(ref(storage,`reports/alice/${file}`)));
});
