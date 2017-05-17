#include <io.h>
#include <stdio.h>
#include <winsock2.h>
#include <time.h>

#define	MAX_BUFFER 6000
#define LEN 150

int main(int argc , char *argv[])
{
    fd_set fds;
    WSADATA wsa;
    time_t rawTime;
    struct timeval tv ;
    struct tm * timeInfo;
    int allocatedSize, readSize=0, n;
    SOCKET serverSocket, clientSocket;
    struct sockaddr_in serverAddress, clientAddress;
    char clientMessage[MAX_BUFFER], buf[LEN];

    //char body[MAX_BUFFER], head[MAX_BUFFER], total[MAX_BUFFER];

    char command[256];

    char * pch;

    int i = 0, ret = 0;;

    char * txt[4];

    system("CLS");

    printf("Initialising Winsock: ");
    if (WSAStartup(MAKEWORD(2,2),&wsa) != 0)
    {
        printf("Failed. Error Code : %d",WSAGetLastError());
        return 1;
    }
    else
    {
        printf("Successful\n");
    }

    printf("Creating Server Socket: ");
    if((serverSocket = socket(AF_INET , SOCK_STREAM , 0 )) == INVALID_SOCKET)
    {
        printf("Failed. Error Code : %d",WSAGetLastError());
        return 1;
    }
    else
    {
        printf("Successful\n");
    }

    serverAddress.sin_family = AF_INET;
    serverAddress.sin_addr.s_addr = INADDR_ANY;
    serverAddress.sin_port = htons(8888);

    printf("Binding Server Socket: ");
    if(bind(serverSocket ,(struct sockaddr *)&serverAddress , sizeof(serverAddress)) == SOCKET_ERROR)
    {
        printf("Failed. Error Code : %d",WSAGetLastError());
        return 1;
    }
    else
    {
        printf("Successful\n");
    }

    listen(serverSocket , 256);

    while(1)
    {
        printf("\nWaiting for incoming connections: ");

        allocatedSize = sizeof(struct sockaddr_in);
        clientSocket = accept(serverSocket , (struct sockaddr *)&clientAddress, &allocatedSize);
        if (clientSocket == INVALID_SOCKET)
        {
            printf("Failed. Error Code : %d",WSAGetLastError());
        }
        else
        {
            printf("Connection accepted\n");
        }

        do
        {
            FD_ZERO(&fds) ;
            FD_SET(clientSocket, &fds) ;

            tv.tv_sec = 3 ;
            tv.tv_usec = 500000 ;

            n = select ( clientSocket, &fds, NULL, NULL, &tv ) ;
            if ( n == 0)
            {
                printf("\nTimeout\n");
                break;
            }
            else if( n == -1 )
            {
                printf("Error\n");
                return 1;
            }

            readSize = recv(clientSocket , clientMessage , 256 , 0);
            if (readSize > 0)
            {

                clientMessage[readSize] = '\0';

                rawTime = time(NULL);
                timeInfo = localtime(&rawTime);
                strftime (buf, LEN, "%H:%M:%S", timeInfo);
                printf("\n%s -> %d Character Received : \n%s\n",buf,readSize,clientMessage);
                i=0;
                pch = strtok (clientMessage,"|");
                while (pch != NULL)
                {
                    txt[i] = pch;
                    pch = strtok (NULL, "|");
                    i++;
                }

                sprintf(command,"PKM.exe %s %s %s %s",txt[0],txt[1],txt[2],txt[3]);

                //int i = printf(command);

                //printf("%d",i);

                ret = system(command);
                //if (ret != 0) return;
            }
        }
        while (readSize>0);

        if(readSize == -1)
        {
            printf("Receiving data Failed\n");
        }

    }

    printf("Closing Server Socket\n\n");
    closesocket(serverSocket);

    printf("Deinitialising Winsock\n");
    WSACleanup();

    return 0;
}
