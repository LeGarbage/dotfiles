pragma ComponentBehavior: Bound

import QtQuick.Layouts
import "../components"
import "../items"

WidgetBase {
    id: root

    required property var screen

    // NOTE: For some reason, Quickshell does not bind the visible property reactively.
    //       As a workaround, the proxy property "active" is used. All children of this
    //       widget must define an active property if they wish to be accounted for in the
    //       visibility check
    visible: layout.children.some(c => c.active)

    RowLayout {
        id: layout

        Notifications {
            screen: root.screen
        }

        Media {
            screen: root.screen
        }

        LockKeys {
            screen: root.screen
        }
    }
}
