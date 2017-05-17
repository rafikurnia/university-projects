#include "main.h"

int main(void)
{
	SystemInit();
	HardwareInit();
	QueueInit();
	TaskInit();

	for( ;; );
}

void HardwareInit()
{
	int i,j;

	UB_LCD_Init();
	UB_LCD_LayerInit_Fullscreen();
	UB_LCD_SetLayer_1();
	UB_LCD_FillLayer(RGB_COL_BLACK);


	if(UB_Touch_Init() == ERROR)
	{
		UB_LCD_SetLayer_2();
		UB_LCD_FillLayer(RGB_COL_RED);
		UB_Font_DrawString(210,10,"Touchscreen Error!",&Arial_11x18,RGB_COL_WHITE,RGB_COL_RED);
		UB_Font_DrawString(185,10,"Please Reset Power Source",&Arial_11x18,RGB_COL_WHITE,RGB_COL_RED);
		for( ;; );
	}

	Step_Init();

	esp = esp8266_init();

	UB_LCD_SetLayer_2();
	UB_LCD_FillLayer(RGB_COL_BLACK);
	for(i=0;i<320;i++)
	{
		UB_LCD_SetCursor2Draw(11,i);
		UB_LCD_DrawPixel(RGB_COL_GREEN);
		UB_LCD_SetCursor2Draw(208,i);
		UB_LCD_DrawPixel(RGB_COL_GREEN);
		UB_LCD_SetCursor2Draw(193,i);
		UB_LCD_DrawPixel(RGB_COL_GREEN);
		UB_LCD_SetCursor2Draw(178,i);
		UB_LCD_DrawPixel(RGB_COL_GREEN);
		UB_LCD_SetCursor2Draw(163,i);
		UB_LCD_DrawPixel(RGB_COL_GREEN);

		for(j=239;j>=224;j--)
		{
			UB_LCD_SetCursor2Draw(j,i);
			UB_LCD_DrawPixel(RGB_COL_GREEN);
		}
	}
	UB_Font_DrawString(0,0," Rafi Kurnia Putra - 1206261850 - Telemedical ",&Arial_7x10,RGB_COL_BLACK,RGB_COL_GREEN);

	if (esp)
	{
		UB_Font_DrawString(15,0," Connected to \"BOLT!SUPER 4G-5E43\"",&Arial_7x10,RGB_COL_GREEN,RGB_COL_BLACK);
	}
	else
	{
		UB_Font_DrawString(30,0," Disconnected. Offline mode is activated",&Arial_7x10,RGB_COL_GREEN,RGB_COL_BLACK);
		UB_Font_DrawString(15,0," Please check connection and restart system",&Arial_7x10,RGB_COL_GREEN,RGB_COL_BLACK);
	}

	TM_CPULOAD_Init(&CPU_LOAD);
	TM_SERVO_Init(&Servo1, TIM2, TM_PWM_Channel_2, TM_PWM_PinsPack_2);


	UB_ADC1_DMA_Init();
	UB_Led_Init();
	UB_Button_Init();


}

void QueueInit()
{
	queueStepper	= xQueueCreate(1, sizeof(int));
	queueServo 		= xQueueCreate(1, sizeof(int));
	queueSound 		= xQueueCreate(1, sizeof(int));
	queueLed 		= xQueueCreate(1, sizeof(int));

	queueECG		= xQueueCreate(1, sizeof(int));
	queuePulse		= xQueueCreate(1, sizeof(int));
	queueBreath		= xQueueCreate(1, sizeof(int));
	queueTemp		= xQueueCreate(1, sizeof(int));
	queueBlood		= xQueueCreate(1, sizeof(int));

	queueRawEcg		= xQueueCreate(1, sizeof(uint16_t));
	queueRawPulse	= xQueueCreate(1, sizeof(uint16_t));
	queueRawBreath	= xQueueCreate(1, sizeof(uint16_t));

	queueCPU		= xQueueCreate(1, sizeof(float));


	if ((queueStepper == 0) || (queueServo == 0) || (queueSound == 0) || (queueLed == 0) || (queueECG == 0) || (queuePulse == 0) || (queueBreath == 0) || (queueTemp == 0) || (queueBlood == 0) || (queueRawEcg == 0) || (queueRawPulse == 0) || (queueRawBreath == 0) || (queueCPU == 0))
	{
		UB_LCD_SetLayer_2();
		UB_LCD_FillLayer(RGB_COL_YELLOW);
		UB_Font_DrawString(210,10,"Queueu Error!",&Arial_11x18,RGB_COL_WHITE,RGB_COL_YELLOW);
		UB_Font_DrawString(185,10,"Please Reset Microcontroller",&Arial_11x18,RGB_COL_WHITE,RGB_COL_YELLOW);
		for( ;; );
	}
}

