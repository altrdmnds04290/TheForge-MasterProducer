import { generateFingerprint } from '../../packages/soulmirror/src/fingerprint/index';
console.log('fp', generateFingerprint({'accept-language':'en-US'}, 'UA', '127.0.0.1'));
