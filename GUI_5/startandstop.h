#ifndef STARTANDSTOP_H
#define STARTANDSTOP_H

#include <QWidget>

namespace Ui {
class startandstop;
}

class startandstop : public QWidget
{
    Q_OBJECT

public:
    explicit startandstop(QWidget *parent = 0);
    ~startandstop();

private slots:

private:
    Ui::startandstop *ui;
};

#endif // STARTANDSTOP_H
