import { Router } from 'express';
import authRoutes from './auth.routes';
import userRoutes from './user.routes';
import homeworkRoutes from './homework.routes';
import schoolRoutes from './school.routes';
import organizationRoutes from './organization.routes';
import externalRoutes from './external.routes';
import developerRoutes from './developer.routes';
import adaptiveRoutes from './adaptive.routes';
import familyRoutes from './family.routes';

const router = Router();

router.use('/auth', authRoutes);
router.use('/user', userRoutes);
router.use('/homework', homeworkRoutes);
router.use('/school', schoolRoutes);
router.use('/organizations', organizationRoutes);
router.use('/external', externalRoutes);
router.use('/developer', developerRoutes);
router.use('/adaptive', adaptiveRoutes);
router.use('/family', familyRoutes);

export default router;
