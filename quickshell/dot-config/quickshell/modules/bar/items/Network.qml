import Quickshell
import "../utils" as Utils
import "../components"

IconImage {
    source: getNetworkIcon()

    function getNetworkIcon() {
        if (!Utils.Network.active) {
            return Quickshell.iconPath("network-wireless-offline-symbolic");
        }
        let strength = Utils.Network.active.strength;
        if (strength < 20) {
            return Quickshell.iconPath("network-wireless-signal-none-symbolic");
        }
        if (strength < 40) {
            return Quickshell.iconPath("network-wireless-signal-low-symbolic");
        }
        if (strength < 60) {
            return Quickshell.iconPath("network-wireless-signal-ok-symbolic");
        }
        if (strength < 80) {
            return Quickshell.iconPath("network-wireless-signal-good-symbolic");
        }
        return Quickshell.iconPath("network-wireless-signal-excellent-symbolic");
    }
}
