import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['menu'];

  connect() {
    // Initialize sidebar state from cookie
    const isCollapsed = document.cookie.includes('sidebar_collapsed=true');
    if (isCollapsed) {
      document.documentElement.classList.add('drawer-mini');
    }
  }

  // Toggle sidebar collapse state
  toggleCollapse() {
    const isCollapsed = document.cookie.includes('sidebar_collapsed=true');

    if (isCollapsed) {
      document.cookie = 'sidebar_collapsed=false; path=/';
      document.documentElement.classList.remove('drawer-mini');
    } else {
      document.cookie = 'sidebar_collapsed=true; path=/';
      document.documentElement.classList.add('drawer-mini');
    }
  }
}
