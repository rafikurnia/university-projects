#ifndef __LIB_KIPAS_H
#define __LIB_KIPAS_H

#define KIPAS_PORT GPIOA
#define KIPAS_CLK_LINE RCC_AHB1Periph_GPIOA

#define KIPAS_PIN GPIO_Pin_10

void kipasInit();
void kipasStart();
void kipasStop();

#endif
