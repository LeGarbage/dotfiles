pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import QtQuick
import "../bar"
import "../../components/containers"

Variants {
    model: Quickshell.screens

    Scope {
        id: root

        required property ShellScreen modelData

        StyledWindow {
            id: win

            screen: root.modelData
            name: "drawers"

            // Pass through clicks everywhere except the bar
            mask: Region {
                item: bar
            }

            Exclusions {
                screen: root.modelData
                bar: bar
            }

            WlrLayershell.exclusionMode: ExclusionMode.Ignore

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            BarWrapper {
                id: bar

                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }

                implicitHeight: 30

                screen: root.modelData
            }
        }
    }
}
