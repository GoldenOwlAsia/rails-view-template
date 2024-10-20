import { Controller } from '@hotwired/stimulus';
import flatpickr from 'flatpickr';
import rangePlugin from 'flatpickr/dist/plugins/rangePlugin';

import 'flatpickr/dist/flatpickr.css';

export default class extends Controller {
  static targets = ['dateStart', 'dateEnd'];

  connect() {
    if (this.hasDateStartTarget && this.hasDateEndTarget) {
      flatpickr(this.dateStartTarget, {
        altInput: true,
        altFormat: 'd-m-Y',
        dateFormat: 'Y-m-d',
        mode: 'range',
        plugins: [new rangePlugin({ input: this.dateEndTarget })],
      });
    }
  }
}
