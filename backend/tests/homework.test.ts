import { detectAIContent } from '../src/services/homework.service';
import fs from 'fs';
import path from 'path';

async function run() {
  const modelDir = path.resolve(__dirname, '../data');
  const modelFile = path.join(modelDir, 'homework_model.bin');
  if (!fs.existsSync(modelFile)) {
    fs.mkdirSync(modelDir, { recursive: true });
    fs.writeFileSync(modelFile, '');
  }

  const result = await detectAIContent('This is a regular homework submission.');
  if (result !== false) {
    throw new Error('Expected false for regular homework text');
  }
  console.log('homework.test.ts passed');
}

run().catch((err) => {
  console.error(err);
  process.exit(1);
});
