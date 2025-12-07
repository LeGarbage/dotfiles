import QtQuick.Layouts
import "../components"
import "../items"

WidgetBase {
    id: root
    required property var screen
    RowLayout {
        Audio {
            screen: root.screen
        }
        Network {
            screen: root.screen
        }
        Bluetooth {
            screen: root.screen
        }
        Battery {
            screen: root.screen
        }
    }
}
