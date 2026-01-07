import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "components"
import "widgets"

Variants {
    model: Quickshell.screens

    PanelWindow {
        id: root

        required property var modelData
        screen: modelData

        color: "#282C34"

        implicitHeight: wrapper.implicitHeight

        anchors {
            left: true
            right: true
            bottom: true
        }

        WrapperItem {
            id: wrapper

            leftMargin: 8
            rightMargin: 8
            topMargin: 5
            bottomMargin: 5

            child: layout

            anchors.fill: parent
        }

        RowLayout {
            id: layout
            spacing: 0

            RowLayout {
                Layout.alignment: Qt.AlignLeft
                Workspaces {
                    screen: root.modelData
                }
            }

            HorizontalLine {
                Layout.fillWidth: true
            }

            RowLayout {
                spacing: 0

                Layout.alignment: Qt.AlignRight
                Tray {
                    screen: root.modelData
                }
                HorizontalLine {
                    implicitWidth: 5
                    visible: extra.visible
                }
                Extra {
                    id: extra
                    screen: root.modelData
                }
                HorizontalLine {
                    implicitWidth: 5
                    visible: system.visible
                }
                System {
                    id: system
                    screen: root.modelData
                }
                HorizontalLine {
                    implicitWidth: 5
                    visible: clock.visible
                }
                Clock {
                    id: clock
                }
            }
        }
    }
}
