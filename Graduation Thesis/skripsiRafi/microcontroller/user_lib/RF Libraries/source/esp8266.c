#include "esp8266.h"

bool esp8266_init()
{
	int i,j;

	UB_LCD_SetLayer_2();
	UB_LCD_FillLayer(RGB_COL_WHITE);

	for(i=0;i<320;i++)
	{
		UB_LCD_SetCursor2Draw(0,i);
		UB_LCD_DrawPixel(RGB_COL_BLACK);
		UB_LCD_SetCursor2Draw(11,i);
		UB_LCD_DrawPixel(RGB_COL_BLACK);
		UB_LCD_SetCursor2Draw(12,i);
		UB_LCD_DrawPixel(RGB_COL_BLACK);

		for(j=239;j>=224;j--)
		{
			UB_LCD_SetCursor2Draw(j,i);
			UB_LCD_DrawPixel(RGB_COL_BLACK);
		}
	}
	UB_Font_DrawString(0,0," Rafi Kurnia Putra - 1206261850 - Telemedical ",&Arial_7x10,RGB_COL_WHITE,RGB_COL_BLACK);

	UB_Font_DrawString(225,80,"ESP8266 Initialization",&Arial_7x10,RGB_COL_WHITE,RGB_COL_BLACK);
	UB_Uart_Init(); // (COM1 : TX=PA9, RX=PA10)

	UB_Font_DrawString(210,2,"RESET ESP8266                :",&Arial_7x10,RGB_COL_BLACK,RGB_COL_WHITE);
	if (esp8266_reset()) UB_Font_DrawString(210,220,"SUCCESSFUL",&Arial_7x10,RGB_COL_BLACK,RGB_COL_WHITE);
	else
	{
		UB_Font_DrawString(210,220,"FAILED",&Arial_7x10,RGB_COL_BLACK,RGB_COL_WHITE);
		UB_Font_DrawString(180,2,"AN ERROR OCCURRED, PLEASE RESET",&Arial_7x10,RGB_COL_BLACK,RGB_COL_WHITE);
		for( ;; );
	}
	esp8266_delay(1800000000);

//	UB_Font_DrawString(195,2,"SET TO CLIENT MODE           :",&Arial_7x10,RGB_COL_BLACK,RGB_COL_WHITE);
//	if (esp8266_setMode()) UB_Font_DrawString(195,220,"SUCCESSFUL",&Arial_7x10,RGB_COL_BLACK,RGB_COL_WHITE);
//	else
//	{
//		UB_Font_DrawString(195,220,"FAILED",&Arial_7x10,RGB_COL_BLACK,RGB_COL_WHITE);
//		UB_Font_DrawString(165,2,"AN ERROR OCCURRED, PLEASE RESET",&Arial_7x10,RGB_COL_BLACK,RGB_COL_WHITE);
//		for( ;; );
//	}
//	esp8266_delay(1800000000);

	UB_Font_DrawString(180,2,"DISCONNECT FROM ACCESS POINT :",&Arial_7x10,RGB_COL_BLACK,RGB_COL_WHITE);
	if (esp8266_disconnect()) UB_Font_DrawString(180,220,"SUCCESSFUL",&Arial_7x10,RGB_COL_BLACK,RGB_COL_WHITE);
	else
	{
		UB_Font_DrawString(180,220,"FAILED",&Arial_7x10,RGB_COL_BLACK,RGB_COL_WHITE);
		UB_Font_DrawString(150,2,"AN ERROR OCCURRED, PLEASE RESET",&Arial_7x10,RGB_COL_BLACK,RGB_COL_WHITE);
		for( ;; );
	}
	esp8266_delay(1800000000);

	UB_Font_DrawString(165,2,"CONNECT TO ACCESS POINT      :",&Arial_7x10,RGB_COL_BLACK,RGB_COL_WHITE);
	if (esp8266_connect(false)) UB_Font_DrawString(165,220,"SUCCESSFUL",&Arial_7x10,RGB_COL_BLACK,RGB_COL_WHITE);
	else
	{
		UB_Font_DrawString(165,220,"FAILED",&Arial_7x10,RGB_COL_BLACK,RGB_COL_WHITE);
		UB_Font_DrawString(135,2,"AN ERROR OCCURRED, PLEASE RESET",&Arial_7x10,RGB_COL_BLACK,RGB_COL_WHITE);
		UB_Font_DrawString(120,2,"OR PRESS BUTTON TO CONTINUE IN OFFLINE MODE",&Arial_7x10,RGB_COL_BLACK,RGB_COL_WHITE);
		for( ;; )
		{
			if (UB_Button_Read(BTN_USER)==BTN_PRESSED)
			{
				return false;
			}
		}
	}
	esp8266_delay(1800000000);

//	UB_Font_DrawString(150,2,"SET TO MULTI CHANNEL         :",&Arial_7x10,RGB_COL_BLACK,RGB_COL_WHITE);
//	if (esp8266_multi()) UB_Font_DrawString(150,220,"SUCCESSFUL",&Arial_7x10,RGB_COL_BLACK,RGB_COL_WHITE);
//	else
//	{
//		UB_Font_DrawString(150,220,"FAILED",&Arial_7x10,RGB_COL_BLACK,RGB_COL_WHITE);
//		UB_Font_DrawString(115,2,"AN ERROR OCCURRED, PLEASE RESET",&Arial_7x10,RGB_COL_BLACK,RGB_COL_WHITE);
//		for( ;; );
//	}
//
//	UB_Font_DrawString(115,2,"INITIALIZATION IS DONE, STARTING RTOS...",&Arial_7x10,RGB_COL_BLACK,RGB_COL_WHITE);
//	esp8266_delay(18000000000);
	return true;
//	UB_Font_DrawString(135,2,"START CONNECTION             :",&Arial_7x10,RGB_COL_BLACK,RGB_COL_WHITE);
//	if (esp8266_handshake()) UB_Font_DrawString(135,220,"SUCCESSFUL",&Arial_7x10,RGB_COL_BLACK,RGB_COL_WHITE);
//	else UB_Font_DrawString(135,220,"FAILED",&Arial_7x10,RGB_COL_BLACK,RGB_COL_WHITE);
//	esp8266_delay(1800000000);
//	UB_Font_DrawString(120,2,"SEND DATA TO SERVER          :",&Arial_7x10,RGB_COL_BLACK,RGB_COL_WHITE);
//	if (esp8266_sendString("GET /AGV/setAll/1/76/1/1/1/1/1\r\n")) UB_Font_DrawString(120,220,"SUCCESSFUL",&Arial_7x10,RGB_COL_BLACK,RGB_COL_WHITE);
//	else UB_Font_DrawString(120,220,"FAILED",&Arial_7x10,RGB_COL_BLACK,RGB_COL_WHITE);
//	esp8266_delay(1800000000);
//	UB_Font_DrawString(105,2,"CLOSE CONNETION              :",&Arial_7x10,RGB_COL_BLACK,RGB_COL_WHITE);
//	if (esp8266_close()) UB_Font_DrawString(105,220,"SUCCESSFUL",&Arial_7x10,RGB_COL_BLACK,RGB_COL_WHITE);
//	else UB_Font_DrawString(105,220,"FAILED",&Arial_7x10,RGB_COL_BLACK,RGB_COL_WHITE);
//	esp8266_delay(1800000000);

}

