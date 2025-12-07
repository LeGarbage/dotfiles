import Quickshell
import Quickshell.Services.UPower
import QtQuick
import "../components"

IconImage {
    source: getBatteryIcon()

    function getBatteryIcon() {
        // Get the current percentage of the battery
        let percentage = Math.floor(UPower.displayDevice.percentage * 100);
        // Round the percentage to the nearest 10 and pad it with 0s to fetch the symbol
        let formatPerc = (Math.round(percentage / 10) * 10).toString().padStart(3, "0");
        // We want the icon to show charging when it's chargin and when it's full
        let charging = UPower.displayDevice.state === UPowerDeviceState.Charging || UPower.displayDevice.state === UPowerDeviceState.FullyCharged;
        let formatCharging = charging ? "-charging" : "";

        return Quickshell.iconPath(`battery-${formatPerc}${formatCharging}-symbolic`);
    }
}
// StyledText {
//     text: Math.floor(UPower.displayDevice.percentage * 100).toString() + "%"
//     color: "#E5C07B"
// }
