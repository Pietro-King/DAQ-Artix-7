#ifndef MY_PUSHBUTTON_H
#define MY_PUSHBUTTON_H

#include <qpushbutton.h>
#include <QTime>
#include <QApplication>
#include <QHBoxLayout>
#include <QSlider>
#include <QSpinBox>
#include <QTabWidget>
#include <QLabel>
#include <QCoreApplication>
#include <QDebug>
#include <QElapsedTimer>
#include <windows.h> // for Sleep
#include "ftd2xx.h"
#include <string>
#include <fstream>
#include <iostream>
#include <thread>
#include <chrono>
#include <samples.h>
#include <startandstop.h>
#include <mode_time.h>
#include <construction.h>
#include <QFuture>
#include <QtConcurrent/QtConcurrentRun>
#include <QtConcurrent/QtConcurrent>

#define bytes_num 8
#define DIM_QUEUE 300000



class Mypushbutton: public QPushButton
{
  Q_OBJECT

  public:
  QPushButton* button;
  int on_off=0;
  std::string init_text;//TIME, STARTANDSTOP, SAMPLES
  double input_samples_num;
  int shared_flag_time=0;

  int time_convertion_value;

  public:
    Mypushbutton(QWidget * parentWidget)
    {
        button = new QPushButton();
        this->setParent(parentWidget);

    }

    ~Mypushbutton(){}

   public slots:

    void timeout(int time)
    {
        std::this_thread::sleep_for(std::chrono::milliseconds(time));
        this->shared_flag_time=1;
        std::this_thread::sleep_for(std::chrono::milliseconds(10));
    }

    void start_stop()
    {
        if(this->on_off==0){
            this->setText("Stop");
            this->on_off=1;
            QFuture<void> future = QtConcurrent::run([&]{this->acquisition();});
        }
        else if(this->on_off==1)
        {
            this->setText("Reset");
            this->on_off=2;
        }
        else if(this->on_off==2)
        {
            this->setText("Start");
            this->on_off=0;

        }

    }

    void set_sample_mode()
    {
        this->init_text="SAMPLES";

    }

    void set_time_mode()
    {
        this->init_text="TIME";

    }

    void set_startandstop_mode()
    {
        this->init_text="STARTANDSTOP";

    }

    void set_test_mode()
    {
        this->init_text="TEST";

    }

    void acquisition_t()
    {
        //std::thread t([&]{this->acquisition();});
        //t.join();
        QFuture<void> future = QtConcurrent::run([&]{this->acquisition();});

    }

