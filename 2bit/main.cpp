#include <QCoreApplication>
#include <QDebug>
#include <QElapsedTimer>
#include <windows.h> // for Sleep
#include "ftd2xx.h"
#define bytes_num 8
#define DIM_QUEUE 3
int main(int argc, char *argv[])
{
    QElapsedTimer myTimer;
    QCoreApplication a(argc, argv);
    FT_HANDLE ftHandle;
    FT_STATUS res;
    DWORD num;
    FT_DEVICE_LIST_INFO_NODE *devInfo;
    UCHAR LatencyTimer = 2; //our default setting is 16
    int error_count=0;
    DWORD RxBytes=1; //numero bytes ricevuti
    DWORD TxBytes=bytes_num; //numero bytes trasmessi
    DWORD EventDWord;
    DWORD numDevs;
    DWORD bytes_in_queue;


    char buffer [16];
    char str[12];
    float volt;
    unsigned short temp[DIM_QUEUE];
    int queue_num=0;


    res =FT_ListDevices(&num,NULL,FT_LIST_NUMBER_ONLY);
    // create the device information list
    res = FT_CreateDeviceInfoList(&numDevs);
    if (res == FT_OK) {
    printf("Number of devices is %d\n",numDevs);
    }
    else {
    // FT_CreateDeviceInfoList failed
    }
    if (numDevs > 0) {
    // allocate storage for list based on numDevs
    devInfo =
    (FT_DEVICE_LIST_INFO_NODE*)malloc(sizeof(FT_DEVICE_LIST_INFO_NODE)*numDevs);
    // get the device information list
    res = FT_GetDeviceInfoList(devInfo,&numDevs);
    if (res == FT_OK) {
    for (int i = 0; i < numDevs; i++) {
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

    // SET TIMEOUTS

    res =FT_ClrDtr(ftHandle);
    res= FT_SetDtr(ftHandle);
    unsigned short RxBuffer[ RxBytes];                                            //nuovo
     char TxBuffer[bytes_num]= {'C','O','M','M','A','N','D','@'};




 // -----------------  This part contains data to write to device  --------------------


Sleep(100);
res = FT_Write(ftHandle,TxBuffer,sizeof(TxBuffer),&TxBytes);
if(TxBytes==8)
qDebug()<<"Ready to convert";

Sleep(100);
//qDebug()<<"Ready to convert";
//res = FT_Read(ftHandle,RxBuffer,bytes_in_queue,&RxBytes);

while(queue_num<DIM_QUEUE){
    FT_GetQueueStatus (ftHandle, &bytes_in_queue); //scrive in bytes_in_queue il numero di bytes sul buffer di ricezione
    //qDebug()<<"bytes in queue"<<bytes_in_queue;
    res = FT_Read(ftHandle,RxBuffer,bytes_in_queue,&RxBytes); //leggo il buffer di ricezione e lo scrive in RxBuffer

    if(bytes_in_queue>0)
    {
        temp[queue_num] = (RxBuffer[0]>>8) | (RxBuffer[0]<<8);  //l'rx buffer ha i due byte invertiti, con questo comando li inverto in temp
        temp[queue_num]=temp[queue_num]>>2; //tolgo gli ultimi zeri
        queue_num++;
        qDebug()<<queue_num<<" valore inserito";
    }
    //else
       // qDebug()<<"Waiting Trigger";
    Sleep(1000);
}

for(int q=0;q<DIM_QUEUE;q++){
    for(int j=15; j>=0; --j)
        {
             buffer[15-j]=(temp[q] & (1<<j))?'1':'0'; //serve per convertire in binario
        }

    volt=5*float(temp[q])/float(4096);
    qDebug()<< buffer[4]<< buffer[5]<< buffer[6]<< buffer[7]<< buffer[8]<< buffer[9]<< buffer[10]<< buffer[11]<< buffer[12]<< buffer[13]<< buffer[14]<< buffer[15]<< "--->"<<volt<<"V";
}

FT_Close(ftHandle);
return a.exec();
}
