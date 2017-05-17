
#include <stdio.h>
#include "stm32f4xx.h"
#include "main.h"
#include "defines.h"
#include "stm32_ub_lcd_ili9341.h"
#include "stm32_ub_font.h"
#include "stm32_ub_touch_stmpe811.h"
#include "stm32_ub_adc1_dma.h"
#include "stm32_ub_freertos.h"
#include "stm32_ub_led.h"
#include "stm32_ub_button.h"
#include "tm_stm32f4_cpu_load.h"
#include "tm_stm32f4_servo.h"
#include "tm_stm32f4_delay.h"
#include "rf_stepstick.h"


xQueueHandle pbq;

void BlinkyTask( void *pvParameters );
void DetectButton( void *pvParameters );
void SetLed( void *pvParameters );
void GUI( void *pvParameters );
void MaininServo(void *pvParameters);
void GerakinStepper(void *pvParameters);

void hw_init(void)
{
	UB_Led_Init();

	Step_Init();
	UB_Button_Init();
	//TM_DELAY_Init();


	UB_LCD_Init();
	UB_LCD_LayerInit_Fullscreen();
	UB_LCD_SetLayer_1();
	UB_LCD_FillLayer(RGB_COL_WHITE);
	UB_LCD_SetLayer_2();
	UB_LCD_FillLayer(RGB_COL_GREEN);

	//UB_Font_DrawString(10,10,"Deteksi Touchscreen",&Arial_11x18,RGB_COL_BLACK,RGB_COL_GREEN);
	UB_Font_DrawString(10,30,"pake RTOS Loh ini :p",&Arial_11x18,RGB_COL_BLACK,RGB_COL_GREEN);

	if(UB_Touch_Init()!=SUCCESS) {
		UB_Font_DrawString(10,70,"Error",&Arial_11x18,RGB_COL_WHITE,RGB_COL_RED);
		while(1);
	}

	UB_ADC1_DMA_Init();


}


int main(void)
{

	SystemInit();

	hw_init();

	pbq = xQueueCreate(10, sizeof(int));
	if (pbq == 0) {
		while(1); /* fatal error */
	}

	xTaskCreate( BlinkyTask, ( signed char * ) "Blinky", configMINIMAL_STACK_SIZE, NULL, 2, NULL );
	xTaskCreate( DetectButton, ( signed char * ) "Detect", configMINIMAL_STACK_SIZE, NULL, 2, NULL );
	xTaskCreate( SetLed, ( signed char * ) "Set", configMINIMAL_STACK_SIZE, NULL, 2, NULL );
	xTaskCreate( GUI, ( signed char * ) "Gui", configMINIMAL_STACK_SIZE, NULL, 2, NULL );
	xTaskCreate( MaininServo, ( signed char * ) "Servo", configMINIMAL_STACK_SIZE, NULL, 2, NULL );
	xTaskCreate( GerakinStepper, ( signed char * ) "Stepper", configMINIMAL_STACK_SIZE, NULL,2, NULL );

	vTaskStartScheduler();

	while(1)
	{

	}
}


void BlinkyTask( void *pvParameters )
{
	//UB_Led_On(LED_GREEN);
	while(1)
	{
		UB_Led_Toggle(LED_GREEN);
		vTaskDelay(50/portTICK_RATE_MS);
	}
}

void DetectButton( void *pvParameters )
{
		int sig = 1;
		int sent = 0;

	while (1) {

		/* Detect Button Press */
//		if(UB_Button_OnClick(BTN_USER)==true) {
//			if (sent==0)
//			{
//				sent = 1;
//				sig = 1;
//				xQueueSendToBack(pbq, &sig, portMAX_DELAY); /* Send Message */
//			}
//		}
//		else {
//			if (sent == 1) {
//				sent = 0;
//				sig = 0;
//				xQueueSendToBack(pbq, &sig, portMAX_DELAY); /* Send Message */
//			}
//		}

		if(UB_Button_Read(BTN_USER)==BTN_PRESSED) {
		      UB_Led_On(LED_RED);  // rote LED einschalten
		    }
		    else {
		      UB_Led_Off(LED_RED); // rote LED ausschalten
		    }

		    // Test auf OnClick vom Button
	}
}

void SetLed(void *pvParameters) {

	int sig;

	while (1) {
		if(xQueueReceive(pbq, &sig, portMAX_DELAY)) {
			if (sig == 1) GPIO_SetBits(GPIOG,GPIO_Pin_14);
			else if (sig == 0) GPIO_ResetBits(GPIOG,GPIO_Pin_14);
		}
	}
}

