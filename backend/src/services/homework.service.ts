import fs from 'fs';
import path from 'path';

const MODEL_DIR = path.resolve(__dirname, '../../data');
const MODEL_PATH = path.join(MODEL_DIR, 'homework_model.bin');
const VERSION_FILE = path.join(MODEL_DIR, 'model_version.json');
const FEEDBACK_LOG_PATH = path.join(MODEL_DIR, 'homework_feedback.log');

interface Model {
  weights: Record<string, number>;
  bias: number;
  threshold: number;
}

let cachedModel: Model | null = null;

interface ModelInfo {
  version: number;
  lastRetrained: string | null;
}

function getCurrentInfo(): ModelInfo {
  if (!fs.existsSync(VERSION_FILE)) {
    return { version: 0, lastRetrained: null };
  }
  try {
    const raw = fs.readFileSync(VERSION_FILE, 'utf8');
    const data = JSON.parse(raw) as Partial<ModelInfo> & { version?: number };
    return {
      version: typeof data.version === 'number' ? data.version : 0,
      lastRetrained: typeof data.lastRetrained === 'string' ? data.lastRetrained : null,
    };
  } catch {
    return { version: 0, lastRetrained: null };
  }
}

function setModelInfo(info: ModelInfo): void {
  const dir = path.dirname(VERSION_FILE);
  fs.mkdirSync(dir, { recursive: true });
  fs.writeFileSync(VERSION_FILE, JSON.stringify(info));
}

export function getModelInfo(): ModelInfo {
  return getCurrentInfo();
}

export function getModelVersion(): number {
  return getCurrentInfo().version;
}

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

export async function retrainModel(): Promise<void> {
  if (!fs.existsSync(FEEDBACK_LOG_PATH)) {
    return;
  }
  const raw = fs.readFileSync(FEEDBACK_LOG_PATH, 'utf8').trim();
  if (!raw) {
    fs.unlinkSync(FEEDBACK_LOG_PATH);
    return;
  }
  const model = loadModel();
  const lr = 0.1;
  for (const line of raw.split('\n')) {
    const { text, expected } = JSON.parse(line) as {
      text: string;
      expected: boolean;
    };
    const tokens = text.toLowerCase().split(/\W+/);
    const score = tokens.reduce((s, t) => s + (model.weights[t] || 0), model.bias);
    const prob = 1 / (1 + Math.exp(-score));
    const error = (expected ? 1 : 0) - prob;
    for (const token of tokens) {
      if (!token) continue;
      model.weights[token] = (model.weights[token] || 0) + lr * error;
    }
    model.bias += lr * error;
  }
  const current = getCurrentInfo();
  const version = current.version + 1;
  fs.writeFileSync(MODEL_PATH, JSON.stringify(model));
  const versionedPath = path.join(MODEL_DIR, `homework_model_v${version}.bin`);
  fs.writeFileSync(versionedPath, JSON.stringify(model));
  setModelInfo({ version, lastRetrained: new Date().toISOString() });
  fs.unlinkSync(FEEDBACK_LOG_PATH);
  cachedModel = model;
}
