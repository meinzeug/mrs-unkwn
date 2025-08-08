import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import { config } from './config/config';
import routes from './routes';
import { errorHandler } from './middleware/error.middleware';
import { responseHandler } from './middleware/response.middleware';

const app = express();

app.use(cors());
app.use(helmet());
app.use(morgan('combined'));
app.use(express.json());
app.use(responseHandler);

app.use('/api', routes);

app.get('/health', (_req, res) => {
  res.success({ status: 'ok' }, 'Health check');
});

app.use(errorHandler);

const PORT = process.env.PORT || 3000;
if (config.nodeEnv !== 'test') {
  app.listen(PORT, () => {
    console.log(`Server listening on port ${PORT} in ${config.nodeEnv} mode`);
  });
}

export default app;

