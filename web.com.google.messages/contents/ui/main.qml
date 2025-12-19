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
        Layout.preferredWidth: Kirigami.Units.gridUnit * 35
        Layout.preferredHeight: Kirigami.Units.gridUnit * 49
        Plasmoid.backgroundHints: Plasmoid.StandardBackground
        Component {
            id: notificationComponent
            Notification {
                id: internalNotification
                property var webNotification
                componentName: "plasma_workspace"
                eventId: "notification"
                iconName: "dialog-messages.svg"
                autoDelete: true
                actions: [
                    NotificationAction {
                        id: openAction
                        label: "Open"
                        onActivated: {
                            root.expanded = true
                            if (internalNotification.webNotification) {
                                internalNotification.webNotification.click()
                            }
                        }
                    }
                ]
            }
        }
        Connections {
            target: Session.profile
            function onPresentNotification(notification) {
                if (notification.origin.toString().indexOf("messages.google.com") !== -1) {
                    var nativeNotification = notificationComponent.createObject(root);
                    nativeNotification.title = notification.title;
                    nativeNotification.text = notification.message;
                    nativeNotification.webNotification = notification;
                    nativeNotification.sendEvent();
                }
            }
        }
        WebEngineView {
            id: webview
            anchors.fill: parent
            url: "https://messages.google.com/web"
            profile: Session.profile
            settings {
                javascriptCanAccessClipboard: true
                allowRunningInsecureContent: false
                accelerated2dCanvasEnabled: true
                webGLEnabled: true
                showScrollBars: false
            }
            onPermissionRequested: permission => {
                if (permission.permissionType === WebEnginePermission.PermissionType.Notifications) {
                    permission.grant();
                } else {
                    permission.deny();
                }
            }
            onNewWindowRequested: request => {
                if (request.userInitiated) {
                    Qt.openUrlExternally(request.requestedUrl);
                }
            }
        }
    }
}
