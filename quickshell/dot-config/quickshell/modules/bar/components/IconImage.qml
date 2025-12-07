import Quickshell.Hyprland
import Quickshell.Widgets
import QtQuick

IconImage {
    // HACK: To make qt scale icons correctly on fractional displays, we need to know the
    // scale of the current screen
    required property var screen
    property HyprlandMonitor monitor: Hyprland.monitorFor(screen)

    implicitSize: 16
    scale: monitor.scale
}
