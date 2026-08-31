import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Layouts
import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami

KCM.SimpleKCM {
    id: root

    property alias cfg_apiKey: apiKeyField.text
    property alias cfg_refreshIntervalMinutes: refreshSpin.value
    property alias cfg_reduceMotion: reduceMotionCheck.checked
    property alias cfg_homeLat: homeLatField.text
    property alias cfg_homeLon: homeLonField.text

    Kirigami.FormLayout {
        Controls.TextField {
            id: apiKeyField
            Kirigami.FormData.label: "N2YO API key:"
            placeholderText: "leave empty for decorative-only globe (no satellites)"
        }

        Controls.Label {
            Kirigami.FormData.label: " "
            text: "Free key at n2yo.com/api — only ISS, Hubble and Tiangong\nare queried, once per refresh interval."
            font.pixelSize: Kirigami.Theme.smallFont.pixelSize
            opacity: 0.7
        }

        Controls.SpinBox {
            id: refreshSpin
            Kirigami.FormData.label: "Satellite refresh (minutes):"
            from: 5
            to: 60
            stepSize: 5
        }

        Controls.CheckBox {
            id: reduceMotionCheck
            Kirigami.FormData.label: "Reduce motion:"
            text: "Freeze rotation (globe stays static)"
        }

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
        }

        Controls.TextField {
            id: homeLatField
            Kirigami.FormData.label: "Your latitude:"
            placeholderText: "e.g. -23.547121 (leave empty to hide marker)"
        }

        Controls.TextField {
            id: homeLonField
            Kirigami.FormData.label: "Your longitude:"
            placeholderText: "e.g. -46.637186"
        }
    }
}
