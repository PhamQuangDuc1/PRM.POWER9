const {chromium}=require('C:/Users/PC/AppData/Local/OpenAI/Codex/runtimes/cua_node/1fb7137c46617d50/bin/node_modules/playwright');
const fs=require('fs'),path=require('path');
(async()=>{
 const out=path.resolve('output/prototype-render');fs.mkdirSync(out,{recursive:true});
 const browser=await chromium.launch({executablePath:'C:/Program Files/Google/Chrome/Application/chrome.exe',headless:true,args:['--disable-gpu']});
 const page=await browser.newPage({viewport:{width:360,height:800},deviceScaleFactor:1});
 const file=path.resolve('assets/stitch/export-original/stitch_power9_family_routine_ui_design/i01_s01_h_m_nay/code.html');
 const fails=[];page.on('requestfailed',r=>fails.push(r.failure().errorText));
 await page.goto('file:///'+file.replaceAll('\\','/'),{waitUntil:'networkidle',timeout:45000});
 await page.evaluate(()=>document.fonts.ready);
 const info=await page.evaluate(()=>({font:document.fonts.check('16px "Be Vietnam Pro"'),headerHeight:document.querySelector('header')?.getBoundingClientRect().height,contentHeight:document.documentElement.scrollHeight}));
 await page.screenshot({path:path.join(out,'S01-test-360x800.png')});
 console.log(JSON.stringify({info,failedRequests:fails.length}));
 await browser.close();
})().catch(e=>{console.error(e.message);process.exit(1)});
