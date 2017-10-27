#ifndef MODE_TIME_H
#define MODE_TIME_H

#include <QWidget>

namespace Ui {
class mode_time;
}

class mode_time : public QWidget
{
    Q_OBJECT

public:
    explicit mode_time(QWidget *parent = 0);
    ~mode_time();

private slots:
    void on_pushButton_clicked();

private:
    Ui::mode_time *ui;
};

#endif // MODE_TIME_H
