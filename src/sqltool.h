#ifndef SQLTOOL_H
#define SQLTOOL_H

#include"header.h"

bool sql_open();

bool sql_config_init();
bool sql_rootpass_init();
bool sql_config_change(int code, QString newvalue);
QStringList sql_config_load(int code = CONFIG_ALL);
QString sql_config_comment_load();
bool sql_config_comment_add(QString name,QString url);
bool sql_config_comment_del(QString name,QString url);


bool sql_user_init();
int sql_user_count();
bool sql_user_add(QStringList newvalue);
bool sql_user_update(int userid, QStringList newvalue);
bool sql_user_del(int userid);
QStringList sql_user_load(QString usercode, int userid, QString info);
QStringList sql_user_qq_load(QString uid);
bool sql_user_qq_change(QString uid, QString qqnum, QString qqpass);
QString sql_user_comment_load(QString uid);
bool sql_user_comment_add(QString uid, QString name,QString url);
bool sql_user_comment_del(QString uid, QString name,QString url);
bool sql_user_comment_clear(QString uid);





#endif // SQLTOOL_H