void esp8266_delay(uint32_t a)
{
	uint32_t j = 0,i;
	for (i=0;i<5000;i++)
		for( ;; )
		{
			j++;
			if (j == a) {
				break;
			}
		}
}

int waitForRespond(int timeOut, bool DEBUG)
{
	int i,j;
	bool out = false, done = false;
	char lcd[50];

	for(i=0;i<31;i++)
	{
		j=0;
		if (out) break;
		do
		{
			if (DEBUG)
			{
				sprintf(lcd,"for:%d while:%d",i,j);
				UB_Font_DrawString(45,2,lcd,&Arial_7x10,RGB_COL_GREEN,RGB_COL_BLACK);
			}
			j++;
			if (j == timeOut) out = true;
			if (out) break;

			check=UB_Uart_ReceiveString(COM1,rx_buf);
			if (check==RX_READY) {
				done = true;
			}

			if (rx_buf[0] == '>')
			{
				out = true;
				return 4;
			}

			if (done)
			{
				done = false;
				if ((rx_buf[0] == 'O') && (rx_buf[1] == 'K'))
				{
					out = true;
					return 0;
				}
				else if ((rx_buf[0] == 'E') && (rx_buf[1] == 'R') && (rx_buf[2] == 'R') && (rx_buf[3] == 'O') && (rx_buf[4] == 'R'))
				{
					out = true;
					return 1;
				}
				else if ((rx_buf[0] == 'F') && (rx_buf[1] == 'A') && (rx_buf[2] == 'I') && (rx_buf[3] == 'L'))
				{
					out = true;
					return 2;
				}
				else if ((rx_buf[0] == 'i') && (rx_buf[1] == 'n') && (rx_buf[2] == 'v') && (rx_buf[3] == 'a') && (rx_buf[4] == 'l') && (rx_buf[5] == 'i') && (rx_buf[6] == 'd'))
				{
					out = true;
					return 3;
				}
				else if (rx_buf[0] == '>')
				{
					out = true;
					return 4;
				}
			}
		}
		while(check!=RX_READY);
	}
	return 5;
}

