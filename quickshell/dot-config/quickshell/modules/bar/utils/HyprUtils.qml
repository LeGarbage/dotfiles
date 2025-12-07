pragma Singleton

import Quickshell
import Quickshell.Hyprland
import QtQuick

Singleton {
    id: hyprland

    property list<HyprlandWorkspace> workspaces: Hyprland.workspaces.values

    function switchWorkspace(w: int): void {
        Hyprland.dispatch(`workspace ${w}`);
    }

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            switch (event.name) {
            case "createworkspacev2":
            case "destroyworkspacev2":
                {
                    hyprland.workspaces = Hyprland.workspaces.values;
                    break;
                }
            }
        }
    }
}
