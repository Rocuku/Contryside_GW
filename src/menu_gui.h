#ifndef MENU_GUI_H
#define MENU_GUI_H

#include"header.h"
#include"sqltool.h"


class Menu_Gui : public QObject{
    Q_OBJECT
    public:
        Menu_Gui();
    private:
        QString uid;
    public slots:
        QStringList slot_info_req(QString uid);
        void slot_sys_req(QString command, QString  arguments);
        void slot_qq_login(QString uid);
        void slot_change_qq(QString uid, QString qqnum, QString qqpass);
        QString slot_comment_req(QString uid);
        void slot_comment_add(QString uid, QString name, QString url);
        void slot_comment_del(QString uid, QString name, QString url);
    signals:
        void sig_info_result(int result);
};



#endif // MENU_GUI_H

