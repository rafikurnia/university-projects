#include "main.h"
#include "tombol.h"

void tombolInit() {
	GPIO_InitTypeDef GPIO_InitStructure;

	RCC_AHB1PeriphClockCmd(TOMBOL1_CLK_LINE, ENABLE);
	GPIO_InitStructure.GPIO_Pin = TOMBOL_START | INPUT_SOUND;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_100MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IN;
	GPIO_InitStructure.GPIO_OType = GPIO_OType_PP;
	GPIO_InitStructure.GPIO_PuPd = GPIO_PuPd_NOPULL;
	GPIO_Init(TOMBOL1_PORT, &GPIO_InitStructure);

	RCC_AHB1PeriphClockCmd(TOMBOL2_CLK_LINE, ENABLE);
	GPIO_InitStructure.GPIO_Pin = TOMBOL_1 | TOMBOL_2 | TOMBOL_3 | TOMBOL_4;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_100MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IN;
	GPIO_InitStructure.GPIO_OType = GPIO_OType_PP;
	GPIO_InitStructure.GPIO_PuPd = GPIO_PuPd_NOPULL;

	GPIO_Init(TOMBOL2_PORT, &GPIO_InitStructure);
}

bool tombolStart() {
	return !GPIO_ReadInputDataBit(TOMBOL1_PORT, TOMBOL_START);
}

bool sound() {
	return !GPIO_ReadInputDataBit(TOMBOL1_PORT, INPUT_SOUND);
}

bool tombol1() {
	return !GPIO_ReadInputDataBit(TOMBOL2_PORT, TOMBOL_1);
}

bool tombol2() {
	return !GPIO_ReadInputDataBit(TOMBOL2_PORT, TOMBOL_2);
}

bool tombol3() {
	return !GPIO_ReadInputDataBit(TOMBOL2_PORT, TOMBOL_3);
}

bool tombol4() {
	return !GPIO_ReadInputDataBit(TOMBOL2_PORT, TOMBOL_4);
}

void cekTombol() {
	bool var[4];
	unsigned char lcdchar[14];
	var[0] = tombol1();
	var[1] = tombol2();
	var[2] = tombol3();
	var[3] = tombol4();
	sprintf(lcdchar, "%d %d %d %d", var[0], var[1], var[2], var[3]);
	lcd_putsfxy(lcdchar, 0, 0);
	var[0] = tombolStart();
	var[1] = sound();
	sprintf(lcdchar, "st:%d snd:%d", var[0], var[1], var[2], var[3], var[4]);
	lcd_putsfxy(lcdchar, 0, 1);
	Delayms(100);
	lcd_clear();
}
