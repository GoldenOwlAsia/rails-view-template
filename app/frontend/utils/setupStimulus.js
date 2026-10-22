import { Application } from '@hotwired/stimulus';
import { registerControllers } from 'stimulus-vite-helpers';

// Define application variable here for `vite-plugin-stimulus-hmr` using.
// https://github.com/ElMassimo/vite-plugin-stimulus-hmr/blob/main/src/index.ts#L26C30-L26C31
let application;

export function setupStimulus(controllerModules) {
  application = Application.start();
  registerControllers(application, controllerModules);
}
