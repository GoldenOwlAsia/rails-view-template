import { Controller } from '@hotwired/stimulus';
import flatpickr from 'flatpickr';
import merge from 'lodash/merge';

import 'flatpickr/dist/flatpickr.css';

export default class extends Controller {
  static targets = ['input'];

  static values = {
    options: {
      type: Object,
      default: {},
    },
  };

  inputTargetConnected(el) {
    flatpickr(
      el,
      merge(
        {
          altInput: true,
          altFormat: 'd-m-Y',
          dateFormat: 'Y-m-d',
          locale: {
            firstDayOfWeek: 1,
          },
        },
        this.optionsValue,
      ),
    );
  }

  inputTargetDisconnected(el) {
    el._flatpickr.destroy();
  }
}
