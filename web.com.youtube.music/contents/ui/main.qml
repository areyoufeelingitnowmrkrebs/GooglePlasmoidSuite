import QtQuick
import QtQuick.Window
import QtWebEngine
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami
import org.kde.notification
import org.kde.plasma.core as PlasmaCore
import "../../../web.com.google.account"

PlasmoidItem {
    id: root
    Plasmoid.status: PlasmaCore.Types.ActiveStatus
    compactRepresentation: Item {
        Image {
            anchors.fill: parent
            source: Qt.resolvedUrl("icon.png")
            fillMode: Image.PreserveAspectFit
            smooth: true
            mipmap: true
            cache: true
        }
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onClicked: root.expanded = !root.expanded
        }
    }
    fullRepresentation: Item {
        Layout.preferredWidth: Kirigami.Units.gridUnit * 62
        Layout.preferredHeight: Kirigami.Units.gridUnit * 49
        Plasmoid.backgroundHints: Plasmoid.StandardBackground
        WebEngineView {
            id: webview
            anchors.fill: parent
            url: "https://music.youtube.com"
            profile: Session.profile
            settings {
                allowRunningInsecureContent: false
                accelerated2dCanvasEnabled: true
                webGLEnabled: true
                showScrollBars: false
            }
            onPermissionRequested: permission => {
                permission.deny();
            }
            onNewWindowRequested: request => {
                if (request.userInitiated) {
                    Qt.openUrlExternally(request.requestedUrl);
                }
            }
        }
    }
}
