#include "header.h"
#include "login_gui.h"
#include "menu_gui.h"
#include "config_gui.h"
#include "sqltool.h"


int main(int argc, char *argv[]){
    QGuiApplication app(argc, argv);
    sql_open();
 //   sql_config_init();
 //   sql_user_init();

    qmlRegisterType<Login_Gui>("Login_Gui", 1, 0, "Login_Gui");
    qmlRegisterType<Menu_Gui>("Menu_Gui", 1, 0, "Menu_Gui");
    qmlRegisterType<Config_Gui>("Config_Gui", 1, 0, "Config_Gui");

    QQmlApplicationEngine engine;
    engine.load(QUrl("qrc:/qml/main.qml"));

/*
    int fontId = QFontDatabase::addApplicationFont(":/fonts/klxy.ttf");
    QString klxy = QFontDatabase::applicationFontFamilies ( fontId ).at(0);
    QFont font(klxy,10);
    app.setFont(font);
*/
    return app.exec();
}
