import Quickshell
import QtQuick
import "../components"
import "../utils"

IconImage {
    property bool active: source.toString()

    source: getNotificationIcon()
    visible: active

    function getNotificationIcon() {
        if (Notifications.server.trackedNotifications.values.length > 0) {
            return Quickshell.iconPath("notification-active-symbolic");
        }
        return "";
    // return Quickshell.iconPath("notification-inactive-symbolic");
    }
}
