import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets
import QtQuick

PopupWindow {
    id: root

    property bool isOpen: false
    visible: isOpen

    color: "#282C34"

    required property Item content

    function close() {
        isOpen = false;
    }

    function open() {
        isOpen = true;
    }

    function toggle() {
        if (isOpen) {
            close();
        } else {
            open();
        }
    }

    WrapperRectangle {
        anchors.fill: parent

        radius: 4

        border.color: "white"
        border.width: 2

        color: "transparent"

        leftMargin: 8
        rightMargin: 8
        topMargin: 6
        bottomMargin: 6

        child: root.content
    }

    Item {
        Keys.onEscapePressed: {
            root.close();
        }

        focus: true
    }

    HyprlandFocusGrab {
        active: root.isOpen
        windows: [root]
        onCleared: root.close()
    }
}
