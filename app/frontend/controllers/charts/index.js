import { setupStimulus } from '@/utils/setupStimulus';

setupStimulus(import.meta.glob('./**/*_controller.js', { eager: true }));
