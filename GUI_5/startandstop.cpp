#include "startandstop.h"
#include "ui_startandstop.h"
#include <windows.h>
#include "LCDNumber.h"
#include <QMainWindow>
#include <QLabel>
#include <my_pushbutton.h>

startandstop::startandstop(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::startandstop)
{
    ui->setupUi(this);

     LCDNumber *number = new LCDNumber(ui->graphicsView,0,0,0);
     Mypushbutton *button = new Mypushbutton(ui->graphicsView_2);

     number->setDigitCount(9);
     number->setFixedSize(185, 100);
     number->display(number->timeValue->toString("HH:mm:ss"));
     button->setText("Start");

     QObject::connect(button,SIGNAL(clicked()),number,SLOT(start_stop_lcdnumber()));
     QObject::connect(button,SIGNAL(clicked()),button,SLOT(set_startandstop_mode()));
     QObject::connect(button,SIGNAL(clicked()),button,SLOT(start_stop()));
     QObject::connect(ui->pushButton,SIGNAL(clicked()),button,SLOT(convert()));



}

startandstop::~startandstop()
{
    delete ui;
}

