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

            WrapperRectangle {
                id: wrapper
                // Get the current workspace in the loop
                required property HyprlandWorkspace modelData
                property bool focused: workspaces.monitor.activeWorkspace === modelData

                margin: 2
                radius: height / 2

                // Show the wrapper on the focused workspace
                color: focused ? "white" : "transparent"

                StyledText {
                    // Don't display anything if the workspace doesn't exist
                    text: wrapper.modelData?.id || ""
                    // Color the focused workspace differently
                    color: wrapper.focused ? "#21252B" : "white"
                }
            }
        }
    }
}
