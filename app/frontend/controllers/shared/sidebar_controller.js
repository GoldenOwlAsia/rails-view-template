import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['menu'];

  connect() {
    // Check if we're on a large screen
    if (window.innerWidth >= 1024) {
      // Initialize from cookie
      const isCollapsed = document.cookie.includes('sidebar_collapsed=true');
      if (isCollapsed) {
        document.documentElement.classList.add('drawer-mini');
      }
    }
  }

  toggleCollapse(event) {
    event.preventDefault();

    const isCollapsed = document.documentElement.classList.contains('drawer-mini');

    if (isCollapsed) {
      document.cookie = 'sidebar_collapsed=false; path=/';
      document.documentElement.classList.remove('drawer-mini');
    } else {
      document.cookie = 'sidebar_collapsed=true; path=/';
      document.documentElement.classList.add('drawer-mini');
    }
  }
}
