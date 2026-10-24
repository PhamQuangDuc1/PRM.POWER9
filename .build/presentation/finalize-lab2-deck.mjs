import fs from 'node:fs/promises';
import path from 'node:path';
import { pathToFileURL } from 'node:url';

const workspaceDir = path.resolve('.');
const skillDir = 'C:/Users/PC/.codex/plugins/cache/openai-primary-runtime/presentations/26.1022.11436/skills/presentations';
const runtimePython = 'C:/Users/PC/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/python.exe';
const candidatePath = path.join(workspaceDir, '.build', 'presentation', 'Power9_Lab2_Presentation_draft.pptx');
const finalPath = path.join(workspaceDir, 'output', 'presentation', 'Power9_Lab2_Presentation_final.pptx');
const stagingDir = path.join(workspaceDir, '.codex-finalizer');
await fs.mkdir(stagingDir, { recursive: true });
const { finalizePresentation } = await import(pathToFileURL(path.join(skillDir, 'container_tools', 'artifact_tool_utils.mjs')).href);
const result = await finalizePresentation({
  explicitTotalSlideCount: 12,
  requiredNativeTableOwnerSlides: [],
  requiredNativeChartOwnerSlides: [],
  workspaceDir,
  candidatePath,
  finalPath,
  pythonExecutable: runtimePython,
  integrityValidatorPath: path.join(skillDir, 'container_tools', 'inspect_presentation_package_integrity.py'),
  layoutValidatorPath: path.join(skillDir, 'container_tools', 'inspect_presentation_layout_geometry.py'),
  layoutArgs: ['--expected-slide-size-emu', '18288000,10287000', '--validate-bullet-geometry', '--validate-heading-fit'],
  fontPolicy: { basis: 'reference', families: ['Poppins', 'Noto Sans'], referencePath: path.join(workspaceDir, '.build', 'presentation', 'template-renderable.pptx'), referenceSha256: '69ebe909fe080578e52fa4c6e003cd34043879902aa94434b6cef28178653618' },
  verifyArtifactToolImport: true,
  receiptPath: path.join(stagingDir, 'Power9_Lab2_Presentation.validation.json')
});
console.log(JSON.stringify(result, null, 2));
