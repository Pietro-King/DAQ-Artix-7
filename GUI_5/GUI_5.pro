#-------------------------------------------------
#
# Project created by QtCreator 2017-10-25T16:01:19
#
#-------------------------------------------------

QT       += core gui
CONFIG += console
CONFIG -= app_bundle
CONFIG += c++11
greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = GUI_4
TEMPLATE = app

# The following define makes your compiler emit warnings if you use
# any feature of Qt which has been marked as deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

win32:CONFIG(release, debug|release): LIBS += -L$$PWD/ -lftd2xx
else:win32:CONFIG(debug, debug|release): LIBS += -L$$PWD/ -lftd2xx
else:unix: LIBS += -L$$PWD/ -lftd2xx
DISTFILES += \
    ftd2xx.lib \
    ftd2xx.dll

SOURCES += \
        main.cpp \
        mainwindow.cpp \
    samples.cpp \
    startandstop.cpp \
    mode_time.cpp \
    construction.cpp

HEADERS += \
        mainwindow.h \
    samples.h \
    startandstop.h \
    mode_time.h \
    construction.h \
    lcdnumber.h \
    lcdnumber_reverse.h \
    my_pushbutton.h
        ftd2xx.h

FORMS += \
        mainwindow.ui \
    samples.ui \
    startandstop.ui \
    mode_time.ui \
    construction.ui
