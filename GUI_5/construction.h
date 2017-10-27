#ifndef CONSTRUCTION_H
#define CONSTRUCTION_H

#include <QWidget>

namespace Ui {
class construction;
}

class construction : public QWidget
{
    Q_OBJECT

public:
    explicit construction(QWidget *parent = 0);
    ~construction();

private:
    Ui::construction *ui;
};

#endif // CONSTRUCTION_H
