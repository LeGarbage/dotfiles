pragma ComponentBehavior: Bound

import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts
import "../components"
import "../items"

WidgetBase {
    id: root
    required property var screen

    visible: repeater.count > 0

    leftMargin: 12
    rightMargin: 12

    RowLayout {
        spacing: 10
        Repeater {
            id: repeater
            model: SystemTray.items
            TrayItem {
                screen: root.screen
            }
        }
    }
}