    void acquisition()
    {
        FT_HANDLE ftHandle;
        FT_STATUS res;
        DWORD num;
        FT_DEVICE_LIST_INFO_NODE *devInfo;
        UCHAR LatencyTimer = 2; //our default setting is 16

        DWORD RxBytes=10000; //numero bytes ricevuti
        DWORD TxBytes=bytes_num; //numero bytes trasmessi
        DWORD numDevs;
        DWORD bytes_in_queue;
        res =FT_ListDevices(&num,NULL,FT_LIST_NUMBER_ONLY);
        // create the device information list
        res = FT_CreateDeviceInfoList(&numDevs);
        if (res == FT_OK) {
        printf("Number of devices is %d\n",numDevs);
        }
        else {
        // FT_CreateDeviceInfoList failed
        }
        if (numDevs > 0)
        {
            // allocate storage for list based on numDevs
            devInfo =
            (FT_DEVICE_LIST_INFO_NODE*)malloc(sizeof(FT_DEVICE_LIST_INFO_NODE)*numDevs);
            // get the device information list
            res = FT_GetDeviceInfoList(devInfo,&numDevs);
            if (res == FT_OK)
                {
                for (int i = 0; i < numDevs; i++)
                    {
                    printf("Dev %d:\n",i);
                    printf(" Flags=0x%x\n",devInfo[i].Flags);
                    printf(" Type=0x%x\n",devInfo[i].Type);
                    printf(" ID=0x%x\n",devInfo[i].ID);
                    printf(" LocId=0x%x\n",devInfo[i].LocId);
                    printf(" SerialNumber=%s\n",devInfo[i].SerialNumber);
                    printf(" Description=%s\n",devInfo[i].Description);
                    printf(" ftHandle=0x%x\n",devInfo[i].ftHandle);
                    }
                }
        }

        res =FT_Open(0,&ftHandle); //se sono attaccate entrambe le ftdi il valore deve essere 2, altrimenti 0 etc.
        res= FT_Purge (ftHandle, FT_PURGE_RX | FT_PURGE_TX);
        qDebug ()<<res;

        // OPEN DEVICE
        if(res==FT_OK)
            qDebug ()<< "device found and opened   ";
        else
            qDebug ()<< "ALARM no device found";

        // SET PARAMETERS
        res = FT_SetBitMode(ftHandle,0xff, 0x40);
        res = FT_SetLatencyTimer(ftHandle, LatencyTimer);
        res = FT_SetUSBParameters(ftHandle, 0x10000, 0x10000);
        res = FT_SetFlowControl(ftHandle, FT_FLOW_RTS_CTS, 0x0, 0x0);

        res =FT_ClrDtr(ftHandle);
        res= FT_SetDtr(ftHandle);

        FILE * pFile;
        pFile = fopen ( "C:/Users/Tesista/Documents/MATLAB/prova.bin", "w+b");

        double queue_num=0;
        unsigned char *RxBuffer_char;
        RxBuffer_char= new unsigned char[DIM_QUEUE];

        char TxBuffer_start[bytes_num]= {'C','O','M','M','A','N','D','X'};
        char TxBuffer_stop[bytes_num]= {'C','O','M','M','A','N','D','@'};


        //BOOT


        enum boot_types{SAMPLES, TIME, STARTANDSTOP, TEST};
        boot_types mode_of_execution;
        if(this->init_text=="SAMPLES")
            mode_of_execution=SAMPLES;
        if(this->init_text=="TIME")
            mode_of_execution=TIME;
        if(this->init_text=="STARTANDSTOP")
            mode_of_execution=STARTANDSTOP;
        if(this->init_text=="TEST")
            mode_of_execution=TEST;

        //SAMPLING VARIABLES
        //double input_samples_num=100000;
        double num_of_samples;


     // -----------------  This part contains data to write to device  --------------------


        switch(mode_of_execution){
        /*first case*/
            case (SAMPLES):

                num_of_samples=this->input_samples_num*32;//2 byte per data, 16 channels
                Sleep(100);
                res = FT_Write(ftHandle,TxBuffer_start,sizeof(TxBuffer_start),&TxBytes);
                if(TxBytes==8)
                qDebug()<<"Start Conversion";


                while(queue_num<num_of_samples)
                {
                    FT_GetQueueStatus (ftHandle, &bytes_in_queue); //scrive in bytes_in_queue il numero di bytes sul buffer di ricezione
                    if(bytes_in_queue>=100)
                    {
                        res = FT_Read(ftHandle,RxBuffer_char,bytes_in_queue,&RxBytes); //leggo il buffer di ricezione e lo scrive in RxBuffer
                        fwrite(RxBuffer_char, bytes_in_queue*sizeof(char),1,pFile);
                        queue_num= queue_num+bytes_in_queue;

                    }

                }
           break;

        /*second case*/
           case(TIME):
        {

                Sleep(100);

                res = FT_Write(ftHandle,TxBuffer_start,sizeof(TxBuffer_start),&TxBytes);
                std::thread time_out([&]{this->timeout(this->time_convertion_value);});
                if(TxBytes==8)
                qDebug()<<"Start Conversion";

                while(this->shared_flag_time==0)
                {
                    FT_GetQueueStatus (ftHandle, &bytes_in_queue); //scrive in bytes_in_queue il numero di bytes sul buffer di ricezione

                    if(bytes_in_queue>=100)
                    {
                        res = FT_Read(ftHandle,RxBuffer_char,bytes_in_queue,&RxBytes); //leggo il buffer di ricezione e lo scrive in RxBuffer
                        fwrite(RxBuffer_char, bytes_in_queue*sizeof(char),1,pFile);
                        queue_num= queue_num+bytes_in_queue;

                    }

                }
                shared_flag_time=0;
                time_out.join();
        }
            break;

          case (STARTANDSTOP):
        {

                Sleep(100);

                res = FT_Write(ftHandle,TxBuffer_start,sizeof(TxBuffer_start),&TxBytes);
                //std::thread time_out([&]{this->timeout(this->time_convertion_value);});
                if(TxBytes==8)
                qDebug()<<"Start Conversion";

                while(this->on_off==1)
                {
                    FT_GetQueueStatus (ftHandle, &bytes_in_queue); //scrive in bytes_in_queue il numero di bytes sul buffer di ricezione

                    if(bytes_in_queue>=100)
                    {
                        res = FT_Read(ftHandle,RxBuffer_char,bytes_in_queue,&RxBytes); //leggo il buffer di ricezione e lo scrive in RxBuffer
                        fwrite(RxBuffer_char, bytes_in_queue*sizeof(char),1,pFile);
                        queue_num= queue_num+bytes_in_queue;

                    }

                }
                //shared_flag=0;
                //time_out.join();
        }
            break;


          case (TEST):
                Sleep(100);
            break;

        }
        qDebug()<<queue_num;
        res = FT_Write(ftHandle,TxBuffer_stop,sizeof(TxBuffer_stop),&TxBytes);
        if(TxBytes==8)
            qDebug()<<"Convertion ended";
            qDebug()<<"";
            qDebug()<<"";
        FT_Close(ftHandle);
    }

