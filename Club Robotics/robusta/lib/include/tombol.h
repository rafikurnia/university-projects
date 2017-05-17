#ifndef __LIB_TOMBOL_H
#define __LIB_TOMBOL_H

#define TOMBOL1_PORT GPIOA
#define TOMBOL1_CLK_LINE RCC_AHB1Periph_GPIOA
#define TOMBOL_START GPIO_Pin_8
#define INPUT_SOUND GPIO_Pin_7

#define TOMBOL2_PORT GPIOB
#define TOMBOL2_CLK_LINE RCC_AHB1Periph_GPIOB
#define TOMBOL_1 GPIO_Pin_2
#define TOMBOL_2 GPIO_Pin_3
#define TOMBOL_3 GPIO_Pin_4
#define TOMBOL_4 GPIO_Pin_5

void tombolInit();
bool tombolStart();
bool sound();
bool tombol1();
bool tombol2();
bool tombol3();
bool tombol4();

#endif
