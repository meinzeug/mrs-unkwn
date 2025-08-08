import fs from 'fs';
import path from 'path';

const MODEL_PATH = path.resolve(__dirname, '../../data/homework_model.bin');

function modelExists(): boolean {
  return fs.existsSync(MODEL_PATH);
}

export async function detectAIContent(text: string): Promise<boolean> {
  if (!modelExists()) {
    throw new Error(`Model file not found at ${MODEL_PATH}. Run scripts/setup_homework_detection.sh to generate it.`);
  }
  return /chatgpt|ai-generated/i.test(text);
}