void TaskInit()
{
	xTaskCreate(getButton, (signed char *) "Button", configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY + 2UL, &taskHandler[0]);
	xTaskCreate(getCPULoad, (signed char *) "CPU", configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY + 2UL, &taskHandler[1]);
	xTaskCreate(getHeartBeat, (signed char *) "ECG", configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY + 2UL, &taskHandler[2]);
	xTaskCreate(getPulse, (signed char *) "Pulse", configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY + 2UL, &taskHandler[3]);
	xTaskCreate(getTick, (signed char *) "Tick", configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY + 2UL, &taskHandler[4]);
	xTaskCreate(getTemperature, (signed char *) "Temperature", configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY + 2UL, &taskHandler[5]);
	xTaskCreate(getBreath, (signed char *) "Breath", configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY + 2UL, &taskHandler[6]);
	xTaskCreate(getPressure, (signed char *) "Pressure", configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY + 2UL, &taskHandler[7]);
	xTaskCreate(getSound, (signed char *) "Sound", configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY + 2UL, &taskHandler[8]);
	xTaskCreate(getTouch, (signed char *) "Touch", configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY + 2UL, &taskHandler[9]);
	xTaskCreate(setServo, (signed char *) "Servo", configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY + 2UL, &taskHandler[10]);
	xTaskCreate(setStepper, (signed char *) "Stepper", configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY + 2UL, &taskHandler[11]);
	xTaskCreate(setLed, (signed char *) "Led", configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY + 2UL, &taskHandler[12]);
	xTaskCreate(updateData, (signed char *) "Data", configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY + 3UL, &taskHandler[13]);

	vTaskStartScheduler();
}

void getButton(void *pvParameters)
{
	int message;
	int sent = 0;
	int16_t x,y,z;
	char buf[50];

	for( ;; )
	{
		if (UB_Button_Read(BTN_USER)==BTN_PRESSED)
		{
			if (sent==0)
			{
				sent = 1;
				message = 1;
				xQueueReset(queueStepper);
				xQueueSendToBack(queueStepper, &message, portMAX_DELAY); /* Send Message */
				xQueueReset(queueLed);
				xQueueSendToBack(queueLed, &message, portMAX_DELAY); /* Send Message */
				if (servoStatus)
				{
					xQueueReset(queueServo);
					xQueueSendToBack(queueServo, &message, portMAX_DELAY); /* Send Message */
					servoStatus = false;
				}
			}
			xQueueReset(queueStepper);
			xQueueSendToBack(queueStepper, &message, portMAX_DELAY); /* Send Message */

		}
		else
		{
			if (sent == 1)
			{
				sent = 0;
				message = 0;
				xQueueReset(queueLed);
				xQueueSendToBack(queueLed, &message, portMAX_DELAY); /* Send Message */
			}
		}
	}
}

