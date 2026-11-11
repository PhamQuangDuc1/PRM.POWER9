import { readFile } from 'node:fs/promises';

const project = 'demo-power9';
const auth = 'http://127.0.0.1:9099';
const documents = `http://127.0.0.1:8080/v1/projects/${project}/databases/(default)/documents`;
const email = 'admin@power9.test';

async function request(url, options = {}) {
  const response = await fetch(url, options);
  if (!response.ok) {
    throw new Error(`Local Emulator request failed (${response.status}): ${await response.text()}`);
  }
  return response.json();
}

const account = await request(
  `${auth}/identitytoolkit.googleapis.com/v1/accounts:signInWithIdp?key=demo-api-key`,
  {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      requestUri: 'http://127.0.0.1:8081/',
      postBody: new URLSearchParams({
        providerId: 'google.com',
        id_token: JSON.stringify({ sub: email, email, email_verified: true, name: 'Admin thử nghiệm' }),
      }).toString(),
      returnSecureToken: true,
    }),
  },
);

const headers = { Authorization: 'Bearer owner', 'Content-Type': 'application/json' };
await request(`${documents}/users/${encodeURIComponent(account.localId)}?updateMask.fieldPaths=role`, {
  method: 'PATCH',
  headers,
  body: JSON.stringify({ fields: { role: { stringValue: 'admin' } } }),
});

function firestoreValue(value) {
  if (Array.isArray(value)) return { arrayValue: { values: value.map(firestoreValue) } };
  if (typeof value === 'boolean') return { booleanValue: value };
  if (Number.isInteger(value)) return { integerValue: String(value) };
  return { stringValue: value };
}

const catalog = JSON.parse(await readFile(new URL('./catalog.json', import.meta.url), 'utf8'));
let created = 0;
for (const { id, ...activity } of catalog) {
  const response = await fetch(`${documents}/activities?documentId=${encodeURIComponent(id)}`, {
    method: 'POST',
    headers,
    body: JSON.stringify({
      fields: Object.fromEntries(Object.entries(activity).map(([key, value]) => [key, firestoreValue(value)])),
    }),
  });
  if (response.status === 409) continue;
  if (!response.ok) throw new Error(`Catalog seed failed for ${id}: ${await response.text()}`);
  created++;
}

console.log(`Local Admin ready: ${email}. Catalog entries added: ${created}.`);
