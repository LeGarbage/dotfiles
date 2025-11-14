import QtQuick
import Quickshell
import Quickshell.Widgets

Rectangle {
    id: clock

    color: "red"

    implicitWidth: wrapper.width
    implicitHeight: wrapper.height

    WrapperItem {
        id: wrapper

        margin: 3
        child: clockText

        anchors.fill: parent
    }

    Text {
        id: clockText

        font.family: "CommitMonoNerdFont"
        font.pointSize: 14
        text: Qt.formatDateTime(systemClock.date, "hh:mm")
    }

    SystemClock {
        id: systemClock
        precision: SystemClock.Minutes
    }
}