void getCPULoad(void *pvParameters)
{
	char lcd[30];
	UB_Font_DrawString(225,2,"CPU: 00.000%  ",&Arial_7x10,RGB_COL_BLACK,RGB_COL_GREEN);
	float cpuUtil=0;
	for( ;; )
	{
		if (CPU_LOAD.Updated)
		{
			cpuUtil = CPU_LOAD.Load;
			xQueueReset(queueCPU);
			xQueueSendToBack(queueCPU, &cpuUtil, portMAX_DELAY);
			UB_String_FloatToDezStr(cpuUtil);
			sprintf(lcd," CPU: %s%%",STRING_BUF);
			UB_Font_DrawString(225,0,lcd,&Arial_7x10,RGB_COL_BLACK,RGB_COL_GREEN);
		}
		TM_CPULOAD_GoToSleepMode(&CPU_LOAD, TM_LOWPOWERMODE_SleepUntilInterrupt);
	}
}

void getHeartBeat(void *pvParameters)
{
	uint16_t adcValue;
	char lcd[30];
	unsigned long lastTick=0,newTick=0;
	int rate=0;

	lastTick = xTaskGetTickCount();
	for( ;; )
	{
		if((UB_Button_Read(LOM) == BTN_RELEASED) || (UB_Button_Read(LOP) == BTN_RELEASED))
		{
			rate = 0;
			adcValue = 0;

			UB_Font_DrawString(180,0," ECG  = data not available                  ",&Arial_7x10,RGB_COL_GREEN,RGB_COL_BLACK);
			xQueueReset(queueECG);
			xQueueSendToBack(queueECG, &rate, portMAX_DELAY);
			xQueueReset(queueRawEcg);
			xQueueSendToBack(queueRawEcg, &adcValue, portMAX_DELAY);
		}
		else
		{
			adcValue = UB_ADC1_DMA_Read(ADC_PA3);
			if (adcValue > 3000)
			{
				newTick = xTaskGetTickCount();
				if (newTick-lastTick) rate = 60000 / (newTick-lastTick);
				lastTick = newTick;
			}
			if (rate < 60)
			{
				sprintf(lcd," ECG  : %4d | Rate: %3d bpm  | Bradycardia    ",adcValue,rate);
			}
			else if ((rate >= 60) && (rate <= 100))
			{
				sprintf(lcd," ECG  : %4d | Rate: %3d bpm  | Normal         ",adcValue,rate);
			}
			else if ((rate > 100) && (rate <= 150))
			{
				sprintf(lcd," ECG  : %4d | Rate: %3d bpm  | Tachycardia    ",adcValue,rate);
			}
			else if (rate > 150)
			{
				sprintf(lcd," ECG  : %4d | Rate: %3d bpm  | SVT            ",adcValue,rate);
			}
			UB_Font_DrawString(180,0,lcd,&Arial_7x10,RGB_COL_GREEN,RGB_COL_BLACK);
			xQueueReset(queueECG);
			xQueueSendToBack(queueECG, &rate, portMAX_DELAY);
			xQueueReset(queueRawEcg);
			xQueueSendToBack(queueRawEcg, &adcValue, portMAX_DELAY);
			//vTaskDelay(500/portTICK_RATE_MS);
		}
	}
}

void getPulse(void *pvParameters)
{
	uint16_t adcValue;
	char lcd[30];
	unsigned long lastTick=0,newTick=0;
	int rate=0;

	lastTick = xTaskGetTickCount();
	for( ;; )
	{
		adcValue = UB_ADC1_DMA_Read(ADC_PA5);
		if (adcValue > 3000)
		{
			newTick = xTaskGetTickCount();
			if (newTick-lastTick) rate = 60000 / (newTick-lastTick);
			lastTick = newTick;
		}
		if (rate < 60)
		{
			sprintf(lcd," Pulse: %4d | Rate: %3d bpm  | Bradycardia    ",adcValue,rate);
		}
		else if ((rate >= 60) && (rate <= 100))
		{
			sprintf(lcd," Pulse: %4d | Rate: %3d bpm  | Normal         ",adcValue,rate);
		}
		else if ((rate > 100) && (rate <= 150))
		{
			sprintf(lcd," Pulse: %4d | Rate: %3d bpm  | Tachycardia    ",adcValue,rate);
		}
		else if (rate > 150)
		{
			sprintf(lcd," Pulse: %4d | Rate: %3d bpm  | SVT            ",adcValue,rate);
		}
		UB_Font_DrawString(195,0,lcd,&Arial_7x10,RGB_COL_GREEN,RGB_COL_BLACK);
		xQueueReset(queuePulse);
		xQueueSendToBack(queuePulse, &rate, portMAX_DELAY); /* Send Message */
		xQueueReset(queueRawPulse);
		xQueueSend(queueRawPulse, &adcValue, portMAX_DELAY); /* Send Message */
		//vTaskDelay(500/portTICK_RATE_MS);
	}
}

