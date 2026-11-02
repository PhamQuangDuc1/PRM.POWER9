// Read-only Spark preflight using the user's existing Firebase CLI account.
// No credential is printed or copied into this repository.
const path = require('node:path');
const fs = require('node:fs');
const projectId = process.env.POWER9_FIREBASE_PROJECT || 'power9-office-se180724';
(async () => {
  let base = process.env.POWER9_FIREBASE_TOOLS_DIR;
  if (!base) {
    try { base = path.dirname(require.resolve('firebase-tools/lib/auth.js')); }
    catch {
      if (process.env.APPDATA) base = path.join(process.env.APPDATA, 'npm/node_modules/firebase-tools/lib');
    }
  }
  if (!base || !fs.existsSync(path.join(base, 'auth.js'))) throw new Error('Firebase CLI unavailable');
  const account = require(path.join(base, 'auth.js')).getGlobalDefaultAccount();
  if (!account) throw new Error('Firebase CLI sign-in required');
  await require(path.join(base, 'requireAuth.js')).requireAuth({project: projectId, user: account.user, tokens: account.tokens});
  const {Client} = require(path.join(base, 'apiv2.js'));
  const api = new Client({urlPrefix:'https://cloudbilling.googleapis.com', apiVersion:'v1'});
  const result = await api.get('/projects/' + encodeURIComponent(projectId) + '/billingInfo');
  if (typeof result.body.billingEnabled !== 'boolean') throw new Error('Unknown billing status');
  console.log(JSON.stringify({projectId, billingEnabled: result.body.billingEnabled}));
})().catch(() => { console.log('BILLING_STATUS_UNVERIFIED'); process.exitCode = 1; });
