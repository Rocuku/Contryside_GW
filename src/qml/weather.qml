import QtQuick 2.2
import Material 0.1
import Material.ListItems 0.1 as ListItem
import Qt.labs.folderlistmodel 2.1
import Menu_Gui 1.0
import "qrc:/js/weather.js" as Weather


TabView {
    id: tabView
    anchors.fill: parent
    currentIndex: page.selectedTab
    model: page.tabs
    property var weatherinfo: [
            "白天天气：", "白天气温：", "白天风向：", "白天风力：",
            "晚上天气：", "晚上气温：", "晚上风向：", "晚上风力：",
    ]
    property var weather1: ["","","","","","","","",]
    property var weather2: ["","","","","","","","",]
    property var weather3: ["","","","","","","","",]
    property var weatherdetail: [weather1,weather2,weather3]

    property var indexinfo: ["大气污染：", "穿衣指数：", "感冒：", "旅游：", "紫外线：", "洗车："]
    property var index1: ["","","","","","","","","",]
    property var index2: ["","","","","","","","","",]
    property var index3: ["","","","","","","","","",]
    property var subindex1: ["","","","","","","","","",]
    property var subindex2: ["","","","","","","","","",]
    property var subindex3: ["","","","","","","","","",]
    property var indexdetail: [index1,index2,index3]
    property var subindexdetail: [subindex1,subindex2,subindex3]
    property  string  city

    Component.onCompleted: {
        root.config = login_gui.slot_load_config()
        Weather.weather_api.input.city = root.config[2]
        Weather.weather_api.get_weather(show_weather)
        show_tabs()
    }
    delegate: Item {
        width: tabView.width
        height: tabView.height
        clip: true
        Flickable {
            id: flickable
            clip: true
            anchors.fill: parent
            anchors.margins: Units.dp(5)
            contentHeight: indexView.height
            View {
                id:weatherView
                width: flickable.width/3
                anchors.left: parent.left
                height: indexColumn.height
                elevation: 1
                Column {
                    id:weatherColumn
                    width: parent.width
                    ListItem.Subheader {
                        text: city + "-天气信息"
                    }
                    Repeater {
                        model: weatherinfo
                        delegate: ListItem.Standard {
                            text: weatherinfo[index] + weatherdetail[page.selectedTab][index]
                        }
                     }
                }
            }
            View {
                id: indexView
                anchors.left: weatherView.right
                anchors.right: parent.right
                anchors.margins: Units.dp(5)
                height: indexColumn.height
                elevation: 1
                Column {
                    id:indexColumn
                    width: parent.width
                    ListItem.Subheader {
                        text: "指数信息"
                    }
                    Repeater {
                        model: indexinfo
                        delegate: ListItem.Subtitled {
                            text: indexinfo[index] + indexdetail[page.selectedTab][index]
                            subText:  subindexdetail[page.selectedTab][index]
                        }
                     }
                }
            }
        }
        Scrollbar {
            flickableItem: flickable
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
            page.tabs = []
            root.selectedPage = pages[1]
        }
    }
    function show_tabs(){
        var date=new Date();
        var y = date.getFullYear();
        var m = date.getMonth()+1 < 10 ? '0'+(date.getMonth()+1) : date.getMonth()+1
        var d = date.getDate() < 10 ? '0'+date.getDate() : date.getDate();
        var date1 = y + "-" + m + "-" + d;
        d = (date.getDate() + 1) < 10 ? '0'+ (date.getDate() + 1) :  (date.getDate() + 1);
        var date2 = y + "-" + m + "-" + d;
         d = (date.getDate() + 2) < 10 ? '0'+ (date.getDate() + 2) :  (date.getDate() + 2);
        var date3 = y + "-" + m + "-" + d;
        page.tabs = [ "今天" + date1,"明天" + date2,"后天" + date3];
    }

    function show_weather() {
        var object =  Weather.weather_api.value;
        var i,j;
        var properties1 = ["day_weather","day_air_temperature","day_wind_direction","day_wind_power",
                "night_weather","night_air_temperature","night_wind_direction","night_wind_power",
        ];
        var properties2 = ["aqi","clothes","cold","travel","uv","wash_car"];
        for(i = 0; i < properties1.length; i++){
            weather1[i] = object.showapi_res_body.f1[properties1[i]];
            weather2[i] = object.showapi_res_body.f2[properties1[i]];
            weather3[i] = object.showapi_res_body.f3[properties1[i]];
        }
        for(i = 0; i < properties2.length; i++){
            index1[i] = object.showapi_res_body.f1.index[properties2[i]].title;
            index2[i] = object.showapi_res_body.f2.index[properties2[i]].title;
            index3[i] = object.showapi_res_body.f3.index[properties2[i]].title;
            subindex1[i] = object.showapi_res_body.f1.index[properties2[i]].desc;
            subindex2[i] = object.showapi_res_body.f2.index[properties2[i]].desc;
            subindex3[i] = object.showapi_res_body.f3.index[properties2[i]].desc;
        }
        city = object.showapi_res_body.cityInfo.c3
    }
}
