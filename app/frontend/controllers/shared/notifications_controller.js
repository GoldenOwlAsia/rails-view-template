import Notification from '@stimulus-components/notification';

export default class extends Notification {
  static targets = ['alert'];

  connect() {
    super.connect();
  }
}
