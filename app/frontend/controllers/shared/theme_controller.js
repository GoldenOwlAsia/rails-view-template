import { Controller } from '@hotwired/stimulus';
export default class extends Controller {
  static targets = ['checkbox'];

  initialize() {
    this.apply();
  }

  connect() {
    this.checkboxTarget.checked = this.theme === 'light';
  }

  apply() {
    document.documentElement.setAttribute('data-theme', this.theme);
  }

  switch() {
    const checkboxVal = this.checkboxTarget.checked;
    this.theme = checkboxVal ? 'light' : 'dark';
    this.apply();
  }

  get systemDefault() {
    return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
  }

  get theme() {
    return window.localStorage.getItem('theme') || (this.theme = this.systemDefault);
  }

  set theme(value) {
    window.localStorage.setItem('theme', value);
  }
}
