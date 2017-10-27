#include "samples.h"
#include "ui_samples.h"
#include <QLineEdit>

samples::samples(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::samples)
{
        ui->setupUi(this);
        ui->lineEdit->setInputMask("9999999999");//10 billion max
        ui->lineEdit->setPlaceholderText("0-9999999999");
        ui->lineEdit->setCursorPosition(0);
        //QObject::connect(ui->pushButton,SIGNAL(clicked()),ui->pushButton,SLOT(set_sample_mode()));
        QObject::connect(ui->pushButton,SIGNAL(clicked()),ui->pushButton,SLOT(acquisition()));
        QObject::connect(ui->pushButton_2,SIGNAL(clicked()),ui->pushButton,SLOT(convert()));

}

samples::~samples()
{
    delete ui;
}


void samples::on_pushButton_3_clicked()
{
   // std::string linetext=ui->lineEdit->text();
    ui->pushButton->input_samples_num=ui->lineEdit->text().toLongLong();
    ui->pushButton->set_sample_mode();
}
