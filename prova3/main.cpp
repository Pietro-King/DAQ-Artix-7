#include <QCoreApplication>
#include <QDebug>
#include <QElapsedTimer>
#include <windows.h> // for Sleep
#include "ftd2xx.h"
#define bytes_num 8
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


    char buffer [8] ;// nuovo char


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

    res =FT_Open(2,&ftHandle);
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
     char RxBuffer[ RxBytes];                                            //nuovo
     char TxBuffer[bytes_num]= {'C','O','M','M','A','N','D','@'};




 // -----------------  This part contains data to write to device  --------------------

      //for(int i=0;i<=bytes_num;i+=2)






Sleep(100);
res = FT_Write(ftHandle,TxBuffer,sizeof(TxBuffer),&TxBytes);
qDebug()<<TxBytes;
qDebug()<<"bytes sent";

Sleep(100);



res = FT_Read(ftHandle,RxBuffer,sizeof(RxBuffer),&RxBytes);                //nuovo
float volt;
while(1){
for(int i=0;i<RxBytes;i++)
{

    for(int j=7; j>=0; --j)
    {
        buffer[7-j]=(RxBuffer[i] & (1<<j))?'1':'0';
    }
    volt=5*float(RxBuffer[i])/float(64);
    qDebug()<< buffer<< "--->"<<volt<<"V";

    Sleep(1000);
//    qDebug()<<prova;
}
}


//  qDebug()<<"read"<<RxBytes<<"data";
//  if (res == FT_OK) {
////qDebug()<<"OK";
////        // FT_Read OK
//   }

//  else {
//        qDebug()<<"READ ERROR";
//        // FT_Read Failed } }

//}
//    for(int i=0;i<bytes_num;i++)
//    {
////        TxBuffer[i]=i&0xff;
// qDebug()<<"tx"<<TxBuffer[i];
// qDebug()<<"rx"<<RxBuffer[i];



FT_Close(ftHandle);
return a.exec();
}
