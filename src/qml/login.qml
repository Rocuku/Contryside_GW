import QtQuick 2.2
import Material 0.1
import Material.ListItems 0.1 as ListItem
import Login_Gui 1.0

Item {
    id:login
    anchors.fill: parent
    Component.onCompleted: {
        root.hintText = "请登录"
   //     root.visibility = "FullScreen"
    }

    Column {
        anchors.centerIn: parent
        spacing: Units.dp(20)
        Label {
            id: hints
            font.weight: Font.Light
            text: root.hintText
            font.pixelSize: Units.dp(60)
            anchors {
                left: parent.left
            }
        }
    }
}


