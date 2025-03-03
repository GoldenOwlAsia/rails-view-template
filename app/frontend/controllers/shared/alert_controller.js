import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  connect() {
    this.remove();
  }

  remove(event = null) {
    let timeout = 3000;
    if (event) timeout = parseInt(event.target.getAttribute('data-timer'));
    // transition out
    setTimeout(() => {
      this.element.classList.add(
        'transition',
        'ease-in-out',
        'duration-300',
        'transform',
        'translate-x-full',
        'opacity-0',
      );
    }, timeout);

    // Remove element from DOM after transition
    setTimeout(() => {
      this.element.remove();
    }, timeout + 100);
  }
}
