import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.plasma5support as Plasma5Support

PlasmoidItem {
    id: root

    readonly property string scriptPath: "$HOME/.local/share/plasma/plasmoids/com.hcristosm.cassettefuturism.cavaviz/contents/bin/start_cava.sh"
    readonly property string confPath: "$HOME/.local/share/plasma/plasmoids/com.hcristosm.cassettefuturism.cavaviz/contents/bin/cava.conf"
    readonly property string barsFile: "/tmp/plasma-cavaviz-bars"

    property var bars: []
    property color barColor: Plasmoid.configuration.barColor

    Plasma5Support.DataSource {
        id: launcher
        engine: "executable"
        connectedSources: []
        onNewData: function(sourceName, data) {
            disconnectSource(sourceName)
        }
        function run(cmd) {
            connectSource(cmd)
        }
    }

    Plasma5Support.DataSource {
        id: poller
        engine: "executable"
        connectedSources: []
        onNewData: function(sourceName, data) {
            disconnectSource(sourceName)
            var out = (data["stdout"] || "").toString().trim()
            if (out.length > 0) {
                var parts = out.split(";").filter(function (s) { return s.length > 0 })
                root.bars = parts.map(function (s) { return parseInt(s, 10) || 0 })
            }
        }
        function poll() {
            connectSource("cat " + root.barsFile)
        }
    }

    Timer {
        interval: 33
        running: true
        repeat: true
        onTriggered: poller.poll()
    }

    function buildCavaConf() {
        var cfg = Plasmoid.configuration
        var lines = [
            "[general]",
            "bars = " + cfg.barCount,
            "framerate = " + cfg.framerate,
            "autosens = 1",
            "sensitivity = " + cfg.sensitivity,
            "",
            "[input]",
            "method = pulse",
            "source = auto",
            "",
            "[output]",
            "method = raw",
            "raw_target = \"/dev/stdout\"",
            "data_format = ascii",
            "ascii_max_range = 100",
            "bar_delimiter = 59",
            "frame_delimiter = 10",
            "",
            "[smoothing]",
            "noise_reduction = " + cfg.noiseReduction,
            ""
        ]
        return lines.join("\n")
    }

    function applyConfigAndRestart() {
        var b64 = Qt.btoa(buildCavaConf())
        var cmd = "bash -c \"systemctl --user stop plasma-cavaviz.service 2>/dev/null; " +
                  "echo " + b64 + " | base64 -d > " + root.confPath + "; " +
                  "sleep 0.3; " +
                  "systemd-run --user --collect --unit=plasma-cavaviz -- " + root.scriptPath + "\""
        launcher.run(cmd)
    }

    Connections {
        target: Plasmoid.configuration
        function onBarCountChanged() { root.applyConfigAndRestart() }
        function onFramerateChanged() { root.applyConfigAndRestart() }
        function onSensitivityChanged() { root.applyConfigAndRestart() }
        function onNoiseReductionChanged() { root.applyConfigAndRestart() }
    }

    Component.onCompleted: {
        root.applyConfigAndRestart()
    }

    Component.onDestruction: {
        launcher.run("systemctl --user stop plasma-cavaviz.service")
    }

    fullRepresentation: Item {
        Layout.minimumWidth: 220
        Layout.minimumHeight: 90
        Layout.preferredWidth: 320
        Layout.preferredHeight: 120
        clip: true

        Row {
            id: barsRow
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 6
            height: parent.height - 12
            spacing: Plasmoid.configuration.barSpacing

            Repeater {
                model: root.bars.length
                delegate: Rectangle {
                    width: (barsRow.width - (root.bars.length - 1) * barsRow.spacing) / Math.max(1, root.bars.length)
                    height: Math.max(2, Math.min(1, root.bars[index] / 100) * barsRow.height)
                    y: barsRow.height - height
                    radius: 1
                    color: root.barColor
                }
            }
        }
    }

    compactRepresentation: Item {
        clip: true

        Row {
            id: compactBarsRow
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 2
            height: parent.height - 4
            spacing: Math.max(1, Plasmoid.configuration.barSpacing / 2)

            Repeater {
                model: root.bars.length
                delegate: Rectangle {
                    width: (compactBarsRow.width - (root.bars.length - 1) * compactBarsRow.spacing) / Math.max(1, root.bars.length)
                    height: Math.max(1, Math.min(1, root.bars[index] / 100) * compactBarsRow.height)
                    y: compactBarsRow.height - height
                    color: root.barColor
                }
            }
        }
    }
}
