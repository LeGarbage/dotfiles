// Based on https://github.com/noctalia-dev/noctalia-shell/blob/main/Services/Keyboard/LockKeysService.qml
pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property bool capsLockOn: false
    property bool numLockOn: false
    property bool scrollLockOn: false

    Process {
        id: stateCheckProcess

        property string checkCommand: `caps=0; cat /sys/class/leds/input*::capslock/brightness 2>/dev/null | grep -q 1 && caps=1; echo "caps:\${caps}";
num=0; cat /sys/class/leds/input*::numlock/brightness 2>/dev/null | grep -q 1 && num=1; echo "num:\${num}";
scroll=0; cat /sys/class/leds/input*::scrolllock/brightness 2>/dev/null | grep -q 1 && scroll=1; echo "scroll:\${scroll}";`

        command: ["sh", "-c", checkCommand]

        stdout: StdioCollector {
            onStreamFinished: {
                let lines = this.text.trim().split('\n');
                for (let line of lines) {
                    let parts = line.split(':');
                    if (parts.length === 2) {
                        let key = parts[0];
                        let state = parts[1] === '1';

                        if (key === "caps") {
                            if (root.capsLockOn !== state) {
                                root.capsLockOn = state;
                            }
                        } else if (key === "num") {
                            if (root.numLockOn !== state) {
                                root.numLockOn = state;
                            }
                        } else if (key === "scroll") {
                            if (root.scrollLockOn !== state) {
                                root.scrollLockOn = state;
                            }
                        }
                    }
                }
            }
        }
    }

    Timer {
        interval: 200
        running: true
        repeat: true
        onTriggered: {
            if (!stateCheckProcess.running) {
                stateCheckProcess.running = true;
            }
        }
    }

    Component.onCompleted: {
        stateCheckProcess.running = true;
    }
}
