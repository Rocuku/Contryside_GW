import QtQuick 2.2
import QtQuick.Controls 1.2 as QuickControls
import QtQuick.Layouts 1.1
import Material 0.1
import Material.ListItems 0.1 as ListItem
import Material.Extras 0.1
import Qt.labs.folderlistmodel 2.1
import Config_Gui 1.0
import "qrc:/js/weather.js" as Weather


Item {
    id:config
    anchors.fill: parent
    Component.onCompleted: {
        config.webnum = get_comment()
    }
    Config_Gui{
        id:config_gui
     }
    View {
        id: configlist
        anchors {
            top: config.top
            left:config.left
            right:config.right
            bottom:config.bottom
            bottomMargin:Units.dp(100)
            margins: Units.dp(30)
        }
        elevation: 1
        Flickable {
            id: flickable
            clip: true
            anchors.fill: parent
            contentHeight:configcolumn.height
            Column {
                id:configcolumn
                width: flickable.width
                ListItem.Standard {
                    id:changepassconfig
                    text: "修改密码"
                    onClicked: changepassDialog.show()
                }
                ListItem.Standard {
                    id: header
                    text: "修改推荐网站"
                    onClicked: root.selectedPage = pages[5]
                }
                ListItem.Subtitled {
                    id:serialconfig
                    text: "串口号"
                    subText:  root.config[0]
                    onClicked: serialDialog.show()
                }
                ListItem.Subtitled {
                    id:ipconfig
                    text: "网关ip地址"
                    subText:  root.config[1]
                    onClicked: ipDialog.show()
                }
                ListItem.Subtitled {
                    id:interfaceconfig
                    text: "网卡号"
                    subText:  root.config[3]
                    onClicked: interfaceDialog.show()
                }
                ListItem.Subtitled {
                    id:positionconfig
                    text: "所在地"
                    subText:  root.config[2]
                    onClicked: positionDialog.show()
                }
                ListItem.Subtitled {
                    id:qqposconfig
                    text: "qq.exe位置"
                    subText:  root.config[4]
                    onClicked: qqposDialog.show()
                }
            }
        }
        Scrollbar {
            flickableItem: flickable
        }
    }

    View {
        id: resetlist
        anchors {
            top: configlist.bottom
            left:config.left
            right:config.right
            margins: Units.dp(30)
        }
        elevation: 1
        Column {
            anchors.fill: parent
            ListItem.Standard {
                id:resetconfig
                text: "重置所有设定"
                onClicked: resetDialog.show()
                action: Icon {
                    anchors.centerIn: parent
                    name: "alert/warning"
                    size: Units.dp(32)
                }
            }
        }
    }

    Dialog {
        id: serialDialog
        title: "串口设置"
        hasActions: true
        Row {
            width: parent.width
            height: Units.dp(56)
             TextField {
                id: serialPortText
                text: root.config[0]
                anchors.centerIn: parent
                width: parent.width
            }
        }
        onAccepted: {
            config_gui.slot_change_serialport(serialPortText.text)
            root.config = login_gui.slot_load_config()
            login_gui.slot_load_config()
            snackbar.open("串口号已修改")
       }
    }
    Dialog {
        id: ipDialog
        title: "网关ip设置"
        hasActions: true
        Row {
            width: parent.width
            height: Units.dp(56)
             TextField {
                id: ipaddrText
                text: root.config[1]
                anchors.centerIn: parent
                width: parent.width
            }
        }
        onAccepted: {
            config_gui.slot_change_ipaddr(ipaddrText.text)
            root.config = login_gui.slot_load_config()
            login_gui.slot_load_config()
            snackbar.open("网关ip已修改")
       }
    }

    Dialog {
        id: interfaceDialog
        title: "网卡号设置"
        hasActions: true
        Row {
            width: parent.width
            height: Units.dp(56)
             TextField {
                id: interfaceText
                text: root.config[3]
                anchors.centerIn: parent
                width: parent.width
            }
        }
        onAccepted: {
            config_gui.slot_change_interface(interfaceText.text)
            root.config = login_gui.slot_load_config()
            snackbar.open("网卡号已修改")
       }
    }
    Dialog {
        id: positionDialog
        title: "位置设置"
        hasActions: true
        Row {
            width: parent.width
            height: Units.dp(56)
             TextField {
                id: positionText
                text: root.config[2]
                anchors.centerIn: parent
                width: parent.width
            }
        }
        onAccepted: {
            config_gui.slot_change_position(positionText.text)
            root.config = login_gui.slot_load_config()
            snackbar.open("位置已修改")
       }
    }

    Dialog {
        id: qqposDialog
        title: "位置设置"
        hasActions: true
        Row {
            width: parent.width
            height: Units.dp(56)
            Text {
                text: "请务必保留双引号"
            }
             TextField {
                id: qqposText
                text: root.config[4]
                anchors.centerIn: parent
                width: parent.width
            }
        }
        onAccepted: {
            config_gui.slot_change_qqpos(qqposText.text)
            root.config = login_gui.slot_load_config()
            snackbar.open("qq.exe位置已修改")
       }
    }

    Dialog {
        id: changepassDialog
        title: "修改root密码"
        hasActions: true
        Row {
            width: parent.width
            height: Units.dp(56)
             TextField {
                id: changepassText
                text: ""
                echoMode: TextInput.Password
                anchors.centerIn: parent
                width: parent.width
            }
        }
        onAccepted: {
            snackbar.open("密码已修改")
            config_gui.slot_change_pass(changepassText.text)
            root.selectedPage = pages[0]
       }
}

    Dialog {
        id: resetDialog
        title: "重置所有设定(包括密码)"
        hasActions: true
        onAccepted: {
            snackbar.open("已重置所有设定")
            config_gui.slot_init()
            root.config = login_gui.slot_load_config()
            root.selectedPage = pages[0]
       }
    }
    Snackbar {
        id: snackbar
    }
}

