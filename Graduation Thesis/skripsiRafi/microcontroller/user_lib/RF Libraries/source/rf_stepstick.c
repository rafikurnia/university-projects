#include "rf_stepstick.h"

PinConfig PIN_DIGITAL[] = {
		{Pin_Enable ,GPIOG,GPIO_Pin_2 ,RCC_AHB1Periph_GPIOG,Bit_RESET},
		{Pin_Direction ,GPIOG,GPIO_Pin_3 ,RCC_AHB1Periph_GPIOG,Bit_RESET},
		{Pin_Step ,GPIOE,GPIO_Pin_3 ,RCC_AHB1Periph_GPIOE,Bit_RESET},
		{Pin_Relay ,GPIOE,GPIO_Pin_5 ,RCC_AHB1Periph_GPIOE,Bit_SET},
};

void Step_Init(void)
{
	GPIO_InitTypeDef  GPIO_InitStructure;
	PinName dig_pin;

	for(dig_pin=0;dig_pin<JUMLAHPIN;dig_pin++) {
		RCC_AHB1PeriphClockCmd(PIN_DIGITAL[dig_pin].GPIO_CLK, ENABLE);

		GPIO_InitStructure.GPIO_Pin = PIN_DIGITAL[dig_pin].GPIO_PIN;
		GPIO_InitStructure.GPIO_Mode = GPIO_Mode_OUT;
		GPIO_InitStructure.GPIO_OType = GPIO_OType_PP;
		GPIO_InitStructure.GPIO_PuPd = GPIO_PuPd_UP;
		GPIO_InitStructure.GPIO_Speed = GPIO_Speed_100MHz;
		GPIO_Init(PIN_DIGITAL[dig_pin].GPIO_PORT, &GPIO_InitStructure);

		if(PIN_DIGITAL[dig_pin].GPIO_INIT==Bit_RESET) {
			Set_Lo(dig_pin);
		}
		else {
			Set_Hi(dig_pin);
		}
	}
}

void Set_Lo(PinName dig_pin)
{
	PIN_DIGITAL[dig_pin].GPIO_PORT->BSRRH = PIN_DIGITAL[dig_pin].GPIO_PIN;
}

void Set_Hi(PinName dig_pin)
{
	PIN_DIGITAL[dig_pin].GPIO_PORT->BSRRL = PIN_DIGITAL[dig_pin].GPIO_PIN;
} 

void Set_Toggle(PinName dig_pin)
{
	PIN_DIGITAL[dig_pin].GPIO_PORT->ODR ^= PIN_DIGITAL[dig_pin].GPIO_PIN;
}

void Set_Pin(PinName dig_pin,InitAction status)
{
	if(status==Bit_RESET) {
		Set_Lo(dig_pin);
	}
	else {
		Set_Hi(dig_pin);
	}
}

void Direction(int dir)
{
	Set_Lo(Pin_Enable);
	if (dir == KIRI) Set_Hi(Pin_Direction);
	else if (dir == KANAN) Set_Lo(Pin_Direction);
}

void Stepper(int jumlahStep)
{
	int i;

	for (i=0;i<jumlahStep;i++)
	{
		Set_Hi(Pin_Step);
		vTaskDelay(10/portTICK_RATE_MS);
		Set_Lo(Pin_Step);
		vTaskDelay(10/portTICK_RATE_MS);
	}
}

void stepKiri()
{
	Set_Lo(Pin_Direction);
	Set_Hi(Pin_Step);
}

void stepKanan()
{
	Set_Hi(Pin_Direction);
	Set_Lo(Pin_Step);
}

void stepStop()
{
	Set_Lo(Pin_Direction);
	Set_Lo(Pin_Step);
}