void getTick(void *pvParameters)
{
	char lcd[30];
	for( ;; )
	{
		sprintf(lcd,"Uptime : %03ds",xTaskGetTickCount()/1000);
		UB_Font_DrawString(225,225,lcd,&Arial_7x10,RGB_COL_BLACK,RGB_COL_GREEN);
		//vTaskDelay(1000/portTICK_RATE_MS);

	}
}

void getTemperature(void *pvParameters)
{
	uint16_t adcValue;
	char lcd[30];
	int temp;

	for( ;; )
	{
		adcValue = UB_ADC1_DMA_Read(ADC_PA6);
		temp = adcValue * 330 / 4095;
		if (temp < 35)
		{
			sprintf(lcd," Temp : %4d | Celc: %3d C    | Hypotermia     ",adcValue,temp);
		}
		else if ((temp >= 35) && (temp <= 37))
		{
			sprintf(lcd," Temp : %4d | Celc: %3d C    | Normal         ",adcValue,temp);
		}
		else if (temp > 37)
		{
			sprintf(lcd," Temp : %4d | Celc: %3d C    | Hypertermia    ",adcValue,temp);
		}
		UB_Font_DrawString(210,0,lcd,&Arial_7x10,RGB_COL_GREEN,RGB_COL_BLACK);
		xQueueReset(queueTemp);
		xQueueSendToBack(queueTemp, &temp, portMAX_DELAY); /* Send Message */
		//vTaskDelay(500/portTICK_RATE_MS);
	}
}

void getBreath(void *pvParameters)
{
	uint16_t adcValue;
	char lcd[30];
	unsigned long lastTick=0,newTick=0;
	int rate=0;

	lastTick = xTaskGetTickCount();
	for( ;; )
	{
		adcValue = UB_ADC1_DMA_Read(ADC_PA7);
		if (adcValue > 1500)
		{
			newTick = xTaskGetTickCount();
			if (newTick-lastTick) rate = 60000 / (newTick-lastTick);
			lastTick = newTick;
		}

		if (rate < 30)
		{
			sprintf(lcd," Respi: %4d | Rate: %3d bpm  | Bradypnea      ",adcValue,rate);
		}
		else if ((rate >= 30) && (rate <= 60))
		{
			sprintf(lcd," Respi: %4d | Rate: %3d bpm  | Normal         ",adcValue,rate);
		}
		else if (rate > 60)
		{
			sprintf(lcd," Respi: %4d | Rate: %3d bpm  | Tachypnea      ",adcValue,rate);
		}
		UB_Font_DrawString(165,0,lcd,&Arial_7x10,RGB_COL_GREEN,RGB_COL_BLACK);
		xQueueReset(queueBreath);
		xQueueSendToBack(queueBreath, &rate, portMAX_DELAY); /* Send Message */
		xQueueReset(queueRawBreath);
		xQueueSendToBack(queueRawBreath, &adcValue, portMAX_DELAY); /* Send Message */
		//vTaskDelay(500/portTICK_RATE_MS);
	}
}

