import fs from 'node:fs/promises';
import { FileBlob, SpreadsheetFile } from 'file:///C:/Users/PC/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/@oai/artifact-tool/dist/artifact_tool.mjs';

const source = 'D:/Download/Checklist_Tuan_Tu_PRM323_Lab2_PRM_POWER9.xlsx';
const wb = await SpreadsheetFile.importXlsx(await FileBlob.load(source));
const overview = await wb.inspect({ kind: 'workbook,sheet,region', maxChars: 12000, tableMaxRows: 40, tableMaxCols: 10, tableMaxCellChars: 160 });
await fs.mkdir('.build/checklist', { recursive: true });
await fs.writeFile('.build/checklist/source-inspect.ndjson', overview.ndjson ?? String(overview));
console.log(overview.ndjson ?? String(overview));
