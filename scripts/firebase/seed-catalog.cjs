/* Local administrative seeding only. No server or service-account key is used.
 * Uses the installed firebase-tools CLI's authenticated client in memory.
 * firebase-tools internals may change; record the installed CLI version.
 */
const fs = require('node:fs');
const path = require('node:path');
const { execFileSync } = require('node:child_process');

async function main() {
  const projectIndex = process.argv.indexOf('--project');
  const project = projectIndex < 0 ? null : process.argv[projectIndex + 1];
  if (project !== 'power9-office-se180724') throw new Error('Pass --project power9-office-se180724 explicitly.');
  const npmRoot = process.env.FIREBASE_TOOLS_ROOT ||
    execFileSync(process.platform === 'win32' ? 'npm.cmd' : 'npm', ['root', '-g'], {
      encoding: 'utf8', shell: process.platform === 'win32', windowsHide: true,
    }).trim();
  const cliRoot = path.join(npmRoot, 'firebase-tools');
  const cli = (file) => require(path.join(cliRoot, 'lib', file));
  const { requireAuth } = cli('requireAuth.js');
  const account = cli('auth.js').getGlobalDefaultAccount();
  if (!account) throw new Error('Run firebase login first.');
  await requireAuth({ project, user: account.user, tokens: account.tokens });
  const { Client } = cli('apiv2.js');
  const api = new Client({ urlPrefix: 'https://firestore.googleapis.com', apiVersion: 'v1' });
  const catalog = JSON.parse(fs.readFileSync(path.resolve(__dirname, '../../firebase/catalog.json'), 'utf8'));
  const ids = new Set();
  const value = (input) => typeof input === 'string' ? { stringValue: input }
    : typeof input === 'boolean' ? { booleanValue: input }
    : Number.isInteger(input) ? { integerValue: String(input) }
    : Array.isArray(input) ? { arrayValue: { values: input.map(value) } }
    : (() => { throw new Error('Unsupported catalog type'); })();
  const writes = catalog.map(({id, ...data}) => {
    if (!/^[a-z0-9-]+$/.test(id) || ids.has(id) || data.steps.length !== 3 || data.minutes <= 0)
      throw new Error('Invalid or duplicated catalog entry');
    ids.add(id);
    const fields = Object.fromEntries(Object.entries(data).map(([key, item]) => [key, value(item)]));
    return { update: { name: `projects/${project}/databases/(default)/documents/activities/${id}`, fields },
      updateMask: { fieldPaths: Object.keys(fields) } };
  });
  await api.post(`/projects/${project}/databases/(default)/documents:commit`, {writes});
  const version = JSON.parse(fs.readFileSync(path.join(cliRoot, 'package.json'), 'utf8')).version;
  console.log(`Seeded ${writes.length} catalog activities to ${project}; firebase-tools ${version}. No user schedules/completions changed.`);
}

main().catch((error) => { console.error(error.message); process.exitCode = 1; });
