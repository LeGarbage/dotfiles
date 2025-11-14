import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "components"

PanelWindow {

    color: "blue"

    anchors {
        left: true
        right: true
        bottom: true
    }

    implicitHeight: wrapper.implicitHeight

    required property ShellScreen screen

    WrapperItem {
        id: wrapper

        topMargin: 7
        bottomMargin: 7
        leftMargin: 10
        rightMargin: 10
        child: bar

        anchors.fill: parent
    }

    RowLayout {
        id: bar

        Clock {}

        Item {
            Layout.fillWidth: enabled
        }

        Clock {}
    }
}