void getPressure(void *pvParameters)
{
	uint16_t adcValue;
	char lcd[30];
	float voltage;
	int pressure;

	for( ;; )
	{
		adcValue = UB_ADC1_DMA_Read(ADC_PB0);
		voltage = adcValue * 3.3 / 4095;
		pressure = ((100 * voltage) - 20) / 9 * 7.500617;
		if (pressure < 35)
		{
			sprintf(lcd," Blood: %4d | Pres: %3d mmHg | Hypotermia     ",adcValue,pressure);
		}
		else if ((pressure >= 35) && (pressure <= 37))
		{
			sprintf(lcd," Blood: %4d | Pres: %3d mmHg | Normal         ",adcValue,pressure);
		}
		else if (pressure > 37)
		{
			sprintf(lcd," Blood: %4d | Pres: %3d mmHg | Hypertermia    ",adcValue,pressure);
		}
		UB_Font_DrawString(150,0,lcd,&Arial_7x10,RGB_COL_GREEN,RGB_COL_BLACK);
		xQueueReset(queueBlood);
		xQueueSendToBack(queueBlood, &pressure, portMAX_DELAY); /* Send Message */
		//vTaskDelay(500/portTICK_RATE_MS);
	}
}

void getSound(void *pvParameters)
{
	uint16_t adcValueL, adcValueR;
	char lcd[30];

	for( ;; )
	{
		adcValueL = UB_ADC1_DMA_Read(ADC_PB1);
		adcValueR = UB_ADC1_DMA_Read(ADC_PC1);
		if ((adcValueL > 512) || (adcValueR > 512))
		{
			if ((adcValueL > 512) && (adcValueR > 512))
			{
				sprintf(lcd," S1   : %4d | S2  : %4d     | Both Detect    ",adcValueL,adcValueR);
			}
			else if (adcValueL > 512)
			{
				sprintf(lcd," S1   : %4d | S2  : %4d     | L Detects      ",adcValueL,adcValueR);
			}
			else if (adcValueR > 512)
			{
				sprintf(lcd," S1   : %4d | S2  : %4d     | R Detects      ",adcValueL,adcValueR);
			}
		}
		else
		{
			sprintf(lcd," S1   = %4d | S2  : %4d     | 0 Detect    ",adcValueL,adcValueR);
		}
		UB_Font_DrawString(135,0,lcd,&Arial_7x10,RGB_COL_GREEN,RGB_COL_BLACK);
		//vTaskDelay(100/portTICK_RATE_MS);

	}
}

void getTouch(void *pvParameters)
{
	int message;
	int sent = 0;
	char lcd[30];

	for( ;; )
	{
		UB_Touch_Read();
		if(Touch_Data.status==TOUCH_PRESSED)
		{
			sprintf(lcd,"x: %03d  y: %03d",Touch_Data.yp,Touch_Data.xp);
			UB_Font_DrawString(225,107,lcd,&Arial_7x10,RGB_COL_BLACK,RGB_COL_GREEN);
			if (sent==0)
			{
				sent = 1;
				message = 2;
				xQueueReset(queueLed);
				xQueueSendToBack(queueLed, &message, portMAX_DELAY); /* Send Message */
				if (!servoStatus)
				{
					xQueueReset(queueServo);
					xQueueSend(queueServo, &message, portMAX_DELAY); /* Send Message */
					servoStatus = true;
				}
			}
			xQueueReset(queueStepper);
			xQueueSend(queueStepper, &message, portMAX_DELAY); /* Send Message */
		}
		else
		{
			UB_Font_DrawString(225,107,"   untouched   ",&Arial_7x10,RGB_COL_BLACK,RGB_COL_GREEN);
			if (sent == 1)
			{
				sent = 0;
				message = 3;
				xQueueReset(queueLed);
				xQueueSendToBack(queueLed, &message, portMAX_DELAY); /* Send Message */
			}
		}
	}
}