int waitAndEcho()
{
	bool out=false,done=false;
	int i,j;
	char lcd[30];

	for(i=0;i<31;i++)
	{
		j=0;
		if (out) break;
		do
		{
			j++;
			if (j == 100000000) out = true;
			if (out) break;
			check=UB_Uart_ReceiveString(COM1,rx_buf);
			if (check==RX_READY) {
				done = true;
				sprintf(lcd,"%d",i);
				UB_Font_DrawString(((-i+10)*10)-10,2,lcd,&Arial_7x10,RGB_COL_WHITE,RGB_COL_RED);
				UB_Font_DrawString(((-i+10)*10)-10,16,rx_buf,&Arial_7x10,RGB_COL_WHITE,RGB_COL_RED);
			}
			if (done)
			{
				done = false;
				if ((rx_buf[0] == 'O') && (rx_buf[1] == 'K'))
				{
					out = true;
					return (i*10)+0;
				}
				else if ((rx_buf[0] == 'E') && (rx_buf[1] == 'R') && (rx_buf[2] == 'R') && (rx_buf[3] == 'O') && (rx_buf[4] == 'R'))
				{
					out = true;
					return (i*10)+1;
				}
				else if ((rx_buf[0] == 'F') && (rx_buf[1] == 'A') && (rx_buf[2] == 'I') && (rx_buf[3] == 'L'))
				{
					out = true;
					return (i*10)+2;
				}
				else if ((rx_buf[0] == 'i') && (rx_buf[1] == 'n') && (rx_buf[2] == 'v') && (rx_buf[3] == 'a') && (rx_buf[4] == 'l') && (rx_buf[5] == 'i') && (rx_buf[6] == 'd'))
				{
					out = true;
					return (i*10)+3;
				}
			}
			sprintf(lcd,"%d %d",j,i);
			UB_Font_DrawString(15,200,lcd,&Arial_7x10,RGB_COL_WHITE,RGB_COL_RED);
		}
		while(check!=RX_READY);
	}
	return (i*10)+4;
}

bool esp8266_isConnected()
{
	int i;
	bool out = false, done = false;

	UB_Uart_SendString(COM1,"AT+CWJAP?", CRLF);

	for(i=0;i<31;i++)
	{
		if (out) break;
		do
		{
			if (out) break;

			check=UB_Uart_ReceiveString(COM1,rx_buf);
			if (check==RX_READY) {
				done = true;
			}
			if (done)
			{
				done = false;
				if ((rx_buf[8] == 't') && (rx_buf[9] == 'e') && (rx_buf[10] == 'l') && (rx_buf[11] == 'e') && (rx_buf[12] == 'm') && (rx_buf[13] == 'o'))
				{
					out = true;
					return true;
				}
				else if ((rx_buf[0] == 'N') && (rx_buf[1] == 'o') && (rx_buf[3] == 'A') && (rx_buf[4] == 'P'))
				{
					out = true;
					return false;
				}
			}
		}
		while(check!=RX_READY);
	}
	return false;
}

