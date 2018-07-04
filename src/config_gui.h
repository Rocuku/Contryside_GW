#ifndef CONFIG_GUI_H
#define CONFIG_GUI_H

#include"header.h"
#include"sqltool.h"

class Config_Gui : public QObject{
    Q_OBJECT
    public:
        Config_Gui();
    public slots:
        void slot_init();
        void slot_change_pass(QString newpass);
        void slot_change_serialport(QString newvalue);
        void slot_change_ipaddr(QString newvalue);
        void slot_change_position(QString newvalue);
        void slot_change_interface(QString newvalue);
        void slot_change_qqpos(QString newvalue);
        QString slot_comment_req();
        void slot_comment_add(QString name, QString url);
        void slot_comment_del(QString name, QString url);


        void slot_user_init();
        int slot_user_num();
        QStringList slot_user_data(int usernum);
        bool slot_user_add(QStringList userinfo);
        void slot_user_delete(int usernum);
        void slot_user_edit(int usernum, QStringList userinfo);
    signals:
        void sig_info_result(int result);
};



#endif // CONFIG_GUI_H

