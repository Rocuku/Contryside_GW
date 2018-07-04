import QtQuick 2.2
import Material 0.1
import Material.ListItems 0.1 as ListItem
import Login_Gui 1.0

ApplicationWindow {
    id: root
    visible: true
    title: ""
    visibility: "Windowed"
    theme {
        primaryColor: Palette.colors["blue"]["500"]
        primaryDarkColor: Palette.colors["blue"]["700"]
        accentColor: Palette.colors["teal"]["500"]
        tabHighlightColor: "white"
    }
    property var pages: [
            "login", "mainmenu", "weather", "config", "userconfig", "webconfig"
    ]
    property string selectedPage: pages[0]
    property string hintText: "请刷卡"
    property int usernum
    property var config: [
        "", "", "", "", ""
    ]
    property string useruid;
    property bool loginflag: false;
    property string newuseruid;
    property bool newuserstate;

    Login_Gui{
        id:login_gui
        onSig_login_result:{
            var res = result.split('#')
            print(res)
            if(selectedPage === pages[0]){
                switch (res[0]){
                    case "-1":
                         root.hintText = "卡号错误，登录失败"
                         break
                    case "0" :
                        root.useruid = res[1]
                        root.loginflag = true
                        root.selectedPage = pages[1]
                        break
                }
            }
            else if (selectedPage === pages[4]){
                root.newuseruid = res[1]
                if(res[0] === "0") root.newuserstate = true
                else root.newuserstate = false
            }
        }
    }

    initialPage: Page {
        id:page
        title:""
        actionBar.maxActionCount: 3
        tabs: []
        actions: [
            Action {
                iconName: "action/home"
                name: "home界面"
                onTriggered: {
                    page.tabs = []
                    if(root.loginflag)
                        root.selectedPage = pages[1]
                    else
                        root.selectedPage = pages[0]
                }
            },
            Action {
                iconName: "action/settings"
                name: "设置"
                onTriggered: configpassDialog.show()
            },
            Action {
                iconName: "action/account_circle"
                name: "用户管理"
                onTriggered: userconfigpassDialog.show()
            }
        ]

        Loader {
            id: example
            anchors.fill: parent
            asynchronous: true
            visible: status == Loader.Ready
            source: {
                root.config = login_gui.slot_load_config()
                return Qt.resolvedUrl("%.qml").arg(root.selectedPage)
            }
        }
        ProgressCircle {
            anchors.centerIn: parent
            color: "#E91E63"
            visible: example.status == Loader.Loading
        }

        Dialog {
            id: configpassDialog
            title: "进入设置页面"
            hasActions: true
            Row {
                width: parent.width
                height: Units.dp(50)
                TextField {
                   id: passText
                   text: ""
                   placeholderText: "管理员密码"
                   floatingLabel: true
                   anchors.centerIn: parent
                   width: parent.width
                   echoMode: TextInput.Password
               }
            }
            onAccepted: {
                if(login_gui.slot_rootpass_check(passText.text))
                    root.selectedPage = pages[3]
                else
                    snackbar.open("密码错误！")
                passText.text = ""
            }
        }

        Dialog {
            id: userconfigpassDialog
            title: "进入用户管理页面"
            hasActions: true
            Row {
                width: parent.width
                height: Units.dp(50)
                TextField {
                   id: passText2
                   text: ""
                   placeholderText: "管理员密码"
                   floatingLabel: true
                   anchors.centerIn: parent
                   width: parent.width
                   echoMode: TextInput.Password
               }
            }
            onAccepted: {
                if(login_gui.slot_rootpass_check(passText2.text))
                    root.selectedPage = pages[4]
                else
                    snackbar.open("密码错误！")
                passText2.text = ""
            }
        }
        Snackbar {
            id: snackbar
        }
    }
}



