import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami

PlasmoidItem {
    id: root

    Layout.minimumWidth: 220
    Layout.minimumHeight: 84
    Layout.preferredWidth: 300
    Layout.preferredHeight: 100

    property date now: new Date()

    Timer {
        interval: 60000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.now = new Date()
    }

    function cap(s) {
        return s.length ? s.charAt(0).toUpperCase() + s.slice(1) : s;
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 4

        Text {
            Layout.fillWidth: true
            text: root.cap(Qt.locale().dayName(root.now.getDay(), Locale.LongFormat))
            color: Kirigami.Theme.highlightColor
            font.family: "VT323"
            font.pixelSize: 34
            elide: Text.ElideRight
        }
        Text {
            Layout.fillWidth: true
            text: root.now.getDate() + " de " + root.cap(Qt.locale().monthName(root.now.getMonth(), Locale.LongFormat)) + " de " + root.now.getFullYear()
            color: Kirigami.Theme.textColor
            font.family: "Space Mono"
            font.pixelSize: 15
            elide: Text.ElideRight
        }
    }
}
