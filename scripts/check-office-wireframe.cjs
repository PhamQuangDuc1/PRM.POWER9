const fs=require('fs'),path=require('path');
const base='C:/Users/PC/AppData/Local/OpenAI/Codex/runtimes/cua_node';
const runtime=fs.readdirSync(base).find(x=>fs.existsSync(path.join(base,x,'bin/node_modules/playwright/package.json')));
const {chromium}=require(path.join(base,runtime,'bin/node_modules/playwright'));
(async()=>{
 const browser=await chromium.launch({executablePath:'C:/Program Files/Google/Chrome/Application/chrome.exe',headless:true});
 const page=await browser.newPage({viewport:{width:1200,height:1000}});
 const errors=[];page.on('pageerror',e=>errors.push(e.message));
 await page.goto('file:///'+path.resolve('output/office-wireframe.html').replaceAll('\\','/'));
 const screens=await page.locator('.phone').count();
 const habits=await page.locator('#catalog .card').count();
 if(screens!==8||habits!==9)throw Error('Expected 8 screens and 9 principles');
 await page.locator('#search').fill('không tồn tại');
 if(await page.locator('#catalog .card').count()!==0)throw Error('Search empty failed');
 await page.locator('#catalog button').click();
 if(await page.locator('#catalog .card').count()!==9)throw Error('Reset failed');
 for(let i=0;i<9;i++){
  await page.evaluate(i=>detail(i),i);
  if(!(await page.locator('#detail-title').textContent()))throw Error('Missing detail');
 }
 const button=page.locator('#s01 .card button').first();
 const original=await button.textContent();await button.click();await button.click();
 if(await button.textContent()!==original)throw Error('Undo failed');
 await page.evaluate(()=>detail(0));
 const overflow=await page.locator('.phone').evaluateAll(nodes=>nodes.filter(n=>n.scrollWidth>n.clientWidth).map(n=>n.id));
 await page.screenshot({path:'output/office-wireframe-overview.png',fullPage:true});
 if(errors.length||overflow.length)throw Error(JSON.stringify({errors,overflow}));
 const report={screens,principles:habits,searchReset:true,allDetails:true,undo:true,horizontalOverflow:overflow,consoleErrors:errors,limitations:'Local wireframe; no persistent state, no synced history, no Figma mutation.'};
 fs.writeFileSync('output/office-wireframe-check.json',JSON.stringify(report,null,2));
 console.log(JSON.stringify(report));await browser.close();
})().catch(e=>{console.error(e);process.exit(1)});
