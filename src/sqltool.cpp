#include"sqltool.h"

bool sql_open(){
    QSqlDatabase dbconn = QSqlDatabase::addDatabase("SQLITECIPHER");
    dbconn.setDatabaseName("contryside.db");
    dbconn.setPassword(SQL_PASS);
    if (!dbconn.open()) {
        qDebug() << "SQL open failde!";
        return 0;
    }
    return 1;
}

//********************************************CONFIG START*******************************************************//


bool sql_config_init(){
    QSqlQuery query;
    QString command,json;
    query.exec("drop table config");
    query.exec("create table config (id int, pass varchar, serialport varchar, ipaddr varchar, position varchar, interface varchar, qqpos varchar, comment varchar)");
    command = QString("insert into config values (1, '%1', 'COM1', '192.168.6.1', '北京', 0, '\"C:\\Program Files (x86)\\Tencent\\QQ\\Bin\\QQScLauncher.exe\"','')").arg(INIT_ROOT_PASS);
    query.exec(command);
    json = QString("{\"name\": \"%1\",\"url\":\"%2\"}").arg("百度").arg("http://baidu.com");
    json = json + "," + QString("{\"name\": \"%1\",\"url\":\"%2\"}").arg("三农").arg("http://sannong.cntv.cn");
    command = QString("update config set comment = '%1' WHERE ID = 1").arg(json);
    query.exec(command);
    return 1;
}

bool sql_rootpass_init(){
    QSqlQuery query;
    QString command;
    command = QString("update config set pass = '%1' WHERE ID = 1").arg(INIT_ROOT_PASS);
    query.exec(command);
    return 1;
}

bool sql_config_change(int code, QString newvalue){
    QSqlQuery query;
    switch (code){
        case CONFIG_ROOT_PASS:
            query.exec("update config set pass = '" + newvalue + "' WHERE ID = 1;");
            break;
        case CONFIG_SERIAL_PORT:
            query.exec("update config set serialport = '" + newvalue + "' WHERE ID = 1;");
            break;
        case CONFIG_IP_ADDR:
            query.exec("update config set ipaddr = '" + newvalue + "' WHERE ID = 1;");
            break;
        case CONFIG_POSITION:
            query.exec("update config set position = '" + newvalue + "' WHERE ID = 1;");
            break;
        case CONFIG_INTERFACE:
            query.exec("update config set interface = '" + newvalue + "' WHERE ID = 1;");
            break;
        case CONFIG_QQPOS:
            query.exec("update config set qqpos = '" + newvalue + "' WHERE ID = 1;");
            break;
    }
    return 1;
}

QStringList sql_config_load(int code){
    QSqlQuery query;
    QStringList value;
    value << "-1";
    switch (code){
        case CONFIG_ALL:
            query.exec("select serialport,ipaddr,position,interface,qqpos from config");
            if (query.next()){
                value[0] = query.value(0).toString();
                value << query.value(1).toString() << query.value(2).toString() << query.value(3).toString() << query.value(4).toString();
            }
            break;
        case CONFIG_ROOT_PASS:
            query.exec("select pass from config");
            if (query.next()) value[0] = query.value(0).toString();
            break;
        case CONFIG_SERIAL_PORT:
            query.exec("select serialport from config");
            if (query.next()) value[0] = query.value(0).toString();
            break;
        case CONFIG_IP_ADDR:
            query.exec("select ipaddr from config");
            if (query.next()) value[0] = query.value(0).toString();
            break;
        case CONFIG_POSITION:
            query.exec("select position from config");
            if (query.next()) value[0] = query.value(0).toString();
            break;
        case CONFIG_INTERFACE:
            query.exec("select interface from config");
            if (query.next()) value[0] = query.value(0).toString();
            break;
        case CONFIG_QQPOS:
            query.exec("select qqpos from config");
            if (query.next()) value[0] = query.value(0).toString();
            break;
    }
    qDebug() << value;
    return value;
}

QString sql_config_comment_load(){
    QSqlQuery query;
    QString value;
    query.exec("select comment from config");
    if (query.next()){
        value = query.value(0).toString();
    }
    value = QString("\"website\":[") + value + QString("]");
    return value;
}

bool sql_config_comment_add(QString name,QString url){
    QSqlQuery query;
    QString value,command;
    query.exec("select comment from config");
    if (query.next()){
        value = query.value(0).toString();
    }
    if(value == "")
        value +=  QString("{\"name\": \"%1\",\"url\":\"%2\"}").arg(name).arg(url);
    else
        value +=  "," + QString("{\"name\": \"%1\",\"url\":\"%2\"}").arg(name).arg(url);
    command = QString("update config set comment = '" + value + "' WHERE ID = 1;");
    query.exec(command);
    return 1;
}

bool sql_config_comment_del(QString name,QString url){
    QSqlQuery query;
    QString value,command;
    query.exec("select comment from config");
    if (query.next()){
        value = query.value(0).toString();
    }
    value = value.replace(QString("{\"name\": \"%1\",\"url\":\"%2\"},").arg(name).arg(url), QString(""));
    value = value.replace(QString(",{\"name\": \"%1\",\"url\":\"%2\"}").arg(name).arg(url), QString(""));
    command = QString("update config set comment = '" + value + "' WHERE ID = 1;");
    query.exec(command);
    return 1;
}


//********************************************USER START*******************************************************//

bool sql_user_init(){
    QSqlQuery query;
    qDebug() << "drop:" << query.exec("drop table user");
    qDebug() << "create:" << query.exec("create table user (id int, uid varchar, name varchar, phone varchar, addr varchar, qqnum varchar, qqpass varchar, comment varchar)");
    qDebug() << "insert:" << query.exec("insert into user values (1,  '4b33c6d4', 'test01',  '114', '', '', '', '')");
//   qDebug()<< query.lastError();

    query.exec("select id,name from user");
    while (query.next()) {
        qDebug() << query.value(0).toInt() << query.value(1).toString();
    }
    qDebug() << "end";
    return 1;
}

