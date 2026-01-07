import QtQuick
import Quickshell
import "../components"
import "../panels"

Item {
    implicitWidth: clock.implicitWidth
    implicitHeight: clock.implicitHeight

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

    MouseArea {
        anchors.fill: clock

        onClicked: {
            timePanel.toggle()
        }
    }

    TimePanel {
        id: timePanel

        anchor {
            item: clock

            edges: Edges.Bottom | Edges.Right
            gravity: Edges.Top

            onAnchoring: {
                timePanel.anchor.rect = clock.mapFromItem(clock, 0, -10);
            }
        }
    }
}
