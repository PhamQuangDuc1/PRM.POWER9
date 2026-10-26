const fs=require('fs'),path=require('path');
const root='C:/Users/PC/AppData/Local/OpenAI/Codex/runtimes/cua_node';
const runtime=fs.readdirSync(root).find(x=>fs.existsSync(path.join(root,x,'bin/node_modules/playwright/package.json')));
const {chromium}=require(path.join(root,runtime,'bin/node_modules/playwright'));
(async()=>{
 const browser=await chromium.launch({executablePath:'C:/Program Files/Google/Chrome/Application/chrome.exe',headless:true});
 const manifest=JSON.parse(fs.readFileSync('assets/stitch/office-final/manifest.json','utf8'));
 const output='output/office-wireframe-audit';fs.mkdirSync(output,{recursive:true});
 const rows=[];
 for(const s of manifest.screens){
  const id=s.folder.match(/s\d+/)[0].toUpperCase();
  const page=await browser.newPage({viewport:{width:360,height:800}});
  const failures=[];page.on('requestfailed',r=>failures.push(r.url()));
  await page.goto('file:///'+path.resolve(s.html).replaceAll('\\','/'),{waitUntil:'networkidle',timeout:45000});
  await page.evaluate(()=>document.fonts.ready);
  for(const width of [360,412]){
   await page.setViewportSize({width,height:800});
   const result=await page.evaluate(()=>{
    const elements=[...document.querySelectorAll('body *')];
    const visible=e=>{const r=e.getBoundingClientRect(),c=getComputedStyle(e);return r.width>0&&r.height>0&&c.visibility!=='hidden'&&c.display!=='none'};
    const smallText=elements.filter(e=>visible(e)&&[...e.childNodes].some(n=>n.nodeType===3&&n.textContent.trim())&&!e.classList.contains('material-symbols-outlined')).map(e=>({text:e.textContent.trim().replace(/\s+/g,' ').slice(0,90),size:parseFloat(getComputedStyle(e).fontSize)})).filter(e=>e.size<14);
    const controls=[...document.querySelectorAll('button,a,input,select,[role=switch],[role=checkbox]')].filter(visible).map(e=>{const r=e.getBoundingClientRect();return {label:(e.innerText||e.getAttribute('aria-label')||e.type||'').trim().replace(/\s+/g,' ').slice(0,60),width:Math.round(r.width),height:Math.round(r.height)}});
    return {viewport:innerWidth,scrollWidth:document.documentElement.scrollWidth,pageHeight:document.documentElement.scrollHeight,tailwindLoaded:typeof tailwind!=='undefined',bodyDisplay:getComputedStyle(document.body).display,heading:document.querySelector('h1')?.textContent.trim(),text:document.body.innerText.replace(/\s+/g,' ').trim(),smallText,smallControls:controls.filter(e=>e.width<48||e.height<48),controls};
   });
   rows.push({id,width,...result,failedRequests:[...new Set(failures)]});
   if(width===360)await page.screenshot({path:path.join(output,id+'-360.png'),fullPage:true});
  }
  await page.close();
 }
 await browser.close();
 fs.writeFileSync(path.join(output,'audit.json'),JSON.stringify(rows,null,2));
 console.log(JSON.stringify(rows.map(r=>({id:r.id,width:r.width,css:r.tailwindLoaded,overflow:r.scrollWidth>r.width,smallText:r.smallText.length,smallControls:r.smallControls.length,failures:r.failedRequests.length}))));
})().catch(e=>{console.error(e);process.exit(1)});
