import { createServer } from 'node:http';
import { v2 as cloudinary } from 'cloudinary';
import { initializeApp } from 'firebase-admin/app';
import { getAuth } from 'firebase-admin/auth';
import { reportHandler } from './handler.mjs';

const {
  FIREBASE_PROJECT_ID: projectId,
  CLOUDINARY_CLOUD_NAME: cloudName,
  CLOUDINARY_API_KEY: apiKey,
  CLOUDINARY_API_SECRET: apiSecret,
  PORT: port = '8787',
} = process.env;
if (![projectId, cloudName, apiKey, apiSecret].every(Boolean)) {
  throw new Error('Set the Firebase project ID and Cloudinary credentials in .env.');
}
if (process.env.FIREBASE_AUTH_EMULATOR_HOST) {
  throw new Error('Use the real Firebase project for Cloudinary uploads.');
}

const auth = getAuth(initializeApp({ projectId }));
cloudinary.config({ cloud_name: cloudName, api_key: apiKey, api_secret: apiSecret, secure: true });

async function savePdf(bytes, publicId) {
  await new Promise((resolve, reject) => {
    const stream = cloudinary.uploader.upload_stream({
      resource_type: 'image',
      type: 'authenticated',
      format: 'pdf',
      public_id: publicId,
      overwrite: false,
      timeout: 45000,
    }, (error, result) => {
      if (error) reject(error);
      else if (result?.public_id !== publicId) reject(new Error('Unexpected asset ID'));
      else resolve();
    });
    stream.on('error', reject);
    stream.end(bytes);
  });
  return cloudinary.utils.private_download_url(publicId, 'pdf', {
    resource_type: 'image',
    type: 'authenticated',
    expires_at: Math.floor(Date.now() / 1000) + 600,
  });
}

const server = createServer(
  { requestTimeout: 60000 },
  reportHandler({ verifyIdToken: (token) => auth.verifyIdToken(token), savePdf }),
);
server.listen(Number(port), '127.0.0.1', () => {
  console.log(`Power9 report backend listening on 127.0.0.1:${port}`);
});