    void convert(){
        char buffer [16];
        float volt;
        int j=0;
        int count=1;

        unsigned short *temp;
        unsigned short *canale;
        unsigned short *valore;
        unsigned char *buffer_memory_char;
        unsigned char *RxBuffer_char;

        temp= new unsigned short[DIM_QUEUE];
        canale= new unsigned short[DIM_QUEUE];
        valore= new unsigned short[DIM_QUEUE];
        buffer_memory_char= new unsigned char[DIM_QUEUE];
        RxBuffer_char= new unsigned char[DIM_QUEUE];


            FILE * pFile_read;
            pFile_read = fopen ( "C:/Users/Tesista/Documents/MATLAB/prova.bin", "rb");
             if (pFile_read==NULL)
             {
                 fputs ("File error",stderr);
                 exit (1);}
             else
                 fputs ("File ok\n",stderr);
            FILE * pFile_write;
            pFile_write = fopen ( "C:/Users/Tesista/Documents/MATLAB/prova_valori.txt", "wb");

            fseek (pFile_read , 0 , SEEK_END);
            long lSize = ftell (pFile_read);
            rewind (pFile_read);
            qDebug()<<lSize<<"byte da convertire\n";

            while(count<lSize/100)
            {
                j=0;
                fread(buffer_memory_char,100,1,pFile_read);

                for(int i=0;i<100;i+=2)
                    {
                        temp[j] = (short(buffer_memory_char[i])<<8) | (short(buffer_memory_char[i+1]));
                        canale[j]=temp[j]>>12;
                        valore[j]=temp[j]<<4;
                        valore[j]=valore[j]>>4;

                        j++;
                    }

                for(int q=0;q<j;q++)
                    {
                    for(int k=15; k>=0; --k)
                        {
                             buffer[15-k]=(temp[q] & (1<<k))?'1':'0'; //serve per convertire in binario
                        }

                    volt=5*float(valore[q])/float(4096);
                    fprintf (pFile_write, "%f, ",volt);
                     }
                count++;
            }
            qDebug()<<"finito";

        fclose(pFile_write);
        fclose(pFile_read);
    }

};
#endif // MY_PUSHBUTTON_H
