import { application } from './application';
import { registerControllers } from 'stimulus-vite-helpers';

const controllers = import.meta.glob('./**/*_controller.js', { eager: true });
const compControllers = import.meta.glob('../components/**/*_controller.js', {
  eager: true,
});

// Register Stimulus controllers
registerControllers(application, controllers);
registerControllers(application, compControllers);
