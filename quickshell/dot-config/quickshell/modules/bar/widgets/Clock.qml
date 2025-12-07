import QtQuick
import Quickshell
import "../components"

WidgetBase {
    id: clock
    StyledText {
        id: clockText

        color: "white"
        text: Qt.formatDateTime(systemClock.date, "hh:mm")
    }

    SystemClock {
        id: systemClock
        precision: SystemClock.Minutes
    }
}
