import Quickshell
import QtQuick
import "../components"

PanelBase {
    content: StyledText {
        id: clockText

        color: "white"
        text: Qt.formatDateTime(systemClock.date, "hh:mm")
    }

    SystemClock {
        id: systemClock
        precision: SystemClock.Minutes
    }
}