void GUI(void *pvParameters) {

	uint16_t xp,yp;
	char buf[30];

	int sent = 1;

	uint16_t adc_wert;

	TM_CPULOAD_t CPU_LOAD;

	TM_CPULOAD_Init(&CPU_LOAD);

	while(1)
	{

		adc_wert=UB_ADC1_DMA_Read(ADC_PA3);
		sprintf(buf,"PA3=%4d",adc_wert);
		UB_Font_DrawString(10,230,buf,&Arial_11x18,RGB_COL_BLACK,RGB_COL_GREEN);

		adc_wert=UB_ADC1_DMA_Read(ADC_PA5);
		sprintf(buf,"PA5=%4d",adc_wert);
		UB_Font_DrawString(120,230,buf,&Arial_11x18,RGB_COL_BLACK,RGB_COL_GREEN);

		adc_wert=UB_ADC1_DMA_Read(ADC_PA6);
		sprintf(buf,"PA6=%4d",adc_wert);
		UB_Font_DrawString(10,250,buf,&Arial_11x18,RGB_COL_BLACK,RGB_COL_GREEN);

		adc_wert=UB_ADC1_DMA_Read(ADC_PA7);
		sprintf(buf,"PA7=%4d",adc_wert);
		UB_Font_DrawString(120,250,buf,&Arial_11x18,RGB_COL_BLACK,RGB_COL_GREEN);

		adc_wert=UB_ADC1_DMA_Read(ADC_PB0);
		sprintf(buf,"PB0=%4d",adc_wert);
		UB_Font_DrawString(10,270,buf,&Arial_11x18,RGB_COL_BLACK,RGB_COL_GREEN);

		adc_wert=UB_ADC1_DMA_Read(ADC_PB1);
		sprintf(buf,"PB1=%4d",adc_wert);
		UB_Font_DrawString(120,270,buf,&Arial_11x18,RGB_COL_BLACK,RGB_COL_GREEN);

		adc_wert=UB_ADC1_DMA_Read(ADC_PC1);
		sprintf(buf,"PC1=%4d",adc_wert);
		UB_Font_DrawString(10,290,buf,&Arial_11x18,RGB_COL_BLACK,RGB_COL_GREEN);

		adc_wert=UB_ADC1_DMA_Read(ADC_PC3);
		sprintf(buf,"PC3=%4d",adc_wert);
		UB_Font_DrawString(120,290,buf,&Arial_11x18,RGB_COL_BLACK,RGB_COL_GREEN);

		if (CPU_LOAD.Updated) {
			sprintf(buf,"W: %u",CPU_LOAD.WCNT);
			UB_Font_DrawString(10,150,buf,&Arial_11x18,RGB_COL_BLACK,RGB_COL_GREEN);
			sprintf(buf,"S: %u",CPU_LOAD.SCNT);
			UB_Font_DrawString(10,170,buf,&Arial_11x18,RGB_COL_BLACK,RGB_COL_GREEN);
			sprintf(buf,"Load: %0.2f",CPU_LOAD.Load);
			UB_Font_DrawString(10,190,buf,&Arial_11x18,RGB_COL_BLACK,RGB_COL_GREEN);
		}

		UB_Touch_Read();
		if(Touch_Data.status==TOUCH_PRESSED) {
			UB_Font_DrawString(10,70,"Dipencet :v             ",&Arial_11x18,RGB_COL_BLACK,RGB_COL_GREEN);
			xp=Touch_Data.xp;
			yp=Touch_Data.yp;

			sprintf(buf,"X=%4d",xp);
			UB_Font_DrawString(10,90,buf,&Arial_11x18,RGB_COL_BLACK,RGB_COL_GREEN);
			sprintf(buf,"Y=%4d",yp);
			UB_Font_DrawString(10,110,buf,&Arial_11x18,RGB_COL_BLACK,RGB_COL_GREEN);

			//			for(i=-5;i<=5;i++){
			//			UB_LCD_SetCursor2Draw(xp+i,yp+i);
			//			UB_LCD_DrawPixel(RGB_COL_RED);}
			//			sent = 1;
			//			sig = 10;
			//			xQueueSendToBack(pbq, &sig, portMAX_DELAY); /* Send Message */

			Set_Hi(Pin_Direction);
			Set_Hi(Pin_Step);
			Set_Hi(Pin_Enable);
		}
		else {
			UB_Font_DrawString(10,70,"Alhamdulillah, bisa!",&Arial_11x18,RGB_COL_BLACK,RGB_COL_GREEN);
			UB_Font_DrawString(10,90,"       ",&Arial_11x18,RGB_COL_BLACK,RGB_COL_GREEN);
			UB_Font_DrawString(10,110,"       ",&Arial_11x18,RGB_COL_BLACK,RGB_COL_GREEN);
			if (sent == 1) {
				//				sent = 0;
				//				sig = 11;
				//				xQueueSendToBack(pbq, &sig, portMAX_DELAY); /* Send Message */
			}
			Set_Lo(Pin_Direction);
			Set_Lo(Pin_Step);
			Set_Lo(Pin_Enable);

		}

		TM_CPULOAD_GoToSleepMode(&CPU_LOAD, TM_LOWPOWERMODE_SleepUntilInterrupt);
	}
}


void MaininServo(void *pvParameters) {
	TM_SERVO_t Servo1;
	TM_SERVO_Init(&Servo1, TIM2, TM_PWM_Channel_2, TM_PWM_PinsPack_2);
	int i;

	while (1) {
		for (i=0;i<=180;i++)
		{
			TM_SERVO_SetDegrees(&Servo1, i);
			vTaskDelay(7/portTICK_RATE_MS);
		}
		for (i=179;i>=1;i--)
		{
			TM_SERVO_SetDegrees(&Servo1, i);
			vTaskDelay(7/portTICK_RATE_MS);
		}

	}

}

void GerakinStepper(void *pvParameters) {


	int sig=0;

	while (1) {
		if(xQueueReceive(pbq, &sig, portMAX_DELAY)) {
			if (sig>=10){
				Stepper(200,KANAN,1);
			}
		}

	}
}