void setServo(void *pvParameters)
{
	int message;
	TM_SERVO_SetDegrees(&Servo1, 180);
	UB_Font_DrawString(120,0," Servo:  Off |",&Arial_7x10,RGB_COL_GREEN,RGB_COL_BLACK);

	for( ;; )
	{
		if(xQueueReceive(queueServo, &message, portMAX_DELAY))
		{
			while(message == 2)
			{
				UB_Font_DrawString(120,0," Servo:   On |",&Arial_7x10,RGB_COL_GREEN,RGB_COL_BLACK);
				TM_SERVO_SetDegrees(&Servo1, 0);
				xQueueReceive(queueServo,&message,250);
				TM_SERVO_SetDegrees(&Servo1, 150);
				xQueueReceive(queueServo,&message,250);
			}
		}
		if (message == 1)
		{
			UB_Font_DrawString(120,0," Servo:  Off |",&Arial_7x10,RGB_COL_GREEN,RGB_COL_BLACK);
			message = 0;
			TM_SERVO_SetDegrees(&Servo1, 180);
		}
	}
}

void setStepper(void *pvParameters)
{
	int message;

	for( ;; )
	{
		if(xQueueReceive(queueStepper, &message, 100))
		{
			if (message == 1)
			{
				UB_Font_DrawString(120,107,"Step:  Left",&Arial_7x10,RGB_COL_GREEN,RGB_COL_BLACK);
				//Direction(KIRI);
				//Stepper(1);
				stepKiri();
			}
			else if (message == 2)
			{
				UB_Font_DrawString(120,107,"Step: Right",&Arial_7x10,RGB_COL_GREEN,RGB_COL_BLACK);
				//Direction(KANAN);
				//Stepper(1);
				stepKanan();
			}
		}
		else
		{
			UB_Font_DrawString(120,107,"Step:   Off",&Arial_7x10,RGB_COL_GREEN,RGB_COL_BLACK);
			stepStop();
		}
	}
}

void setLed(void *pvParameters)
{
	int message;

	for( ;; )
	{
		if(xQueuePeek(queueLed, &message, portMAX_DELAY))
		{
			if 		(message == 0) UB_Led_Off(LED_RED);
			else if (message == 1) UB_Led_On(LED_RED);
			//			else if	(message == 2) UB_Led_On(LED_GREEN);
			//			else if (message == 3) UB_Led_Off(LED_GREEN);
		}
	}
}

