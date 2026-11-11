import assert from 'node:assert/strict';
import { once } from 'node:events';
import { createServer } from 'node:http';
import { test } from 'node:test';
import { reportHandler } from './handler.mjs';

test('report uploads require Firebase authentication and valid PDFs', async (t) => {
  const writes = [];
  const server = createServer(reportHandler({
    verifyIdToken: async (token) => {
      if (!['alice', 'bob'].includes(token)) throw new Error('Invalid token');
      return { uid: token };
    },
    savePdf: async (_, path) => {
      writes.push(path);
      return 'https://api.cloudinary.com/example';
    },
  }));
  server.listen(0, '127.0.0.1');
  await once(server, 'listening');
  t.after(() => server.close());

  const post = (token, body, type = 'application/pdf') =>
    fetch(`http://127.0.0.1:${server.address().port}/reports`, {
      method: 'POST',
      headers: {
        'content-type': type,
        ...(token ? { authorization: `Bearer ${token}` } : {}),
      },
      body,
    });

  const pdf = '%PDF-1.7\nfixture';
  assert.equal((await post(null, pdf)).status, 401);
  assert.equal((await post('invalid', pdf)).status, 401);
  assert.equal((await post('alice', pdf, 'text/plain')).status, 415);
  assert.equal((await post('alice', 'plain text')).status, 415);
  assert.equal(writes.length, 0);

  const first = await post('alice', pdf);
  assert.equal(first.status, 201);
  assert.match((await first.json()).path, /^reports\/alice\/[a-f0-9]{64}\.pdf$/);
  assert.equal((await post('alice', pdf)).status, 201);
  assert.equal((await post('bob', pdf)).status, 201);
  assert.equal(writes[0], writes[1]);
  assert.notEqual(writes[0], writes[2]);
});
