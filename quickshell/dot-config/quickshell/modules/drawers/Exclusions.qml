pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import "../../components/containers"

Scope {
    id: root

    required property ShellScreen screen
    required property Item bar

    ExclusionZone {
        anchors.bottom: true
    }

    component ExclusionZone: StyledWindow {
        screen: root.screen
        name: "border-exclusion"
        mask: Region {}
        implicitWidth: 1
        implicitHeight: 1
    }
}
