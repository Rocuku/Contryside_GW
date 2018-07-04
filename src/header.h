
#ifndef HEADER_H
#define HEADER_H


#define UPPER 1000

#define SQL_PASS "Trucc"
#define INIT_ROOT_PASS "kb109"

#define CONFIG_ALL 0
#define CONFIG_ROOT_PASS 1
#define CONFIG_SERIAL_PORT 2
#define CONFIG_IP_ADDR 3
#define CONFIG_POSITION 4
#define CONFIG_INTERFACE 5
#define CONFIG_QQPOS 6

#define USER_ALL_INFO "*"
#define USER_UID "uid"
#define USER_NAME "name"
#define USER_PHONE "phone"
#define USER_ADDR "addr"
#define USER_QQNUM "qqnum"
#define USER_QQPASS "qqpass"

#include <windows.h>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QObject>
#include <QtQml>
#include <QtNetwork>
#include <QtDebug>
#include <QByteArray>
#include <QFontDatabase>
#include <QtSerialPort/QSerialPort>
#include <QtSerialPort/QSerialPortInfo>
#include <QtSql>
#include <QProcess>


#endif // HEADER_H

