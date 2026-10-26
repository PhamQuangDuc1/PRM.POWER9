const fs=require('fs');
const AsyncFunction=Object.getPrototypeOf(async function(){}).constructor;
const base='scripts/figma/';
const helpers=fs.readFileSync(base+'office-ui-helpers.js','utf8');
for(const [name,prefix]of [['office-03-foundations.js',''],['office-04-components.js',helpers],['office-04b-component-repair.js',''],['office-04c-library-audit.js',''],['office-05-final-ui.js',helpers],['office-05b-review-repair.js',''],['office-06-prototype.js',''],['office-06b-prototype-extras.js',''],['office-06c-final-repair.js',''],['office-06d-flow-final-audit.js',''],['office-07-final-review.js',''],['office-08-discover-accordion-library.js',''],['office-09-apply-discover-accordion.js','']]){
  new AsyncFunction(prefix+'\n'+fs.readFileSync(base+name,'utf8'));
  console.log('Syntax OK: '+name);
}
