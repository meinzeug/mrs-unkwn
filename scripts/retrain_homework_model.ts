import { retrainModel, getModelInfo } from '../backend/src/services/homework.service';

retrainModel()
  .then(() => {
    const info = getModelInfo();
    console.log(
      `Homework model retrained to version ${info.version} at ${info.lastRetrained}`
    );
  })
  .catch((err) => {
    console.error(err);
    process.exit(1);
  });