bool esp8266_isMulti()
{
	int i,j;
	bool out = false, done = false;

	UB_Uart_SendString(COM1,"AT+CIPMUX?", CRLF);

	for(i=0;i<31;i++)
	{
		j=0;
		if (out) break;
		do
		{
			j++;
			if (j == 100000000) out = true;
			if (out) break;

			check=UB_Uart_ReceiveString(COM1,rx_buf);
			if (check==RX_READY) {
				done = true;
			}
			if (done)
			{
				done = false;
				if (rx_buf[8] == '1')
				{
					out = true;
					return true;
				}
				else if (rx_buf[8] == '0')
				{
					out = true;
					return false;
				}
			}
		}
		while(check!=RX_READY);
	}
	return false;
}

bool esp8266_reset()
{
	int i,j;
	volatile uint32_t k;
	bool out = false, done = false, first=true;

	for(i=0;i<31;i++)
	{
		j=0;
		if (out) break;
		do
		{
			j++;
			if (j==100000000) out = true;
			if (out) break;

			check=UB_Uart_ReceiveString(COM1,rx_buf);


			if (first && (j%3==0))
			{
				first = false;
				Set_Lo(Pin_Relay);
			}

			if (check==RX_READY) {
				done = true;
			}
			if (done)
			{
				done = false;
				if ((rx_buf[0] == 'r') && (rx_buf[1] == 'e') && (rx_buf[2] == 'a') && (rx_buf[3] == 'd') && (rx_buf[4] == 'y'))
				{
					out = true;
					return true;
				}
			}
		}
		while(check!=RX_READY);
	}
	return false;
}

bool esp8266_setMode()
{
	int i,j=0;

	for( ;; )
	{
		UB_Uart_SendString(COM1, "AT+CWMODE=1", CRLF);
		i = waitForRespond(100000000,false);
		if (i == 0) return true;
		else
		{
			j++;
			if (j==3) return false;
		}
	}
}


bool esp8266_disconnect()
{
	int i,j=0;
	for( ;; )
	{
		UB_Uart_SendString(COM1, "AT+CWQAP", CRLF);
		i = waitForRespond(100000000,false);
		if (i == 0) return true;
		else
		{
			j++;
			if (j==3) return false;
		}
	}

}

bool esp8266_connect(bool DEBUG)
{
	int i,j=0;
	char lcd[50];
	for( ;; )
	{

//		UB_Uart_SendString(COM1, "AT+CWJAP=\"BOLT!SUPER 4G-5E43\",\"bismillah\"", CRLF);
		UB_Uart_SendString(COM1, "AT+CWJAP=\"telemonitoring\",\"bismillah\"", CRLF);
//		UB_Uart_SendString(COM1, "AT+CWJAP=\"EC2\",\"ju4r4ju4r4\"", CRLF);
		i = waitForRespond(10000000,false);
		if (DEBUG)
		{
			sprintf(lcd,"Attempt: %d | Error: %d",j,i);
			UB_Font_DrawString(30,2,lcd,&Arial_7x10,RGB_COL_GREEN,RGB_COL_BLACK);
		}
		if (i == 0) return true;
		else
		{
			j++;
			if (j==3) return false;
		}
	}
}

bool esp8266_multi()
{
	int i,j=0;
	for( ;; )
	{
		UB_Uart_SendString(COM1, "AT+CIPMUX=1", CRLF);
		i = waitForRespond(100000000,false);
		if (i == 0) return true;
		else
		{
			j++;
			if (j==3) return false;
		}
	}
}

