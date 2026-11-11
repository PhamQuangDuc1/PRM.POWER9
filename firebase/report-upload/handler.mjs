import { createHash } from 'node:crypto';

const maxBytes = 10 * 1024 * 1024;
const sha256 = (value) => createHash('sha256').update(value).digest('hex');

export function reportHandler({ verifyIdToken, savePdf }) {
  return async (request, response) => {
    const reply = (status, value) => {
      response.writeHead(status, {
        'content-type': 'application/json',
        'cache-control': 'no-store',
      });
      response.end(JSON.stringify(value));
    };
    if (request.method !== 'POST' || request.url !== '/reports') {
      return reply(404, { error: 'not_found' });
    }

    const token = /^Bearer (\S+)$/.exec(request.headers.authorization ?? '')?.[1];
    if (!token) return reply(401, { error: 'authentication_required' });
    let uid;
    try {
      ({ uid } = await verifyIdToken(token));
    } catch {
      return reply(401, { error: 'authentication_failed' });
    }
    if (!uid) return reply(401, { error: 'authentication_failed' });

    const length = Number(request.headers['content-length']);
    if (!Number.isSafeInteger(length) || length <= 0 || length > maxBytes) {
      return reply(413, { error: 'invalid_size' });
    }
    if (request.headers['content-type'] !== 'application/pdf') {
      return reply(415, { error: 'pdf_required' });
    }

    try {
      const chunks = [];
      for await (const chunk of request) chunks.push(chunk);
      const bytes = Buffer.concat(chunks);
      if (bytes.length !== length || !bytes.subarray(0, 5).equals(Buffer.from('%PDF-'))) {
        return reply(415, { error: 'pdf_required' });
      }
      const digest = sha256(bytes);
      const url = await savePdf(bytes, `power9-reports/${sha256(uid)}/${digest}`);
      return reply(201, { path: `reports/${uid}/${digest}.pdf`, url });
    } catch {
      return reply(502, { error: 'upload_failed' });
    }
  };
}
