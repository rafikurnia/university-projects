#ifndef __STEP_STICK_H
#define __STEP_STICK_H

#include "stm32f4xx.h"
#include "stm32f4xx_gpio.h"
#include "stm32f4xx_rcc.h"
#include "stm32_ub_freertos.h"
#include <stdbool.h>

#define KANAN 1
#define KIRI 0

typedef enum 
{
	Pin_Enable = 0,
	Pin_Direction = 1,
	Pin_Step = 2,
	Pin_Relay = 3,
}PinName;

#define  JUMLAHPIN   4

typedef struct {
	PinName GPIO_NAME;
	GPIO_TypeDef* GPIO_PORT;
	const uint16_t GPIO_PIN;
	const uint32_t GPIO_CLK;
	InitAction GPIO_INIT;
}PinConfig;

void Step_Init(void);
void Set_Lo(PinName dig_pin);
void Set_Hi(PinName dig_pin);
void Set_Toggle(PinName dig_pin);
void Set_Pin(PinName dig_pin, InitAction value);
void Direction(int dir);
void Stepper(int jumlahStep);

void stepKiri();
void stepKanan();
void stepStop();

#endif
