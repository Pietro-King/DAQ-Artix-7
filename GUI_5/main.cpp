//#include "mainwindow.h"
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


using namespace std;
using namespace std::chrono;

#define bytes_num 8
#define DIM_QUEUE 3000000
int shared_flag=0;

void timeout(int time){
    for(int i=0; i<10;i++){
        this_thread::sleep_for(milliseconds(time/10));
        //qDebug()<<"passati"<<time/10*(i+1)<<endl;
    }
    shared_flag=1;
    this_thread::sleep_for(milliseconds(10));
}

int main(int argc, char *argv[])
{
    QElapsedTimer myTimer;
    QApplication a(argc, argv);



    QWidget *mainWindow = new QWidget;
    QVBoxLayout *layout = new QVBoxLayout();
    mainWindow->setWindowTitle("Acquisition Settings");
    mainWindow->resize(400,300);

    QLabel *label=new QLabel;
    label->setText("Choose one mode of acquistion");
    QTabWidget *tab=new QTabWidget;
    tab->addTab(new samples(),"Set Samples");
    tab->addTab(new mode_time(),"Set Time");
    tab->addTab(new startandstop(),"Start and Stop");
    tab->addTab(new construction(),"...");

    layout->addWidget(label,0);
    layout->addWidget(tab);

    mainWindow->setLayout(layout);
    mainWindow->show();




//    FT_HANDLE ftHandle;
//    FT_STATUS res;
//    DWORD num;
//    FT_DEVICE_LIST_INFO_NODE *devInfo;
//    UCHAR LatencyTimer = 2; //our default setting is 16

//    DWORD RxBytes=10000; //numero bytes ricevuti
//    DWORD TxBytes=bytes_num; //numero bytes trasmessi

//    DWORD numDevs;
//    DWORD bytes_in_queue;

//    res =FT_ListDevices(&num,NULL,FT_LIST_NUMBER_ONLY);
//    // create the device information list
//    res = FT_CreateDeviceInfoList(&numDevs);
//    if (res == FT_OK) {
//    printf("Number of devices is %d\n",numDevs);
//    }
//    else {
//    // FT_CreateDeviceInfoList failed
//    }
//    if (numDevs > 0)
//    {
//        // allocate storage for list based on numDevs
//        devInfo =
//        (FT_DEVICE_LIST_INFO_NODE*)malloc(sizeof(FT_DEVICE_LIST_INFO_NODE)*numDevs);
//        // get the device information list
//        res = FT_GetDeviceInfoList(devInfo,&numDevs);
//        if (res == FT_OK)
//            {
//            for (int i = 0; i < numDevs; i++)
//                {
//                printf("Dev %d:\n",i);
//                printf(" Flags=0x%x\n",devInfo[i].Flags);
//                printf(" Type=0x%x\n",devInfo[i].Type);
//                printf(" ID=0x%x\n",devInfo[i].ID);
//                printf(" LocId=0x%x\n",devInfo[i].LocId);
//                printf(" SerialNumber=%s\n",devInfo[i].SerialNumber);
//                printf(" Description=%s\n",devInfo[i].Description);
//                printf(" ftHandle=0x%x\n",devInfo[i].ftHandle);
//                }
//            }
//    }

//    res =FT_Open(0,&ftHandle); //se sono attaccate entrambe le ftdi il valore deve essere 2, altrimenti 0 etc.
//    res= FT_Purge (ftHandle, FT_PURGE_RX | FT_PURGE_TX);
//    qDebug ()<<res;

//    // OPEN DEVICE
//    if(res==FT_OK)
//        qDebug ()<< "device found and opened   ";
//    else
//        qDebug ()<< "ALARM no device found";

//    // SET PARAMETERS
//    res = FT_SetBitMode(ftHandle,0xff, 0x40);
//    res = FT_SetLatencyTimer(ftHandle, LatencyTimer);
//    res = FT_SetUSBParameters(ftHandle, 0x10000, 0x10000);
//    res = FT_SetFlowControl(ftHandle, FT_FLOW_RTS_CTS, 0x0, 0x0);

//    res =FT_ClrDtr(ftHandle);
//    res= FT_SetDtr(ftHandle);

//    FILE * pFile;
//    pFile = fopen ( "C:/Users/Tesista/Documents/MATLAB/prova.bin", "w+b");

//    double queue_num=0;
//    unsigned char *RxBuffer_char;
//    RxBuffer_char= new unsigned char[DIM_QUEUE];

//    char TxBuffer_start[bytes_num]= {'C','O','M','M','A','N','D','X'};
//    char TxBuffer_stop[bytes_num]= {'C','O','M','M','A','N','D','@'};


//    //BOOT
//    std::string init_text ("SAMPLES");//TIME, STARTANDSTOP, SAMPLES




//    enum boot_types{SAMPLES, TIME, STARTANDSTOP, TEST};
//    boot_types mode_of_execution;
//    if(init_text=="SAMPLES")
//        mode_of_execution=SAMPLES;
//    if(init_text=="TIME")
//        mode_of_execution=TIME;
//    if(init_text=="STARTANDSTOP")
//        mode_of_execution=STARTANDSTOP;
//    if(init_text=="TEST")
//        mode_of_execution=TEST;

//    //SAMPLING VARIABLES
//    double input_samples_num=10000;
//    double num_of_samples;


// // -----------------  This part contains data to write to device  --------------------


//    switch(mode_of_execution){
//    /*first case*/
//        case (SAMPLES):

//            num_of_samples=input_samples_num*32;//2 byte per data, 16 channels
//            Sleep(100);
//            res = FT_Write(ftHandle,TxBuffer_start,sizeof(TxBuffer_start),&TxBytes);
//            if(TxBytes==8)
//            qDebug()<<"Start Conversion";


//            while(queue_num<num_of_samples)
//            {
//                FT_GetQueueStatus (ftHandle, &bytes_in_queue); //scrive in bytes_in_queue il numero di bytes sul buffer di ricezione
//                if(bytes_in_queue>=100)
//                {
//                    res = FT_Read(ftHandle,RxBuffer_char,bytes_in_queue,&RxBytes); //leggo il buffer di ricezione e lo scrive in RxBuffer
//                    fwrite(RxBuffer_char, bytes_in_queue*sizeof(char),1,pFile);
//                    queue_num= queue_num+bytes_in_queue;

//                }

//            }
//       break;

//    /*second case*/
//       case(TIME):
//    {

//            Sleep(100);

//            res = FT_Write(ftHandle,TxBuffer_start,sizeof(TxBuffer_start),&TxBytes);
//            thread time_out(timeout,1000);
//            if(TxBytes==8)
//            qDebug()<<"Start Conversion";

//            while(shared_flag==0)
//            {
//                FT_GetQueueStatus (ftHandle, &bytes_in_queue); //scrive in bytes_in_queue il numero di bytes sul buffer di ricezione

//                if(bytes_in_queue>=100)
//                {
//                    res = FT_Read(ftHandle,RxBuffer_char,bytes_in_queue,&RxBytes); //leggo il buffer di ricezione e lo scrive in RxBuffer
//                    fwrite(RxBuffer_char, bytes_in_queue*sizeof(char),1,pFile);
//                    queue_num= queue_num+bytes_in_queue;

//                }

//            }
//            time_out.join();
//    }
//        break;

//      case (STARTANDSTOP):
//            Sleep(100);
//        break;


//      case (TEST):
//            Sleep(100);
//        break;

//    }


//    qDebug()<<queue_num;

//    res = FT_Write(ftHandle,TxBuffer_stop,sizeof(TxBuffer_stop),&TxBytes);
//    if(TxBytes==8)
//        qDebug()<<"Convertion ended";


//    FT_Close(ftHandle);
    return a.exec();
}
