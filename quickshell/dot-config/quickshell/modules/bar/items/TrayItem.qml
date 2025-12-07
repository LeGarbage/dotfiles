import Quickshell
import Quickshell.Services.SystemTray
import QtQuick
import "../components"

IconImage {
    id: root
    required property SystemTrayItem modelData
    source: modelData.icon

    MouseArea {
        id: mouse

        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true

        onClicked: event => {
            if (event.button === Qt.LeftButton) {
                root.modelData.activate();
            } else if (event.button === Qt.MiddleButton) {
                root.modelData.secondaryActivate();
            } else if (event.button === Qt.RightButton) {
                menuOpener.open();
            }
        }

        QsMenuAnchor {
            id: menuOpener

            anchor.window: mouse.QsWindow.window

            // Make the window show above the tray
            anchor.edges: Edges.Bottom | Edges.Right
            anchor.gravity: Edges.Top

            anchor.onAnchoring: {
                const window = mouse.QsWindow;
                // Give 5 pixels of margin above the tray item
                const widgetRect = window.contentItem.mapFromItem(mouse, 0, -5);

                anchor.rect = widgetRect;
            }

            menu: root.modelData.menu
        }

        Tooltip {
            parent: mouse
            // Only display if there's something to display
            visible: mouse.containsMouse && text
            delay: 1000
            text: root.modelData.tooltipTitle
        }
    }
}
