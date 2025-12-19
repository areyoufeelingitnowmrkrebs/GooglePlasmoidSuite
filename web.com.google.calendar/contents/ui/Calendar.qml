import QtQuick
import QtQuick.Layouts
import QtWebEngine
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami
import org.kde.notification
import "../../../web.com.google.account"

Item {
    id: root
    signal requestExpand()
    Layout.preferredWidth: Kirigami.Units.gridUnit * 69
    Layout.preferredHeight: Kirigami.Units.gridUnit * 49
    Plasmoid.backgroundHints: Plasmoid.StandardBackground
    Component {
        id: notificationComponent
        Notification {
            id: internalNotification
            property var webNotification
            componentName: "plasma_workspace"
            eventId: "notification"
            iconName: "view-calendar.svg"
            autoDelete: true
            actions: [
                NotificationAction {
                    id: openAction
                    label: "Open"
                    onActivated: {
                        root.requestExpand()
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
            if (notification.origin.toString().indexOf("calendar.google.com") !== -1) {
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
        url: "https://calendar.google.com/r"
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
