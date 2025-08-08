import fs from 'fs';
import path from 'path';

const MODEL_PATH = path.resolve(__dirname, '../../data/homework_model.bin');
const FEEDBACK_LOG_PATH = path.resolve(
  __dirname,
  '../../data/homework_feedback.log'
);

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

export interface EvaluationSample {
  text: string;
  label: boolean;
}

export async function evaluateModel(
  samples: EvaluationSample[]
): Promise<{ accuracy: number; total: number; correct: number }> {
  let correct = 0;
  for (const sample of samples) {
    const predicted = await detectAIContent(sample.text);
    if (predicted === sample.label) {
      correct++;
    } else {
      logFeedback(sample.text, sample.label, predicted);
    }
  }
  const total = samples.length;
  return {
    accuracy: total ? correct / total : 0,
    total,
    correct,
  };
}

export async function submitFeedback(
  text: string,
  expected: boolean
): Promise<boolean> {
  const predicted = await detectAIContent(text);
  if (predicted !== expected) {
    logFeedback(text, expected, predicted);
  }
  return predicted;
}

function logFeedback(text: string, expected: boolean, predicted: boolean): void {
  const dir = path.dirname(FEEDBACK_LOG_PATH);
  fs.mkdirSync(dir, { recursive: true });
  const entry = {
    text,
    expected,
    predicted,
    timestamp: new Date().toISOString(),
  };
  fs.appendFileSync(FEEDBACK_LOG_PATH, JSON.stringify(entry) + '\n');
}
