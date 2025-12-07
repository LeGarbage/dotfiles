import Quickshell
import Quickshell.Bluetooth
import QtQuick
import "../components"

IconImage {
    source: getBluetoothIcon()

    function getBluetoothIcon() {
        if (!Bluetooth.defaultAdapter?.enabled) {
            return Quickshell.iconPath("bluetooth-disabled-symbolic");
        }
        if (Bluetooth.devices.values.some(d => d.connected)) {
            return Quickshell.iconPath("bluetooth-paired-symbolic");
        }

        return Quickshell.iconPath("bluetooth-active-symbolic");
    }
}
