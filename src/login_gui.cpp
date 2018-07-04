#include "login_gui.h"

Login_Gui::Login_Gui(){
    serial_init();
    ipaddr = "192.168.6.1";
}

void Login_Gui::serial_init(){
    serial = new QSerialPort("COM1");
    serial->open(QIODevice::ReadWrite);
    serial->setBaudRate(QSerialPort::Baud9600);
    serial->setDataBits(QSerialPort::Data8);
    serial->setParity(QSerialPort::NoParity);
    serial->setStopBits(QSerialPort::OneStop);
    serial->setFlowControl(QSerialPort::NoFlowControl);

    connect(serial,SIGNAL(readyRead()),this,SLOT(serialRead()));
}

void Login_Gui::slot_serial_init(QString serialport){
    if(serial) serial->close();
    serial = new QSerialPort(serialport);
    serial->open(QIODevice::ReadWrite);
    serial->setBaudRate(QSerialPort::Baud9600);
    serial->setDataBits(QSerialPort::Data8);
    serial->setParity(QSerialPort::NoParity);
    serial->setStopBits(QSerialPort::OneStop);
    serial->setFlowControl(QSerialPort::NoFlowControl);

    connect(serial,SIGNAL(readyRead()),this,SLOT(serialRead()));
    qDebug() << "serial open";
}

QString Login_Gui::base64_encode(QString string){
    QByteArray ba;
    ba.append(string);
    return ba.toBase64();
}

void Login_Gui::slot_login_req(){
    manager = new QNetworkAccessManager(this);
    QNetworkRequest request;
    QByteArray post_data;
    QString type = "0";
    QString behavior = "0";
    QString mac = "000000000000";
    QString tempuid;
    QList<QNetworkInterface> list = QNetworkInterface::allInterfaces();
    mac = list.at(interfacenum.toInt()).hardwareAddress();
    mac.replace(":", "");
    qDebug() << mac;
    type  = base64_encode(type);
    behavior  = base64_encode(behavior);
    tempuid  = base64_encode(uid);
    mac = base64_encode(mac);
    post_data.append("type=" + type + "&behavior=" + behavior + "&mac=" + mac + "&uid=" + tempuid);
    request.setUrl(QUrl("http://" + ipaddr + "/cgi-bin/luci/authuid"));

    connect(manager, SIGNAL(finished(QNetworkReply*)),
    this,SLOT(replyFinished(QNetworkReply*)));
    manager->post(request, post_data);
}


void Login_Gui::slot_logout_req(){
    manager = new QNetworkAccessManager(this);
    QNetworkRequest request;
    QByteArray post_data;
    QString type = "0";
    QString behavior = "1";
    QString mac = "000000000000";
    QString tempuid;
    QList<QNetworkInterface> list = QNetworkInterface::allInterfaces();
    mac = list.at(interfacenum.toInt()).hardwareAddress();
    mac.replace(":", "");
    qDebug() << mac;
    type  = base64_encode(type);
    behavior  = base64_encode(behavior);
    tempuid  = base64_encode(uid);
    mac = base64_encode(mac);
    post_data.append("type=" + type + "&behavior=" + behavior + "&mac=" + mac + "&uid=" + tempuid);
    request.setUrl(QUrl("http://" + ipaddr + "/cgi-bin/luci/authuid"));

    connect(manager, SIGNAL(finished(QNetworkReply*)),
    this,SLOT(replyFinished(QNetworkReply*)));
    manager->post(request, post_data);
}

bool Login_Gui::slot_rootpass_check(QString pass){
    QStringList value;
    value = sql_config_load(CONFIG_ROOT_PASS);
    if(value[0] == pass) return 1;
    else return 0;
}

void Login_Gui::slot_rootpass_reset(){
    sql_rootpass_init();
}


QStringList Login_Gui::slot_load_config(){
    QStringList value;
    value = sql_config_load(CONFIG_ALL);
    slot_serial_init(value[0]);
    ipaddr = value[1];
    interfacenum = value[3];
    return value;
}

void Login_Gui::serialRead(){
    static QByteArray allData;
    QByteArray dataTemp;
    dataTemp = serial->readAll();
    allData += dataTemp;
    qDebug() << allData;
    qDebug() << allData.length();
    if (allData.length() == 14){
        QByteArray part = allData.mid(1,10);
        unsigned long temp,id = 0;
        temp = part.toULong();
        id = (temp >> 24) & 0x000000ff;
        id |= (temp >> 8) & 0x0000ff00;
        id |= (temp << 8) & 0x00ff0000;
        id |= (temp << 24) & 0xff000000;
        uid = QString::number( id, 16);
        qDebug() << "uid:" << uid;
        allData.clear();
        slot_login_req();
    }
    else if(allData.length() > 14){
         allData.clear();
    }
}


void Login_Gui::replyFinished(QNetworkReply *reply){
    QTextCodec *codec = QTextCodec::codecForName("utf8");
    QString ack = codec->toUnicode(reply->readAll());
    if (ack == "id=0")
        emit sig_login_result("0#" + uid);
    else if(ack == "id=1")
        emit sig_login_result("-1#" + uid);
    qDebug() << ack;
    reply->deleteLater();
}




