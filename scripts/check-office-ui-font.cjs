const fs=require('fs'),path=require('path');
const runtimeRoot='C:/Users/PC/AppData/Local/OpenAI/Codex/runtimes/cua_node';
const runtime=fs.readdirSync(runtimeRoot).find(x=>fs.existsSync(path.join(runtimeRoot,x,'bin/node_modules/playwright/package.json')));
const {chromium}=require(path.join(runtimeRoot,runtime,'bin/node_modules/playwright'));
(async()=>{
 const manifest=JSON.parse(fs.readFileSync('assets/stitch/office-ui/OI01-source/manifest.json','utf8'));
 const out='output/office-ui-font-check';fs.mkdirSync(out,{recursive:true});
 const browser=await chromium.launch({executablePath:'C:/Program Files/Google/Chrome/Application/chrome.exe',headless:true});
 const results=[];
 for(const id of ['S01','S07']){
  const source=manifest.screens.find(x=>x.id===id);
  const page=await browser.newPage({viewport:{width:360,height:800}});const failures=[];
  page.on('requestfailed',r=>failures.push(r.url()));
  await page.goto('file:///'+path.resolve(source.html).replaceAll('\\','/'),{waitUntil:'networkidle',timeout:45000});
  await page.evaluate(()=>document.fonts.ready);
  const cdp=await page.context().newCDPSession(page);
  async function inspect(){
   const {root}=await cdp.send('DOM.getDocument');
   const {nodeId}=await cdp.send('DOM.querySelector',{nodeId:root.nodeId,selector:'h1'});
   const rendered=await cdp.send('CSS.getPlatformFontsForNode',{nodeId});
   const computed=await page.evaluate(()=>({body:getComputedStyle(document.body).fontFamily,heading:getComputedStyle(document.querySelector('h1')).fontFamily,loaded:[...document.fonts].filter(f=>f.status==='loaded').map(f=>f.family)}));
   return {...computed,rendered:rendered.fonts};
  }
  await cdp.send('DOM.enable');await cdp.send('CSS.enable');
  const before=await inspect();await page.screenshot({path:path.join(out,id+'-before.png'),fullPage:true});
  await page.evaluate(()=>{for(const [key,value]of Object.entries(tailwind.config.theme.extend.fontFamily)){if(Array.isArray(value)&&value.some(x=>x.includes('Be Vietnam Pro, Roboto, sans-serif')))tailwind.config.theme.extend.fontFamily[key]=['Be Vietnam Pro','Roboto','sans-serif'];}tailwind.config={...tailwind.config};});
  await page.waitForTimeout(500);await page.evaluate(()=>document.fonts.ready);
  const after=await inspect();await page.screenshot({path:path.join(out,id+'-after-local-fix.png'),fullPage:true});
  results.push({id,before,after,failures,scope:'Local DOM verification only; original HTML and Stitch canvas unchanged.'});
  await page.close();
 }
 await browser.close();fs.writeFileSync(path.join(out,'font-verification.json'),JSON.stringify(results,null,2));
 console.log(JSON.stringify(results));
})().catch(e=>{console.error(e);process.exit(1)});
