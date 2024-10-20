import { Controller } from '@hotwired/stimulus';
import { createIcons, icons } from 'lucide';

export default class extends Controller {
  connect() {
    // Caution, this will import all the icons and bundle them.
    createIcons({ icons });

    // Recommended way, prefer this: https://lucide.dev/guide/packages/lucide
  }
}
