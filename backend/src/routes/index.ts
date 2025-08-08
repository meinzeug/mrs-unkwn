import { Router } from 'express';
import authRoutes from './auth.routes';
import userRoutes from './user.routes';
import homeworkRoutes from './homework.routes';

const router = Router();

router.use('/auth', authRoutes);
router.use('/user', userRoutes);
router.use('/homework', homeworkRoutes);

export default router;