int sql_user_count(){
    QSqlQuery query;
    int value = -1;
    query.exec("select count(*) from user");
    if(query.next())
       value = query.value(0).toInt();

    query.exec("select id,name from user");
    while (query.next()) {
        qDebug() << query.value(0).toInt() << query.value(1).toString();
    }
    return value;
}

bool sql_user_add(QStringList newvalue){
    QSqlQuery query;
    int id = sql_user_count() + 1;
    QString command;
    command = QString("select * from user where uid = '%2'").arg(newvalue[0]);
    query.exec(command);
    if (query.next())
        return false;
    command = QString("insert into user values (%1, '%2', '%3', '%4', '%5', '', '', '')").arg(id).arg(newvalue[0]).arg(newvalue[1]).arg(newvalue[2]).arg(newvalue[3]);
    qDebug() <<  "add:" << query.exec(command);
//    qDebug()<< query.lastError();
    return 1;
}

bool sql_user_update(int userid,  QStringList newvalue){
    QSqlQuery query;
    QString command;
    command = QString("update user set uid = '%1' WHERE ID = %2;").arg(newvalue[0]).arg(userid);
    query.exec(command);
    command = QString("update user set name = '%1' WHERE ID = %2;").arg(newvalue[1]).arg(userid);
    query.exec(command);
    command = QString("update user set phone = '%1' WHERE ID = %2;").arg(newvalue[2]).arg(userid);
    query.exec(command);
    command = QString("update user set addr = '%1' WHERE ID = %2;").arg(newvalue[3]).arg(userid);
    query.exec(command);
    return 1;

}

QStringList sql_user_load(QString usercode, int userid, QString info){
    QSqlQuery query;
    QStringList value;
    QString command;
    if (usercode == "id"){
        command = QString("select * from user where id = %1").arg(userid);
    }
    else
        command = QString("select * from user where %1 = '%2'").arg(usercode).arg(info);
    qDebug() << command;
    query.exec(command);
    if (query.next())
        value  << query.value(1).toString() << query.value(2).toString() << query.value(3).toString() << query.value(4).toString() ;
    qDebug() << value;
    return value;
}

bool sql_user_del(int userid){
    QSqlQuery query;
    int usernum = sql_user_count();
    QString command = QString("delete from user where id = %1").arg(userid);
    query.exec(command);
    for(int i = userid + 1;i <= usernum; i++){
        command = QString("update user set id = %1 where id = %2;").arg(i - 1).arg(i);
        query.exec(command);
    }
    return 1;
}

QStringList sql_user_qq_load(QString uid){
    QSqlQuery query;
    QStringList value;
    QString command;
    command = QString("select qqnum,qqpass from user where %1 = '%2'").arg(USER_UID).arg(uid);
    query.exec(command);
    if (query.next())
        value  << query.value(0).toString() << query.value(1).toString() ;
    qDebug() << value;
    return value;
}


bool sql_user_qq_change(QString uid, QString qqnum, QString qqpass){
    QSqlQuery query;
    QString command;
    command = QString("update user set qqnum = '%1' WHERE uid = '%2';").arg(qqnum).arg(uid);
    qDebug() << "update qqnum:" << query.exec(command);
    command = QString("update user set qqpass = '%1' WHERE uid = '%2';").arg(qqpass).arg(uid);
    qDebug() << "update qqpass:" << query.exec(command);
    return 1;
}


QString sql_user_comment_load(QString uid){
    QSqlQuery query;
    QString value;
    QString command = QString("select comment from user where uid = '%1';").arg(uid);
    query.exec(command);
    if (query.next()){
        value = query.value(0).toString();
    }
    value = QString("\"userwebsite\":[") + value + QString("]");
    qDebug() << "user comment:" << value;
    return value;
}

bool sql_user_comment_add(QString uid, QString name,QString url){
    QSqlQuery query;
    QString value,command;
    command = QString("select comment from user where uid = '%1';").arg(uid);
    query.exec(command);
    qDebug() << "find user comment:" << query.exec(command);
    if (query.next()){
        value = query.value(0).toString();
        qDebug() << "value:" << value;
    }
    if(value == "")
        value +=  QString("{\"name\": \"%1\",\"url\":\"%2\"}").arg(name).arg(url);
    else
        value +=  "," + QString("{\"name\": \"%1\",\"url\":\"%2\"}").arg(name).arg(url);
    command = QString("update user set comment = '%1' where uid = '%2';").arg(value).arg(uid);
    qDebug() << "add user comment:" << query.exec(command);
    return 1;
}

bool sql_user_comment_del(QString uid, QString name,QString url){
    QSqlQuery query;
    QString value,command;
    command = QString("select comment from user where uid = '%1';").arg(uid);
    qDebug() << "find user comment" << query.exec(command);
    if (query.next()){
        value = query.value(0).toString();
    }
    value = value.replace(QString("{\"name\": \"%1\",\"url\":\"%2\"},").arg(name).arg(url), QString(""));
    value = value.replace(QString(",{\"name\": \"%1\",\"url\":\"%2\"}").arg(name).arg(url), QString(""));
    command = QString("update user set comment = '%1' where uid = '%2';").arg(value).arg(uid);
    query.exec(command);
    return 1;
}

bool sql_user_comment_clear(QString uid){
    QSqlQuery query;
    QString command;
    command = QString("update user set comment = '' where uid = '%1';").arg(uid);
    query.exec(command);
    return 1;
}
