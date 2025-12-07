import Quickshell
import Quickshell.Services.Pipewire
import "../components"

IconImage {
    id: root
    source: getAudioIcon()

    property PwNode sink: Pipewire.defaultAudioSink

    PwObjectTracker {
        id: tracker
        objects: [Pipewire.defaultAudioSink]

        onObjectsChanged: {
            root.sink = Pipewire.defaultAudioSink;
        }
    }

    function getAudioIcon() {
        let audio = sink?.audio;
        let volume = audio?.volume;

        if (audio?.muted || !volume) {
            return Quickshell.iconPath("audio-volume-muted-symbolic");
        }
        if (volume < 0.33) {
            return Quickshell.iconPath("audio-volume-low-symbolic");
        }
        if (volume < 0.67) {
            return Quickshell.iconPath("audio-volume-medium-symbolic");
        }
        return Quickshell.iconPath("audio-volume-high-symbolic");
    }
}
