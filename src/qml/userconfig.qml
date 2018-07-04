import QtQuick 2.2
import QtQuick.Layouts 1.1
import Material 0.1
import Material.ListItems 0.1 as ListItem
import Material.Extras 0.1
import Config_Gui 1.0

Item {
    id: userconfig
    anchors.centerIn: parent
    property bool addnew: false
    property string newuid
    property int selectuser
    property var userinfo: [
        "", "", "", "", ""
    ]
    Component.onCompleted: {
        root.usernum = config_gui.slot_user_num()
    }
    Config_Gui{
        id:config_gui
     }
    Loader{
        id:newuserLoader
        asynchronous: true
        visible: false
        source: {
            if (root.newuseruid){
                if(userconfig.addnew){
                    if(root.newuserstate){
                        newuserhit.text = ""
                    }
                    else{
                        newuserhit.text = "请在网关上添加用户，卡号：" + root.newuseruid
                    }
                    userconfig.newuid = root.newuseruid
                    new_user_flush()
                    newusercheckDialog.close()
                    newuserDialog.show()
                }
                else{
                    newusercheckDialog.title = "卡号：" + root.newuseruid
                    newusercheckDialog.show()
                }
                root.newuseruid = ""
            }
        }
    }

    View {
        id: userview
        anchors {
            fill:parent
            margins: Units.dp(30)
        }
        elevation: 1
        Flickable {
            id: flickable
            clip: true
            anchors.fill: parent
            contentHeight:userlist.height
            Column {
                id:userlist
                width: flickable.width
                ListItem.Standard {
                    text: "新建用户"
                    onClicked: {
                        newusercheckDialog.show()
                        userconfig.addnew = true
                    }
                }
                Repeater {
                    model: root.usernum
                    delegate: ListItem.Standard {
                        text: config_gui.slot_user_data(index)[0] + "-" + config_gui.slot_user_data(index)[1]
                        onClicked:{
                            userconfig.selectuser = index
                            detail_show_flush()
                            userdetailDialog.show()
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
        id: newusercheckDialog
        title: "请刷一下新用户卡"
        onAccepted: {
            newusercheckDialog.title = "请刷一下新用户卡"
       }
        onRejected: {
            newusercheckDialog.title = "请刷一下新用户卡"
        }
    }

    Dialog {
        id: newuserDialog
        title: "添加新用户"
        hasActions: true
        Text {
            id: newuserhit
            text: ""
        }
        TextField {
            id: newuid
            placeholderText: "UID"
            floatingLabel: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: Units.dp(10)
            width: parent.width
        }
        TextField {
            id: newname
            placeholderText: "姓名"
            floatingLabel: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: Units.dp(10)
            width: parent.width
        }
        TextField {
            id: newphone
            placeholderText: "电话号码"
            floatingLabel: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: Units.dp(10)
            width: parent.width
        }
        TextField {
            id: newaddr
            placeholderText: "家庭住址"
            floatingLabel: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: Units.dp(10)
            width: parent.width
        }
        onAccepted: {
            new_user()
            userconfig.addnew = false
            userconfig.newuid = ""
       }
        onRejected: {
            userconfig.addnew = false
            userconfig.newuid = ""
        }
    }

    Dialog {
        id: userdetailDialog
        title: "用户详情"
        negativeButtonText: "编辑用户"
        Label {
            id: detailuidLable
            anchors.left: parent.left
            anchors.margins: Units.dp(10)
        }
        Label {
            id: detailnameLable
            anchors.left: parent.left
            anchors.margins: Units.dp(10)
        }
        Label {
             id: detailphoneLable
            anchors.left: parent.left
            anchors.margins: Units.dp(10)
        }
        Label {
            id:detailaddrLable
            anchors.left: parent.left
            anchors.margins: Units.dp(10)
        }
        onRejected:{
            edit_user_flush()
            usereditDialog.show()
        }
    }
    Dialog {
        id: usereditDialog
        title: "编辑用户"
        TextField {
            id: edituid
            placeholderText: "UID"
            floatingLabel: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: Units.dp(10)
            width: parent.width
        }
        TextField {
            id: editname
            placeholderText: "姓名"
            floatingLabel: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: Units.dp(10)
            width: parent.width
        }
        TextField {
            id: editphone
            placeholderText: "电话号码"
            floatingLabel: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: Units.dp(10)
            width: parent.width
        }
        TextField {
            id: editaddr
            placeholderText: "家庭住址"
            floatingLabel: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: Units.dp(10)
            width: parent.width
        }
        Button {
            id: userDeletebotton
            text: "删除用户"
            elevation: 1
            textColor: Palette.colors["grey"]["100"]
            backgroundColor: Palette.colors["red"]["300"]
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                userDeleteDialog.show()
            }
        }
        onAccepted: {
            edit_user()
            root.selectedPage = pages[0]
            root.selectedPage = pages[4]
        }
    }

    Dialog {
        id: userDeleteDialog
        title: "确认删除该用户？"
        hasActions: true
        onAccepted: {
            usereditDialog.close()
            config_gui.slot_user_delete(userconfig.selectuser)
            root.usernum = config_gui.slot_user_num()
       }
    }
    Snackbar {
        id: snackbar
    }

    function new_user_flush(){
        newuid.text = userconfig.newuid;
        newname.text = "";
        newphone.text = "";
        newaddr.text = "";
    }
    function detail_show_flush(){
        var info;
        info = config_gui.slot_user_data(userconfig.selectuser);
        detailuidLable.text =  "UID：" +  info[0];
        detailnameLable.text =  "姓名：" +  info[1];
        detailphoneLable.text =  "电话号码：" +  info[2];
        detailaddrLable.text =  "家庭住址：" +  info[3];
        print(userconfig.selectuser);
    }
    function edit_user_flush(){
        var info;
        info = config_gui.slot_user_data(userconfig.selectuser);
        edituid.text = info[0];
        editname.text = info[1];
        editphone.text = info[2];
        editaddr.text = info[3];
    }
    function new_user(){
        var res;
        userconfig.userinfo[0] = newuid.text;
        userconfig.userinfo[1] = newname.text;
        userconfig.userinfo[2] = newphone.text;
        userconfig.userinfo[3] = newaddr.text;
        res = config_gui.slot_user_add(userconfig.userinfo);
        if(res){
            root.usernum = config_gui.slot_user_num();
            snackbar.open("新建用户成功！")
        }
        else
            snackbar.open("该用户已存在！")
    }
    function edit_user(){
        var info = new Array(4);;
        info[0] = edituid.text;
        info[1] = editname.text;
        info[2] = editphone.text;
        info[3] = editaddr.text;
        config_gui.slot_user_edit(userconfig.selectuser, info);
    }
}


