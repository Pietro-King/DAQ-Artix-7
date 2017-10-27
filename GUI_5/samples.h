#ifndef SAMPLES_H
#define SAMPLES_H

#include <QWidget>

namespace Ui {
class samples;
}

class samples : public QWidget
{
    Q_OBJECT

public:
    explicit samples(QWidget *parent = 0);
    ~samples();

private slots:


    void on_pushButton_3_clicked();

private:
    Ui::samples *ui;
};

#endif // SAMPLES_H
