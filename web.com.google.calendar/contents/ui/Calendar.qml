import QtQuick
import QtQuick.Layouts
import QtWebEngine
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami
import org.kde.notification

Item {
    id: root
    Layout.preferredWidth: Kirigami.Units.gridUnit * 200
    Layout.preferredHeight: Kirigami.Units.gridUnit * 49
    Plasmoid.backgroundHints: Plasmoid.StandardBackground
    Component {
        id: notificationComponent
        Notification {
            id: internalNotification
            property var webNotification
            componentName: "plasma_workspace"
            eventId: "notification"
            iconName: "im-google"
            autoDelete: true
            actions: [
                NotificationAction {
                    id: openAction
                    label: "Open"
                    onActivated: {
                        Plasmoid.expanded = true
                        if (internalNotification.webNotification) {
                            internalNotification.webNotification.click()
                        }
                    }
                }
            ]
        }
    }
    WebEngineView {
        id: webview
        anchors.fill: parent
        url: "https://calendar.google.com/r"
        profile: WebEngineProfile {
            storageName: "Calendar"
            offTheRecord: false
            isPushServiceEnabled: true
            onPresentNotification: notification => {
                var nativeNotification = notificationComponent.createObject(webview);
                if (nativeNotification) {
                    nativeNotification.title = notification.title;
                    nativeNotification.text = notification.message;
                    nativeNotification.webNotification = notification;
                    nativeNotification.sendEvent();
                }
            }
        }
        settings {
            javascriptCanAccessClipboard: true
            allowRunningInsecureContent: false
            accelerated2dCanvasEnabled: true
            webGLEnabled: true
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
                if (request.requestedUrl.toString().indexOf("calendar.google.com") > -1) {
                    webview.url = request.requestedUrl;
                } else {
                    Qt.openUrlExternally(request.requestedUrl);
                }
            }
        }
    }
}
