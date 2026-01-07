pragma ComponentBehavior: Bound

import Quickshell.Hyprland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../utils" as Utils
import "../components"

WidgetBase {
    id: workspaces

    required property var screen

    property HyprlandMonitor monitor: Hyprland.monitorFor(screen)

    topMargin: 4
    bottomMargin: 6

    RowLayout {
        Repeater {
            // For each workspace on this monitor
            model: Utils.HyprUtils.workspaces.filter(workspace => (workspace.monitor === workspaces.monitor))

            Item {
                id: root
                required property HyprlandWorkspace modelData

                implicitWidth: wrapper.implicitWidth
                implicitHeight: wrapper.implicitHeight

                WrapperRectangle {
                    id: wrapper
                    // Get the current workspace in the loop
                    property bool focused: workspaces.monitor.activeWorkspace === root.modelData

                    margin: 2
                    // radius: height / 2
                    radius: 4

                    // Show the wrapper on the focused workspace
                    color: mouse.containsMouse ? "#3E4451" : focused ? "white" : "transparent"

                    StyledText {
                        // Don't display anything if the workspace doesn't exist
                        text: root.modelData?.id || ""
                        // Color the focused workspace differently
                        color: wrapper.focused || mouse.containsMouse ? "#21252B" : "white"
                    }
                }
                MouseArea {
                    id: mouse

                    anchors.fill: wrapper
                    hoverEnabled: true

                    onClicked: {
                        root.modelData.activate();
                    }
                }
            }
        }
    }
}
