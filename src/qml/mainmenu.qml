import QtQuick 2.2
import Material 0.1
import Material.ListItems 0.1 as ListItem
import QtQuick.Layouts 1.1
import Menu_Gui 1.0
import "qrc:/js/weather.js" as Weather

Item {
    id: menu
    anchors.centerIn: parent
    property int selectweb;
    property int webnum;
    property var webname:[];
    property var weburl:[];
    property int userwebnum;
    property var userwebname:[];
    property var userweburl:[];
   Menu_Gui{
            id:menu_gui
    }
   Component.onCompleted: {
        get_username()
        root.config = login_gui.slot_load_config()
        get_comment()
        Weather.weather_api.input.city = root.config[2]
        Weather.weather_api.get_weather(show_weather)
   }

   View {
       id: sidebar
       anchors {
           top: menu.top
           left:menu.left
           bottom:menu.bottom
           margins: Units.dp(30)
       }
        width: Units.dp(120)
        elevation: 1
        Flickable {
            id: flickable
            clip: true
            anchors.fill: parent
            contentHeight:webcolumn.height
            Column {
                id:webcolumn
                width: flickable.width
                ListItem.Subheader {
                    text: "推荐网站"
                }
                Repeater {
                    model: menu.webnum
                    delegate: ListItem.Standard {
                        text: menu.webname[index]
                        onClicked:{
                            menu_gui.slot_sys_req("explorer", menu.weburl[index])
                        }
                    }
                }
                Label {
                    style: "subheading"
                    text: "_________________"
                    color :Palette.colors["blue"]["900"]
                    anchors.left: parent.left
                }
                ListItem.Subheader {
                    text: "个人收藏"
                }
                Repeater {
                    model: userwebnum
                    delegate: ListItem.Standard {
                        text: menu.userwebname[index]
                        MouseArea {
                            anchors.fill: parent;
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            onClicked: {
                                if (mouse.button == Qt.RightButton) {
                                    menu.selectweb = index
                                    delwebDialog.show()
                                }
                                else{
                                    menu_gui.slot_sys_req("explorer", menu.userweburl[index])
                                }
                            }
                        }
                    }
                }
            }
        }
        Scrollbar {
            flickableItem: flickable
        }
   }

   View {
       id: mainview
       anchors {
           top: menu.top
           left:sidebar.right
           right:menu.right
           bottom:menu.bottom
           margins: Units.dp(30)
       }
       elevation: 1
        Column {
                anchors.fill: parent
                spacing: Units.dp(20)

                ListItem.Subtitled {
                    id: simpleWeather
                    text: "天气查询中..."
                    subText: "点击查看详情"
                    onClicked: root.selectedPage = pages[2]

                    action: Icon {
                        anchors.centerIn: parent
                        name: "awesome/sun_o"
                        size: Units.dp(32)
                    }
                }
            Label {
                id: helloLable
                font.weight: Font.Bold
                font.pixelSize: Units.dp(45)
                anchors.bottom: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.margins: Units.dp(50)
            }
            Button {
                text: "登入qq"
                elevation: 1
                backgroundColor: Theme.primaryColor
                anchors.top: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked:{
                    menu_gui.slot_qq_login(root.useruid)
                }
            }
            Button {
                text: "设置QQ号"
                elevation: 1
                backgroundColor: Theme.primaryColor
                anchors.top: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.margins: Units.dp(50)
                onClicked:{
                    qqsettingDialog.show()
                }
            }
            Button {
                id: collectBotton
                text: "添加网站收藏"
                elevation: 1
                backgroundColor: Theme.primaryColor
                anchors.top: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.margins: Units.dp(100)
                onClicked:{
                    addurlDialog.show()
                }
            }
            Label {
                text:"点击右键删除个人收藏"
                font.pixelSize: Units.dp(10)
                anchors.top: collectBotton.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.margins: Units.dp(10)
            }
            Button {
                text: "退出"
                elevation: 1
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: Units.dp(20)
                textColor: Palette.colors["grey"]["100"]
                backgroundColor: Palette.colors["red"]["300"]
                onClicked:{
                    root.loginflag = false
                    root.useruid = ""
                    login_gui.slot_logout_req()
                    root.selectedPage = pages[0]
                }
            }
        }
   }

   Dialog {
       id: qqsettingDialog
       title: "输入QQ号和密码"
       hasActions: true
       Text {
           text: "只需设置一次，想要修改时才需要再次输入"
       }
       TextField {
           id: qqnum
           placeholderText: "QQ号"
           floatingLabel: true
           anchors.horizontalCenter: parent.horizontalCenter
           anchors.margins: Units.dp(10)
           width: parent.width
       }
       TextField {
           id: qqpass
           placeholderText: "密码"
           floatingLabel: true
           anchors.horizontalCenter: parent.horizontalCenter
           anchors.margins: Units.dp(10)
           width: parent.width
           echoMode: TextInput.Password
       }
       onAccepted: {
           menu_gui.slot_change_qq(root.useruid,qqnum.text,qqpass.text)
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
           menu_gui.slot_comment_add(root.useruid, newwebname.text, newweburl.text)
           get_comment()
       }
   }

   Dialog {
       id: delwebDialog
       title: "编辑导航"
       hasActions: true
       text:"点击OK删除导航"
       onAccepted: {
           menu_gui.slot_comment_del(root.useruid,menu.userwebname[menu.selectweb], menu.userweburl[menu.selectweb])
           get_comment()
       }
   }

   function get_username() {
       var info;
       info = menu_gui.slot_info_req(root.useruid);
       helloLable.text = info[1] + "，您好！"
   }

   function show_weather(){
       var object =  Weather.weather_api.value;
       print(object);
       simpleWeather.text = object.showapi_res_body.cityInfo.c3 + " 实时天气:      " + object.showapi_res_body.now.weather + "      " + object.showapi_res_body.now.temperature + "°C";
   }

   function get_comment(){
       var comment;
       comment = menu_gui.slot_comment_req(root.useruid);
       print("comment :" + comment);
       var object = JSON.parse(comment.toString());
       for(var i=0;i<object.website.length;i++){
           menu.webname[i] = object.website[i].name;
           menu.weburl[i] = object.website[i].url;
       }
       menu.webnum = i;
       for(var i=0;i<object.userwebsite.length;i++){
           menu.userwebname[i] = object.userwebsite[i].name;
           menu.userweburl[i] = object.userwebsite[i].url;
       }
       menu.userwebnum = i;
   }
}

