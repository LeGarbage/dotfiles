import Quickshell
import QtQuick
import "../components"
import "../utils" as Utils

IconImage {
    property bool active: source.toString() !== ""

    source: getLockIcon()
    visible: active

    function getLockIcon() {
        if (Utils.LockKeys.capsLockOn) {
            return Quickshell.iconPath("caps-lock-on-symbolic");
        }
        if (Utils.LockKeys.numLockOn) {
            return Quickshell.iconPath("num-lock-on-symbolic");
        }
        if (Utils.LockKeys.scrollLockOn) {
            return Quickshell.iconPath("scroll-lock-on-symbolic");
        }

        return "";
    }
}
