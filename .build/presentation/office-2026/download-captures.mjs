import fs from 'node:fs/promises';
import path from 'node:path';
const dir=path.resolve('.build/presentation/office-2026');
await fs.mkdir(path.join(dir,'evidence'),{recursive:true});
const urls=JSON.parse(await fs.readFile(path.join(dir,'capture-urls.json'),'utf8'));
await Promise.all(urls.map(async x=>{const r=await fetch(x.image_url);if(!r.ok)throw new Error(x.key+': '+r.status);await fs.writeFile(path.join(dir,'evidence',x.key+'.png'),new Uint8Array(await r.arrayBuffer()));console.log('Downloaded '+x.key);}));
