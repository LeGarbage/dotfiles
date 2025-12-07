import Quickshell
import QtQuick
import "../components"

PopupWindow {
    id: root

    required property Item parent
    required property string text
    property int delay: 0

    anchor.window: parent.QsWindow.window

    // Make the window show above the tray
    anchor.edges: Edges.Bottom | Edges.Right
    anchor.gravity: Edges.Top

    anchor.onAnchoring: {
        const window = parent.QsWindow;
        // Give 5 pixels of margin above the tray item
        const widgetRect = window.contentItem.mapFromItem(parent, 0, -5);

        anchor.rect = widgetRect;
    }

    implicitWidth: textItem.implicitWidth
    implicitHeight: textItem.implicitHeight

    StyledText {
        id: textItem
        text: root.text
        color: "black"
    }

    mask: Region {}
}
