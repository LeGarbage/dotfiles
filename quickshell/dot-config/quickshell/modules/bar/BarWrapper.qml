pragma ComponentBehavior: Bound

import Quickshell
import QtQuick

Item {
    id: root

    required property ShellScreen screen

    Loader {
        id: content

        anchors {
            left: parent.left
            right: parent.right
        }

        anchors.fill: parent

        sourceComponent: Bar {
            screen: root.screen
        }
    }
}
