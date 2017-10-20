#include <QCoreApplication>
#include <QDebug>
#include <QElapsedTimer>
#include <windows.h> // for Sleep
#include "ftd2xx.h"
#include <string>

#define bytes_num 8
#define DIM_QUEUE 300000000

int main(int argc, char *argv[])
{
    QElapsedTimer myTimer;
    QCoreApplication a(argc, argv);
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

    res =FT_Open(2,&ftHandle); //se sono attaccate entrambe le ftdi il valore deve essere 2, altrimenti 0 etc.
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
    FILE * pFile;
    pFile = fopen ( "C:/Users/Tesista/Documents/MATLAB/prova.txt", "wb");

    res =FT_ClrDtr(ftHandle);
    res= FT_SetDtr(ftHandle);
    //unsigned short RxBuffer[ RxBytes];
    char buffer [16];
    float volt;
    int queue_num=0;
    int j=0;
    int count=1;

//    unsigned short temp[DIM_QUEUE];
//    unsigned short canale[DIM_QUEUE];
//    unsigned short valore[DIM_QUEUE];
//    unsigned char buffer_memory_char[DIM_QUEUE];
//    unsigned char RxBuffer_char[DIM_QUEUE];

    unsigned short *temp;
//    unsigned short *canale;
//    unsigned short *valore;
    unsigned char *buffer_memory_char;
    unsigned char *RxBuffer_char;
    temp= new unsigned short[DIM_QUEUE];
//    canale= new unsigned short[DIM_QUEUE];
//    valore= new unsigned short[DIM_QUEUE];
    buffer_memory_char= new unsigned char[DIM_QUEUE];
    RxBuffer_char= new unsigned char[DIM_QUEUE];



    char TxBuffer_start[bytes_num]= {'C','O','M','M','A','N','D','X'};
    char TxBuffer_stop[bytes_num]= {'C','O','M','M','A','N','D','@'};


    //BOOT
    std::string init_text ("SAMPLES");//TIME, STARTANDSTOP, SAMPLES
    enum boot_types{SAMPLES, TIME, STARTANDSTOP};
    boot_types mode_of_execution;
    if(init_text=="SAMPLES")
        mode_of_execution=SAMPLES;

    //SAMPLE VARIABLES
    int input_samples_num=5000000;
    int num_of_samples;



 // -----------------  This part contains data to write to device  --------------------

    switch(mode_of_execution){
    /*first case*/
    case (SAMPLES):

        num_of_samples=input_samples_num*32;//2 byte per data, 16 channels
        Sleep(100);
        res = FT_Write(ftHandle,TxBuffer_start,sizeof(TxBuffer_start),&TxBytes);
        if(TxBytes==8)
        qDebug()<<"Ready to convert";


        while(queue_num<num_of_samples)
        {
            FT_GetQueueStatus (ftHandle, &bytes_in_queue); //scrive in bytes_in_queue il numero di bytes sul buffer di ricezione
            if(bytes_in_queue>=100)
            {
                res = FT_Read(ftHandle,RxBuffer_char,bytes_in_queue,&RxBytes); //leggo il buffer di ricezione e lo scrive in RxBuffer
                memcpy (&buffer_memory_char[(queue_num)], RxBuffer_char, bytes_in_queue*sizeof(char));
                queue_num= queue_num+bytes_in_queue;
            }

        }
        break;

    /*second case*/
   case(TIME):
        break;
    }



    for(int i=0;i<queue_num;i+=2)
    {
            temp[j] = (short(buffer_memory_char[i])<<8) | (short(buffer_memory_char[i+1]));

//            canale[j]=temp[j]>>12;
//            valore[j]=temp[j]<<4;
//            valore[j]=valore[j]>>4;
            j++;

    }

    for(int q=0;q<j;q++)
        {
        for(int k=15; k>=0; --k)
            {
                 buffer[15-k]=(temp[q] & (1<<k))?'1':'0'; //serve per convertire in binario
            }

        //volt=5*float(valore[q])/float(4096);

        // fprintf (pFile, "%f, ",volt);

        fprintf(pFile, "%c", temp[q]);
        //qDebug()<<canale[q]<<"canale --" <<buffer[4]<< buffer[5]<< buffer[6]<< buffer[7]<< buffer[8]<< buffer[9]<< buffer[10]<< buffer[11]<< buffer[12]<< buffer[13]<< buffer[14]<< buffer[15]<< "--->"<<volt<<"V";


        if(q/count==100000)
            {
                float perc=float(q)/float(j);
                perc=perc*100;
                qDebug()<<perc<<"%";
                count++;
            }
        }
    qDebug()<<"finito";
    qDebug()<<j;
    fclose (pFile);

    res = FT_Write(ftHandle,TxBuffer_stop,sizeof(TxBuffer_stop),&TxBytes);
    if(TxBytes==8)
        qDebug()<<"Convertion ended";

    FT_Close(ftHandle);
    return a.exec();
}
