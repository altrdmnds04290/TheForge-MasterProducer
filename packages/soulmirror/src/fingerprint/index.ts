import crypto from 'crypto';
export function generateFingerprint(headers: Record<string,string>, ua: string, ip: string) {
  const base = `${ua}-${ip}-${headers['accept-language']||''}`;
  return crypto.createHash('sha256').update(base).digest('hex');
}
