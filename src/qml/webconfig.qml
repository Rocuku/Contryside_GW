import QtQuick 2.2
import QtQuick.Controls 1.2 as QuickControls
import QtQuick.Layouts 1.1
import Material 0.1
import Material.ListItems 0.1 as ListItem
import Material.Extras 0.1
import Qt.labs.folderlistmodel 2.1
import Config_Gui 1.0

Item {
    id:webconfig
    anchors.fill: parent
    property int webnum;
    property var webname:[];
    property var weburl:[];
    property int selectweb;
    Component.onCompleted: {
        webconfig.webnum = get_comment()
    }
    Config_Gui{
        id:config_gui
     }
    View {
        id: configlist
        anchors {
            top: webconfig.top
            left:webconfig.left
            right:webconfig.right
            bottom:webconfig.bottom
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
                    text: "添加新导航"
                    onClicked: addurlDialog.show()
                }
                Repeater {
                    model: webconfig.webnum
                    delegate: ListItem.Subtitled {
                        text: webconfig.webname[index]
                        subText:  webconfig.weburl[index]
                        onClicked:{
                            webconfig.selectweb = index
                            delwebDialog.show()
                        }
                    }
                }
            }
        }
        Scrollbar {
            flickableItem: flickable
        }
    }

    Dialog {
        id: delwebDialog
        title: "编辑导航"
        hasActions: true
        text:"点击OK删除导航"
        onAccepted: {
            config_gui.slot_comment_del(webconfig.webname[webconfig.selectweb], webconfig.weburl[webconfig.selectweb])
            webconfig.webnum = get_comment()
        }
    }
    Dialog {
        id: addurlDialog
        title: "添加导航"
        hasActions: true
        Row {
            width: parent.width
            height: Units.dp(56)
            TextField {
                id: newwebname
                placeholderText: "导航名称"
                floatingLabel: true
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.margins: Units.dp(10)
                width: parent.width
            }
        }
        TextField {
            id: newweburl
            placeholderText: "导航url"
            floatingLabel: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: Units.dp(10)
            width: parent.width
        }
        onAccepted: {
            config_gui.slot_comment_add(newwebname.text, newweburl.text)
            webconfig.webnum = get_comment()
        }
    }
    ActionButton {
        anchors {
            right: parent.right
            bottom: parent.bottom
            margins: Units.dp(20)
        }
        iconName: "av/replay"
        onClicked:{
            root.selectedPage = pages[3]
        }
    }
    function get_comment(){
        var comment;
        comment = config_gui.slot_comment_req();
        print("comment :" + comment);
        var object = JSON.parse(comment.toString());
        for(var i=0;i<object.website.length;i++){
            webconfig.webname[i] = object.website[i].name;
            webconfig.weburl[i] = object.website[i].url;
        }
        return i;
    }
}

