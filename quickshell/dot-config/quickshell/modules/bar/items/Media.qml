import Quickshell
import Quickshell.Services.Mpris
import "../components"

IconImage {
    property bool active: source.toString() !== ""
    property MprisPlayer activePlayer

    source: getMediaIcon()
    visible: active

    function getMediaIcon() {
        let players = Mpris.players.values;
        for (let player of players) {
            if (player.playbackState === MprisPlaybackState.Playing) {
                activePlayer = player;
                return Quickshell.iconPath("media-playback-playing-symbolic");
            }
        }
        for (let player of players) {
            if (player.playbackState === MprisPlaybackState.Paused) {
                activePlayer = player;
                return Quickshell.iconPath("media-playback-paused-symbolic");
            }
        }
        for (let player of players) {
            if (player.playbackState === MprisPlaybackState.Stopped) {
                activePlayer = player;
                return Quickshell.iconPath("media-playback-stopped-symbolic");
            }
        }
        return "";
    }
}
