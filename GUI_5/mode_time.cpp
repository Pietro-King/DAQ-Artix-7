#include "mode_time.h"
#include "ui_mode_time.h"
#include "LCDNumber_reverse.h"

mode_time::mode_time(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::mode_time)
{
    ui->setupUi(this);

    ui->number->setDigitCount(10);
    ui->number->setFixedSize(260, 100);
    ui->number->display(ui->number->timeValue->toString("HH:mm:ss"));

    ui->spinBox->setRange(0,23);
    ui->spinBox->setSuffix(" h");
    ui->spinBox_2->setRange(0,59);
    ui->spinBox_2->setSuffix(" min");
    ui->spinBox_3->setRange(0,59);
    ui->spinBox_3->setSuffix(" sec");


    QObject::connect(ui->Start,SIGNAL(clicked()),ui->number,SLOT(go()));
    //QObject::connect(ui->Start,SIGNAL(clicked()),ui->Start,SLOT(set_time_mode()));
    QObject::connect(ui->Start,SIGNAL(clicked()),ui->Start,SLOT(acquisition_t()));
    QObject::connect(ui->pushButton_2,SIGNAL(clicked()),ui->Start,SLOT(convert()));
}

mode_time::~mode_time()
{
    delete ui;
}

void mode_time::on_pushButton_clicked()
{
    int h,m,s;
    h=ui->spinBox->value();
    m=ui->spinBox_2->value();
    s=ui->spinBox_3->value();
    ui->Start->time_convertion_value=(s+(m*60)+(h*3600))*1000;
    ui->Start->set_time_mode();

    ui->number->timeValue->setHMS(h,m,s);
    ui->number->display(ui->number->timeValue->toString("HH:mm:ss"));

}
