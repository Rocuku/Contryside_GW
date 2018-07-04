TEMPLATE = app
QT += qml quick core network serialport sql gui
CONFIG += qt plugin
TARGET = contryside

SOURCES += main.cpp \
    *.cpp
RESOURCES += assets.qrc
HEADERS  += *.h

OTHER_FILES += qml/*.qml \
    js/*.js\

DISTFILES += \
    qml/webconfig.qml

RC_ICONS = pro.ico


