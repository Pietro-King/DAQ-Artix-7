#include <QCoreApplication>
#include <QDebug>
#include <QElapsedTimer>
#include <windows.h> // for Sleep
#include "ftd2xx.h"
#define bytes_num 65536
int main(int argc, char *argv[])
{
    QElapsedTimer myTimer;
    QCoreApplication a(argc, argv);
    FT_HANDLE ftHandle;
    FT_STATUS res;
    DWORD num;
    UCHAR LatencyTimer = 2; //our default setting is 16
    int error_count=0;
    DWORD RxBytes=bytes_num; //numero bytes ricevuti
    DWORD TxBytes=bytes_num; //numero bytes trasmessi
    DWORD EventDWord;
    res =FT_ListDevices(&num,NULL,FT_LIST_NUMBER_ONLY);
    res =FT_Open(0,&ftHandle);
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
    char RxBuffer[bytes_num];
    char TxBuffer[bytes_num];
//  for(int i=0;i<=bytes_num;i+=2)
//    {
//        TxBuffer[i]=i&0xff;
//         //qDebug()<<"primo byte"<<TxBuffer[i];
//       TxBuffer[i+1]=(i>>8);
//        //qDebug()<<"secondo byte"<<TxBuffer[i+1];
//    }
    // Contains data to write to device
    int counter=100000;

    Sleep(10);
    myTimer.start();

    while(counter>=0)
    {


res = FT_Read(ftHandle,RxBuffer,RxBytes,&RxBytes);
//res = FT_Write(ftHandle,TxBuffer,sizeof(TxBuffer),&TxBytes);
//FT_GetStatus(ftHandle,&RxBytes,&TxBytes,&EventDWord);





    //qDebug()<<"read"<<RxBytes<<"data";
    if (res == FT_OK) {
//qDebug()<<"OK";
        // FT_Read OK
    } else {
         qDebug()<<"READ ERROR";
        // FT_Read Failed } }



}
    for(int i=0;i<=bytes_num;i++)
    {
//         TxBuffer[i]=i&0xff;
         if(RxBuffer[i]==0x05)
         {
            // qDebug()<<"received 5";



         }
                       else if(RxBuffer[i]==0x0D)
             {
                       //qDebug()<<"received 13";

         }
                       else
         {
                       //qDebug()<<"received shit";
                       error_count++;
         }


    }




  counter--;


}
   // int nMilliseconds = myTimer.msecsSinceReference();
   //     qDebug()<<"time elapsed"<<nMilliseconds;

    qDebug() << "The operation took" << myTimer.elapsed() << "milliseconds";
        qDebug()<<"NUM TOT DATA ERROR"<<error_count;
    error_count=0;
FT_Close(ftHandle);
return a.exec();
}
