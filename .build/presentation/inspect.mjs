import fs from 'node:fs/promises';
import path from 'node:path';
import {PresentationFile,FileBlob} from 'file:///C:/Users/PC/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/@oai/artifact-tool/dist/artifact_tool.mjs';
process.on('uncaughtException',e=>{console.error('ERROR: '+e.message);process.exit(1)});
const dir=path.resolve('.build/presentation');await fs.mkdir(dir,{recursive:true});await fs.mkdir(path.join(dir,'source'),{recursive:true});
const p=await PresentationFile.importPptx(await FileBlob.load('.build/presentation/template-renderable.pptx'));
const snap=await p.inspect({kind:'slide,textbox,shape,image,layout',maxChars:2000000});
await fs.writeFile(path.join(dir,'source-inspect.ndjson'),snap.ndjson);
await fs.writeFile(path.join(dir,'source-elements.json'),JSON.stringify(p.slides.items.map(s=>({id:s.id,shapes:s.shapes.items.map(x=>({id:x.id,name:x.name,text:String(x.text||''),position:x.position})),images:s.images.items.map(x=>({id:x.id,position:x.position}))})),null,2));
for(let i=0;i<p.slides.items.length;i++){const b=await p.export({slide:p.slides.items[i],format:'png',scale:.6666667});await fs.writeFile(path.join(dir,'source',String(i+1).padStart(2,'0')+'.png'),new Uint8Array(await b.arrayBuffer()));}
console.log(JSON.stringify({slides:p.slides.items.length,rendered:true,firstSlide:p.slides.items[0].id}));
