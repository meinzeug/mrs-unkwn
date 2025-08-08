import { retrainModel, getModelVersion } from '../backend/src/services/homework.service';

retrainModel()
  .then(() => {
    const version = getModelVersion();
    console.log(`Homework model retrained to version ${version}`);
  })
  .catch((err) => {
    console.error(err);
    process.exit(1);
  });