bool esp8266_handshake()
{
	int i;
	uint32_t j=0;


	setOk(false);
	setMessage(-1);

	UART_RX[0].rx_buffer[0]=RX_END_CHR;
	UART_RX[0].wr_ptr=0;
	UART_RX[0].rd_ptr=0;
	UART_RX[0].status=RX_EMPTY;

//	UB_Uart_SendString(COM1, "AT+CIPSTART=\"TCP\",\"192.168.193.1\",8888", CRLF);
	UB_Uart_SendString(COM1, "AT+CIPSTART=\"TCP\",\"192.168.1.101\",8888", CRLF);
//	UB_Uart_SendString(COM1, "AT+CIPSTART=\"TCP\",\"10.5.79.50\",8888", CRLF);

	while(!getOk() && j++ < 5555555);

	if (j >= 5555555) return false;
	if (getMessage()==0) return true;
	else return false;


//	for( ;; )
//	{
//		UB_Uart_SendString(COM1, "AT+CIPSTART=4,\"TCP\",\"192.168.1.250\",80", CRLF);
//		i = waitForRespond(10000000,false);
//		if (i == 0) return true;
//		else
//		{
//			j++;
//			if (j==3) return false;
//		}
//	}
}

void esp8266_sendOp(char* data)
{
	uint32_t j = 0;
	int	length;
	char lastCommand[50];

	length = strlen(data);
	sprintf(lastCommand,"AT+CIPSEND=%d",length);

	setOk(false);
	setMessage(-1);

	UART_RX[0].rx_buffer[0]=RX_END_CHR;
	UART_RX[0].wr_ptr=0;
	UART_RX[0].rd_ptr=0;
	UART_RX[0].status=RX_EMPTY;

	UB_Uart_SendString(COM1,lastCommand, CRLF);

	while(!getOk() && j++ < 5555555);

	if (j >= 5555555) return false;

	if (getMessage()==0) return true;
	else return false;
}

bool esp8266_sendString(char* data)
{
	uint32_t j=0;
	int i;
	bool out = false, done = false;

//	char lastCommand[50];

//	length = strlen(data);
//	sprintf(lastCommand,"AT+CIPSEND=4,%d",length);

//	UB_Uart_SendString(COM1,lastCommand, CRLF);
//	waitForRespond(10000000,false);

//	esp8266_delay(1800000000);

	setOk(false);
	setMessage(-1);

	UART_RX[0].rx_buffer[0]=RX_END_CHR;
	UART_RX[0].wr_ptr=0;
	UART_RX[0].rd_ptr=0;
	UART_RX[0].status=RX_EMPTY;


	UB_Uart_SendString(COM1,data, NONE);

	while(!getOk() && j++ < 5555555);

	if (j >= 5555555) return false;

	if (getMessage()==0) return true;
	else return false;


//	for(i=0;i<10;i++)
//	{
//		j=0;
//		if (out) break;
//		do
//		{
//			j++;
//			if (out) break;
//
//			check=UB_Uart_ReceiveString(COM1,rx_buf);
//			if (check==RX_READY) {
//				done = true;
//			}
//			if (done)
//			{
//				done = false;
//				if ((rx_buf[0] == 'S') && (rx_buf[1] == 'E') && (rx_buf[2] == 'N') && (rx_buf[3] == 'D') && (rx_buf[5] == 'O') && (rx_buf[6] == 'K'))
//				{
//					out = true;
//					return true;
//				}
//				else if ((rx_buf[0] == 'b') && (rx_buf[1] == 'u') && (rx_buf[2] == 's') && (rx_buf[3] == 'y'))
//				{
//					out = true;
//					return false;
//				}
//			}
//			if (j == 10000000) out=true;
//		}
//		while(check!=RX_READY);
//
//	}
//	return false;
}

bool esp8266_close()
{
	int i,j=0;
	for( ;; )
	{
		UB_Uart_SendString(COM1, "AT+CIPCLOSE", CRLF);
		i = waitForRespond(100000000,false);
		if (i == 0) return true;
		else
		{
			j++;
			if (j==3) return false;
		}
	}
}
