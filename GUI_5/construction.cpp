#include "construction.h"
#include "ui_construction.h"

construction::construction(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::construction)
{
    ui->setupUi(this);
}

construction::~construction()
{
    delete ui;
}
