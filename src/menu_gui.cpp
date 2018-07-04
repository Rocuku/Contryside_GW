#include"menu_gui.h"
#include "keyinput.h"


Menu_Gui::Menu_Gui(){
}

QStringList Menu_Gui::slot_info_req(QString uid){
    qDebug() << "slot_uid:" << uid;
    return sql_user_load(USER_UID, 0 , uid);
}

void Menu_Gui::slot_sys_req(QString command, QString  arguments){
    QProcess pro;
    QString t1 = command;
    QStringList t2;
    t2.append(arguments);
    qDebug() << pro.execute(t1,t2);
}

void Menu_Gui::slot_qq_login(QString uid){
    QProcess pro;
    HWND w;
    QStringList p = sql_config_load(CONFIG_QQPOS);
    QString pos;
    pos = p[0];
    qDebug() << pro.execute(pos);
    Sleep(1000);
    w = FindWindow(NULL, L"QQ");
    if (w == NULL){
        qDebug() <<"QQ is not running.";
    }
    else{
        ShowWindow(w,SW_SHOWDEFAULT);
        SetForegroundWindow(w);
        BringWindowToTop(w);
        SetFocus(w);
        SetCursorPos(0,0);
        for(int i = 0; i < 6; i++)
            key_action(VK_TAB);
        QStringList qqinfo = sql_user_qq_load(uid);
        qDebug() <<  "qq:" << qqinfo;
        QString str = qqinfo[0];
        key_input(create_key(str));
        key_action(VK_TAB);
        str = qqinfo[1];
        key_input(create_key(str));
        key_action(VK_RETURN);

    }
}


void Menu_Gui::slot_change_qq(QString uid, QString qqnum, QString qqpass){
    sql_user_qq_change(uid, qqnum, qqpass);
}

QString Menu_Gui::slot_comment_req(QString uid){
    QString value;
    value = "{" + sql_config_comment_load() + ",";
    value += sql_user_comment_load(uid) + "}";
    return value;
}

void Menu_Gui::slot_comment_add(QString uid, QString name, QString url){
     sql_user_comment_add(uid, name, url);
}

void Menu_Gui::slot_comment_del(QString uid, QString name, QString url){
     sql_user_comment_del(uid, name, url);
}

