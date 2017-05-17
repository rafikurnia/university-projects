#include "main.h"
#include "proximity.h"

void proximityInit() {
	GPIO_InitTypeDef GPIO_InitStructure;

	RCC_AHB1PeriphClockCmd(PROX_CLK_LINE, ENABLE);
	GPIO_InitStructure.GPIO_Pin = PROX1 | PROX2 | PROX3 | PROX4 | PROX5;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_100MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IN;
	GPIO_InitStructure.GPIO_OType = GPIO_OType_PP;
	GPIO_InitStructure.GPIO_PuPd = GPIO_PuPd_NOPULL;

	GPIO_Init(PROX_PORT, &GPIO_InitStructure);
}

bool proximityDepan() {
	return !(GPIO_ReadInputDataBit(PROX_PORT, PROX5));
}

bool proximityDepanKanan() {
	return !(GPIO_ReadInputDataBit(PROX_PORT, PROX3));
}

bool proximityDepanKiri() {
	return !(GPIO_ReadInputDataBit(PROX_PORT, PROX2));
}

bool proximitySampingKanan() {
	return !(GPIO_ReadInputDataBit(PROX_PORT, PROX4));
}

bool proximitySampingKiri() {
	return !(GPIO_ReadInputDataBit(PROX_PORT, PROX1));
}

void testProximity() { //masukkan di loop
	static bool var[5];
	static unsigned char lcdchar[12];
	var[0] = proximitySampingKiri();
	var[1] = proximityDepanKiri();
	var[2] = proximityDepan();
	var[3] = proximityDepanKanan();
	var[4] = proximitySampingKanan();
	sprintf(lcdchar, "%d %d %d %d %d", var[0], var[1], var[2], var[3], var[4]);
	lcd_putsfxy(lcdchar, 0, 0);
	Delayms(100);
	lcd_clear();
}
