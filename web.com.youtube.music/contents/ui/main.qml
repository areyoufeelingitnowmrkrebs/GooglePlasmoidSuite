import QtQuick
import QtQuick.Window
import QtWebEngine
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami
import org.kde.notification
import org.kde.plasma.core as PlasmaCore

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
        Layout.preferredWidth: Kirigami.Units.gridUnit * 61
        Layout.preferredHeight: Kirigami.Units.gridUnit * 49
        Plasmoid.backgroundHints: Plasmoid.StandardBackground
        WebEngineView {
            id: webview
            anchors.fill: parent
            url: "https://music.youtube.com"
            profile: WebEngineProfile {
                storageName: "Music"
                offTheRecord: false
            }
            settings {
                allowRunningInsecureContent: false
                accelerated2dCanvasEnabled: true
                webGLEnabled: true
            }
            onPermissionRequested: permission => {
                permission.deny();
            }
            onNewWindowRequested: request => {
                if (request.userInitiated) {
                    if (request.requestedUrl.toString().indexOf("music.youtube.com") > -1) {
                        webview.url = request.requestedUrl;
                    } else {
                        Qt.openUrlExternally(request.requestedUrl);
                    }
                }
            }
        }
    }
}
