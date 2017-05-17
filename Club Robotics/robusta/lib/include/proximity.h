#ifndef __LIB_PROXIMITY_H
#define __LIB_PROXIMITY_H

#define PROX_PORT GPIOE
#define PROX_CLK_LINE RCC_AHB1Periph_GPIOE

#define PROX1 GPIO_Pin_0
#define PROX2 GPIO_Pin_2
#define PROX3 GPIO_Pin_8
#define PROX4 GPIO_Pin_1
#define PROX5 GPIO_Pin_3
//#define PROX6 GPIO_Pin_9 //dipake lcd

void proximityInit();
bool proximityDepan();
bool proximityDepanKanan();
bool proximityDepanKiri();
bool proximitySampingKanan();
bool proximitySampingKiri();

#endif
