#ifndef _MAIN_H_
#define _MAIN_H_

#include <stdio.h>
#include <stdbool.h>
#include "defines.h"
#include "rf_stepstick.h"
#include "stm32_ub_lcd_ili9341.h"
#include "stm32_ub_font.h"
#include "stm32_ub_touch_stmpe811.h"
#include "stm32_ub_adc1_dma.h"
#include "stm32_ub_freertos.h"
#include "stm32_ub_led.h"
#include "stm32_ub_button.h"
#include "stm32_ub_uart.h"
#include "stm32_ub_string.h"
#include "stm32f4xx.h"
#include "tm_stm32f4_cpu_load.h"
#include "tm_stm32f4_servo.h"
#include "tm_stm32f4_delay.h"

xQueueHandle queueStepper;
xQueueHandle queueServo;
xQueueHandle queueSound;
xQueueHandle queueLed;

xQueueHandle queueECG;
xQueueHandle queuePulse;
xQueueHandle queueBreath;
xQueueHandle queueTemp;
xQueueHandle queueBlood;

xQueueHandle queueRawEcg;
xQueueHandle queueRawPulse;
xQueueHandle queueRawBreath;

xQueueHandle queueCPU;

xTaskHandle taskHandler[15];

TM_SERVO_t Servo1;
TM_CPULOAD_t CPU_LOAD;

bool servoStatus = false;
bool esp = false;
int stepperStatus = 0;

void HardwareInit();
void QueueInit();
void TaskInit();
void getButton(void *pvParameters);
void getCPULoad(void *pvParameters);
void getHeartBeat(void *pvParameters);
void getPulse(void *pvParameters);
void getTick(void *pvParameters);
void getTemperature(void *pvParameters);
void getBreath(void *pvParameters);
void getPressure(void *pvParameters);
void getSound(void *pvParameters);
void getTouch(void *pvParameters);
void setServo(void *pvParameters);
void setStepper(void *pvParameters);
void setLed(void *pvParameters);
void updateData(void *pvParameters);

#endif
