import { retrainModel } from '../backend/src/services/homework.service';

retrainModel()
  .then(() => console.log('Homework model retrained'))
  .catch((err) => {
    console.error(err);
    process.exit(1);
  });
