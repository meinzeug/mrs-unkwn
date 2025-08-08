import fs from 'fs';
import path from 'path';

const MODEL_PATH = path.resolve(__dirname, '../../data/homework_model.bin');

interface Model {
  weights: Record<string, number>;
  bias: number;
  threshold: number;
}

let cachedModel: Model | null = null;

function loadModel(): Model {
  if (!fs.existsSync(MODEL_PATH)) {
    throw new Error(`Model file not found at ${MODEL_PATH}. Run scripts/setup_homework_detection.sh to generate it.`);
  }
  if (!cachedModel) {
    const raw = fs.readFileSync(MODEL_PATH, 'utf8');
    try {
      cachedModel = JSON.parse(raw) as Model;
    } catch {
      throw new Error(`Failed to parse model file at ${MODEL_PATH}`);
    }
  }
  return cachedModel;
}

export async function detectAIContent(text: string): Promise<boolean> {
  const model = loadModel();
  const tokens = text.toLowerCase().split(/\W+/);
  const score = tokens.reduce((sum, t) => sum + (model.weights[t] || 0), model.bias);
  const probability = 1 / (1 + Math.exp(-score));
  return probability >= model.threshold;
}
