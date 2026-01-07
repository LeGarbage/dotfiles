pragma Singleton

import Quickshell
import Quickshell.Services.Notifications

Singleton {
    readonly property NotificationServer server: NotificationServer {
        onNotification: notification => {
            notification.tracked = true;
        }
    }
}
