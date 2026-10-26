import fs from 'node:fs/promises';
import path from 'node:path';
import { FileBlob, SpreadsheetFile } from 'file:///C:/Users/PC/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/@oai/artifact-tool/dist/artifact_tool.mjs';

const source = 'D:/Download/Checklist_Tuan_Tu_PRM323_Lab2_PRM_POWER9.xlsx';
const outDir = path.resolve('output', 'checklist');
const outFile = path.join(outDir, 'Checklist_Tuan_Tu_PRM323_Lab2_PRM_POWER9_cap_nhat.xlsx');
await fs.mkdir(outDir, { recursive: true });

const workbook = await SpreadsheetFile.importXlsx(await FileBlob.load(source));
const sheet = workbook.worksheets.getItem('Untitled');

// E = completed. Only evidence-backed Lab 2 items are marked; review/confirmation (F) stays untouched.
const completedRows = [2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,19];
for (const row of completedRows) sheet.getRange(`E${row}`).values = [[1]];

// G = still in progress: source-faithful Final UI, accessibility proof, prototype links and final handoff checks.
const inProgressRows = [18,20,21,22,23,24,25,26];
for (const row of inProgressRows) sheet.getRange(`G${row}`).values = [[1]];

// Clear the old in-progress flags for rows now completed, while retaining all existing sheet layout/validation.
for (const row of completedRows) sheet.getRange(`G${row}`).values = [[0]];
await workbook.recalculate();
const check = await workbook.inspect({ kind: 'region', sheetId: 'Untitled', range: 'A1:G26', maxChars: 7000, tableMaxRows: 30, tableMaxCols: 7 });
await fs.writeFile('.build/checklist/updated-inspect.ndjson', check.ndjson ?? String(check));
const render = await workbook.render({ sheetName: 'Untitled', range: 'A1:G26', scale: 1.5, format: 'png' });
await fs.writeFile('.build/checklist/updated-preview.png', new Uint8Array(await render.arrayBuffer()));
const output = await SpreadsheetFile.exportXlsx(workbook);
await output.save(outFile);
console.log(outFile);
