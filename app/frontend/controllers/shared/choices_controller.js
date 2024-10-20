import Choices from 'choices.js';
import { Controller } from '@hotwired/stimulus';

import 'choices.js/public/assets/styles/choices.min.css';

export default class extends Controller {
  static targets = ['select'];

  initialize() {
    window.choicesInstances = window.choicesInstances || {};
  }

  selectTargetConnected(currentSelectTarget) {
    let newInstance = false;
    let instanceId = this.getInstanceId(currentSelectTarget);
    const maxItemCount = currentSelectTarget.attributes.maxlength ? currentSelectTarget.attributes.maxlength.value : -1;

    if (!instanceId) {
      newInstance = true;
      instanceId = this.generateInstanceId(currentSelectTarget);
    }

    if (newInstance) {
      window.choicesInstances[instanceId] = new Choices(currentSelectTarget, {
        allowHTML: true,
        shouldSort: false,
        itemSelectText: '',
        removeItemButton: true,
        maxItemCount,
      });
    } else {
      window.choicesInstances[instanceId].init();
    }
  }

  selectTargetDisconnected(currentSelectTarget) {
    const instanceId = this.getInstanceId(currentSelectTarget);
    window.choicesInstances[instanceId]?.destroy();
  }

  generateInstanceId(element) {
    const uniqeId = `${Date.now().toString(36)}-${Math.random().toString(36).slice(2)}`;
    element.dataset.choicesId = uniqeId;
    return uniqeId;
  }

  getInstanceId(element) {
    return element.dataset.choicesId;
  }
}
