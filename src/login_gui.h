#ifndef LOGIN_GUI_H
#define LOGIN_GUI_H

#include"header.h"
#include"sqltool.h"

class Login_Gui : public QObject{
    Q_OBJECT
    public:
        Login_Gui();
    private:
        QNetworkAccessManager *manager;
        QSerialPort *serial;
        QString uid;
        QString base64_encode(QString string);
        QString ipaddr;
        QString interfacenum;
        void serial_init();
    public slots:
        void slot_serial_init(QString serialport);
        void slot_login_req();
        void slot_logout_req();
        bool slot_rootpass_check(QString pass);
        void slot_rootpass_reset();
        QStringList slot_load_config();
    private slots:
        void replyFinished(QNetworkReply *);
        void serialRead();
    signals:
        void sig_login_req();
        void sig_login_result(QString result);
};

#endif // LOGIN_GUI_H
