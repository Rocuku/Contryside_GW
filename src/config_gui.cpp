#include "config_gui.h"

Config_Gui::Config_Gui(){
}

void Config_Gui::slot_change_pass(QString newpass){
    sql_config_change(CONFIG_ROOT_PASS, newpass);
}

void Config_Gui::slot_change_serialport(QString newvalue){
    sql_config_change(CONFIG_SERIAL_PORT, newvalue);
}

void Config_Gui::slot_change_ipaddr(QString newvalue){
    sql_config_change(CONFIG_IP_ADDR, newvalue);
}

void Config_Gui::slot_change_position(QString newvalue){
    sql_config_change(CONFIG_POSITION, newvalue);
}

void Config_Gui::slot_change_interface(QString newvalue){
    sql_config_change(CONFIG_INTERFACE, newvalue);
}

void Config_Gui::slot_change_qqpos(QString newvalue){
    sql_config_change(CONFIG_QQPOS, newvalue);
}


void Config_Gui::slot_init(){
    sql_config_init();
}

void Config_Gui::slot_user_init(){
    sql_user_init();
}

int Config_Gui::slot_user_num(){
    return sql_user_count();
}

QStringList Config_Gui::slot_user_data(int usernum){
    QStringList value;
    value = sql_user_load("id", usernum + 1, "");
    qDebug() << "value:" << value << usernum;
    return value;
}

void Config_Gui::slot_user_edit(int usernum, QStringList userinfo){
    sql_user_update(usernum + 1, userinfo);
}


bool Config_Gui::slot_user_add(QStringList userinfo){
    return sql_user_add(userinfo);
}

void Config_Gui::slot_user_delete(int usernum){
    qDebug() << "begin delete";
    sql_user_del(usernum + 1);
    qDebug() << "delete";
}


QString Config_Gui::slot_comment_req(){
    QString value;
    value = "{" + sql_config_comment_load() + "}";
    return value;
}

void Config_Gui::slot_comment_add(QString name, QString url){
    sql_config_comment_add(name,url);
}

void Config_Gui::slot_comment_del(QString name, QString url){
    sql_config_comment_del(name,url);
}
