const fs=require('fs'),path=require('path');
const root=process.cwd();
const runtimeRoot='C:/Users/PC/AppData/Local/OpenAI/Codex/runtimes/cua_node';
const runtime=fs.readdirSync(runtimeRoot).find(x=>fs.existsSync(path.join(runtimeRoot,x,'bin/node_modules/playwright/package.json')));
const {chromium}=require(path.join(runtimeRoot,runtime,'bin/node_modules/playwright'));
const m=JSON.parse(fs.readFileSync(path.join(root,'assets/stitch/export-manifest.json'),'utf8'));
const byName=Object.fromEntries(m.screens.map(s=>[s.folder,s]));
const specs=Object.entries(m.selected_final).map(([id,s])=>({id,source:s.html,kind:/existing/.test(id)?'states':'main'}));
for(const [id,name]of Object.entries({
'S05-empty':'i02_s05_empty_kh_m_ph_th_i_quen',
'S07-saving':'i02_s07_saving_l_ch_th_i_quen',
'S07-validation':'i02_s07_validation_l_ch_th_i_quen',
'S07-error':'i02_s07_error_l_ch_th_i_quen',
'S08-empty':'i02_s08_empty_l_ch_s_v_ti_n'}))specs.push({id,source:byName[name].html,kind:'states'});
const output=path.join(root,'output/prototype-render');
(async()=>{
 fs.mkdirSync(output,{recursive:true});
 const browser=await chromium.launch({executablePath:'C:/Program Files/Google/Chrome/Application/chrome.exe',headless:true,args:['--disable-gpu']});
 const context=await browser.newContext({viewport:{width:360,height:800},deviceScaleFactor:1});
 const manifest=[];let cursor=0;
 async function worker(){
  while(cursor<specs.length){
   const s=specs[cursor++],page=await context.newPage();const failures=[];
   page.on('requestfailed',r=>failures.push(r.url()));
   await page.goto('file:///'+path.resolve(s.source).replaceAll('\\','/'),{waitUntil:'networkidle',timeout:45000});
   await page.evaluate(()=>document.fonts.ready);
   const headerHeight=await page.evaluate(()=>document.querySelector('header')?.getBoundingClientRect().height||0);
   const missing=await page.evaluate(()=>({images:[...document.images].filter(i=>!i.complete||i.naturalWidth===0).length,fonts:[...document.fonts].filter(f=>f.family.includes('Vietnam')&&f.status==='loaded').length}));
   if(missing.images||!missing.fonts||headerHeight<40||headerHeight>120){await page.reload({waitUntil:'networkidle',timeout:45000});await page.evaluate(()=>document.fonts.ready);}
   const check=await page.evaluate(()=>({images:[...document.images].filter(i=>!i.complete||i.naturalWidth===0).length,fonts:[...document.fonts].filter(f=>f.family.includes('Vietnam')&&f.status==='loaded').length,header:document.querySelector('header')?.getBoundingClientRect().height||0}));
   if(check.images||!check.fonts||check.header<40||check.header>120)throw new Error('Incomplete final resources for '+s.id+': '+JSON.stringify(check));
   const dir=path.join(output,s.kind);fs.mkdirSync(dir,{recursive:true});
   const viewport=s.id+'-360x800.png',full=s.id+'-full.png';
   await page.screenshot({path:path.join(dir,viewport)});
   let h=await page.evaluate(()=>Math.max(document.documentElement.scrollHeight,document.body.scrollHeight,800));
   await page.setViewportSize({width:360,height:Math.ceil(h)});
   await page.evaluate(()=>document.fonts.ready);
   const layout=await page.evaluate(()=>{
    const h=Math.ceil(Math.max(document.documentElement.scrollHeight,document.body.scrollHeight,innerHeight));
    const controls=[...document.querySelectorAll('button,a,input,select,[role="button"]')].map((e,i)=>{
     const r=e.getBoundingClientRect();return {index:i,label:(e.innerText||e.getAttribute('aria-label')||e.getAttribute('placeholder')||'').replace(/\s+/g,' ').trim(),tag:e.tagName,x:Math.round(r.x),y:Math.round(r.y),width:Math.round(r.width),height:Math.round(r.height)};
    }).filter(x=>x.width>0&&x.height>0);
    return {height:h,controls};
   });
   await page.screenshot({path:path.join(dir,full),fullPage:true});
   manifest.push({...s,width:360,height:layout.height,viewport:s.kind+'/'+viewport,full:s.kind+'/'+full,controls:layout.controls});
   await page.close();
  }
 }
 await Promise.all([worker(),worker(),worker()]);
 await browser.close();
 manifest.sort((a,b)=>a.id.localeCompare(b.id));
 fs.writeFileSync(path.join(output,'render-manifest.json'),JSON.stringify(manifest,null,2));
 console.log(JSON.stringify({rendered:manifest.length,main:manifest.filter(x=>x.kind==='main').length,states:manifest.filter(x=>x.kind==='states').length,viewport:'360x800',resources:'loaded'}));
})().catch(e=>{console.error(e.stack);process.exit(1)});
