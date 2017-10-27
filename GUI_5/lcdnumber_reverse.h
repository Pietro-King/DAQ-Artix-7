#ifndef LCDNUMBER_REVERSE_H
#define LCDNUMBER_REVERSE_H

#include <QLCDNumber>
#include <QTimer>
#include <QTime>
class LCDNumber_reverse: public QLCDNumber
{
  Q_OBJECT

  public:
  QTimer* timer;
  QTime*  timeValue;

  int tick=0;

  public:
    LCDNumber_reverse(QWidget * parentWidget,int hours, int minutes,int seconds)
    {
        timer = new QTimer();
        timeValue = new QTime(hours,minutes,seconds);

        this->setParent(parentWidget);
        this->display(timeValue->toString("HH:mm:ss"));
        QObject::connect(timer,SIGNAL(timeout()),this,SLOT(setDisplay()));
    }

    ~LCDNumber_reverse(){}

   public slots:
    void setDisplay()
    {
      this->timeValue->setHMS(this->timeValue->addSecs(-1).hour(),this->timeValue->addSecs(-1).minute(),this->timeValue->addSecs(-1).second());
      this->display(this->timeValue->toString("HH:mm:ss"));
      this->tick++;
      if((this->timeValue->second()==0) and (this->timeValue->minute()==0) and (this->timeValue->hour())==0)
        this->timer->stop();
    }
    void go()
    {

        this->timer->start(1000);

    }
};

#endif // LCDNUMBER_REVERSE_H