void updateData(void *pvParameters)
{
	int i=0,j,k=0,l=0,attempt=0;;
	int ecg,pulse,breath,temp,blood;
	uint16_t rawEcg, rawPulse, rawBreath;
	float cpuUtil;
	char buf[25];

	portTickType xLastWakeTime;
	const portTickType xFrequency = 72;

	if (!esp)
	{
		vTaskSuspend(NULL);
	}


	// Initialise the xLastWakeTime variable with the current time.
	xLastWakeTime = xTaskGetTickCount();



	for( ;; )
	{

		UB_Font_DrawString(45,0," START CONNECTION            :",&Arial_7x10,RGB_COL_GREEN,RGB_COL_BLACK);
		a:
		if (esp8266_handshake())
		{
			k=0;
			UB_Font_DrawString(45,220,"SUCCESSFUL",&Arial_7x10,RGB_COL_GREEN,RGB_COL_BLACK);
			attempt = 0;
		}
		else
		{
			attempt++;
			if (attempt == 3)
			{
				UB_Font_DrawString(45,220,"FAILED    ",&Arial_7x10,RGB_COL_GREEN,RGB_COL_BLACK);
				UB_Font_DrawString(60,0,"                                           ",&Arial_7x10,RGB_COL_GREEN,RGB_COL_BLACK);
				UB_Font_DrawString(45,0,"                                           ",&Arial_7x10,RGB_COL_GREEN,RGB_COL_BLACK);
				UB_Font_DrawString(30,0," Disconnected. Offline mode is activated",&Arial_7x10,RGB_COL_GREEN,RGB_COL_BLACK);
				UB_Font_DrawString(15,0," Please check connection and restart system",&Arial_7x10,RGB_COL_GREEN,RGB_COL_BLACK);
				vTaskSuspend(NULL);
			}
			else
			{
				goto a;
			}
		}

		xQueueReceive(queueECG, &ecg, portMAX_DELAY);
		xQueueReceive(queuePulse, &pulse, portMAX_DELAY);
		xQueueReceive(queueBreath, &breath, portMAX_DELAY);
		xQueueReceive(queueTemp, &temp, portMAX_DELAY);
		xQueueReceive(queueBlood, &blood, portMAX_DELAY);

		xQueueReceive(queueRawEcg, &rawEcg, portMAX_DELAY);
		xQueueReceive(queueRawPulse, &rawPulse, portMAX_DELAY);
		xQueueReceive(queueRawBreath, &rawBreath, portMAX_DELAY);

		xQueuePeek(queueCPU, &cpuUtil, portMAX_DELAY);


		l++;

		UB_String_FloatToDezStr(cpuUtil);

		sprintf(buf,"%d/%d/%d/%d/%d/%d/%d/%d/%d/%s",ecg,pulse,breath,temp,blood,rawEcg,rawPulse,rawBreath,l,STRING_BUF);

		vTaskDelayUntil( &xLastWakeTime, xFrequency );

		for (j=0;j<9;j++)
		{
			xQueueReceive(queueECG, &ecg, portMAX_DELAY);
			xQueueReceive(queuePulse, &pulse, portMAX_DELAY);
			xQueueReceive(queueBreath, &breath, portMAX_DELAY);
			xQueueReceive(queueTemp, &temp, portMAX_DELAY);
			xQueueReceive(queueBlood, &blood, portMAX_DELAY);

			xQueueReceive(queueRawEcg, &rawEcg, portMAX_DELAY);
			xQueueReceive(queueRawPulse, &rawPulse, portMAX_DELAY);
			xQueueReceive(queueRawBreath, &rawBreath, portMAX_DELAY);

			xQueuePeek(queueCPU, &cpuUtil, portMAX_DELAY);

			l++;

			UB_String_FloatToDezStr(cpuUtil);

			sprintf(buf + strlen(buf),"|%d/%d/%d/%d/%d/%d/%d/%d/%d/%s",ecg,pulse,breath,temp,blood,rawEcg,rawPulse,rawBreath,l,STRING_BUF);

			if (j!=8) vTaskDelayUntil( &xLastWakeTime, xFrequency );
		}

		UB_Font_DrawString(30,0," SEND DATA TO SERVER         :",&Arial_7x10,RGB_COL_GREEN,RGB_COL_BLACK);

		esp8266_sendOp(buf);

		vTaskDelayUntil( &xLastWakeTime,36);

		b:
		if (esp8266_sendString(buf))
		{
			k=0;
			UB_Font_DrawString(30,220,"SUCCESSFUL",&Arial_7x10,RGB_COL_GREEN,RGB_COL_BLACK);
			attempt=0;
		}
		else
		{
			attempt++;
			if (attempt == 3)
			{
				UB_Font_DrawString(45,220,"FAILED    ",&Arial_7x10,RGB_COL_GREEN,RGB_COL_BLACK);
				UB_Font_DrawString(60,0,"                                           ",&Arial_7x10,RGB_COL_GREEN,RGB_COL_BLACK);
				UB_Font_DrawString(45,0,"                                           ",&Arial_7x10,RGB_COL_GREEN,RGB_COL_BLACK);
				UB_Font_DrawString(30,0," Disconnected. Offline mode is activated",&Arial_7x10,RGB_COL_GREEN,RGB_COL_BLACK);
				UB_Font_DrawString(15,0," Please check connection and restart system",&Arial_7x10,RGB_COL_GREEN,RGB_COL_BLACK);
				vTaskSuspend(NULL);
			}
			else
			{
				goto b;
			}
		}


		esp8266_close();

		vTaskDelayUntil( &xLastWakeTime,36);

		UB_Font_DrawString(30,0,"                                          ",&Arial_7x10,RGB_COL_BLACK,RGB_COL_BLACK);
		UB_Font_DrawString(45,0,"                                          ",&Arial_7x10,RGB_COL_BLACK,RGB_COL_BLACK);
		UB_Font_DrawString(60,0,"                                          ",&Arial_7x10,RGB_COL_BLACK,RGB_COL_BLACK);

	}
}
