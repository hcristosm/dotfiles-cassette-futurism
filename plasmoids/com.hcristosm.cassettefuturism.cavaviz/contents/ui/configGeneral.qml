import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Dialogs
import org.kde.kirigami as Kirigami

Kirigami.FormLayout {
    id: page

    property alias cfg_barColor: colorButton.color
    property alias cfg_barCount: barCountSpin.value
    property alias cfg_barSpacing: spacingSpin.value
    property alias cfg_framerate: framerateSpin.value
    property alias cfg_sensitivity: sensitivitySpin.value
    property alias cfg_noiseReduction: noiseSpin.value

    QQC2.Button {
        id: colorButton
        Kirigami.FormData.label: "Cor das barras:"
        property color color: "#00ff9c"
        implicitWidth: 70
        implicitHeight: 26
        text: ""
        background: Rectangle {
            color: colorButton.color
            radius: 3
            border.width: 1
            border.color: Kirigami.Theme.textColor
        }
        onClicked: colorDialog.open()

        ColorDialog {
            id: colorDialog
            selectedColor: colorButton.color
            onAccepted: colorButton.color = colorDialog.selectedColor
        }
    }

    QQC2.SpinBox {
        id: barCountSpin
        Kirigami.FormData.label: "Número de barras:"
        from: 4
        to: 64
        value: 24
    }

    QQC2.SpinBox {
        id: spacingSpin
        Kirigami.FormData.label: "Espaçamento entre barras (px):"
        from: 0
        to: 20
        value: 3
    }

    QQC2.SpinBox {
        id: framerateSpin
        Kirigami.FormData.label: "Taxa de quadros (fps):"
        from: 10
        to: 144
        value: 60
    }

    QQC2.SpinBox {
        id: sensitivitySpin
        Kirigami.FormData.label: "Sensibilidade (%):"
        from: 10
        to: 400
        value: 100
    }

    QQC2.SpinBox {
        id: noiseSpin
        Kirigami.FormData.label: "Redução de ruído (%):"
        from: 0
        to: 100
        value: 55
    }
}
