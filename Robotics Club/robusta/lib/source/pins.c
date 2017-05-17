#include <main.h>

void setPins(){
	GPIO_InitTypeDef gpio_init;

	RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOA, ENABLE); //Mengaktifkan reset dan clock controller untuk port A
	gpio_init.GPIO_Pin = GPIO_Pin_10; //Hanya mengkonfigurasikan PIN0, yaitu button internal;
	gpio_init.GPIO_Mode = GPIO_Mode_OUT; //Mode input
	gpio_init.GPIO_Speed = GPIO_Speed_100MHz; //clock 100MHz
	gpio_init.GPIO_OType = GPIO_OType_PP; //Type PUSH PULL
	gpio_init.GPIO_PuPd = GPIO_PuPd_NOPULL; //Memakai pull down resistor
	GPIO_Init(GPIOA, &gpio_init); //pass semua parameter setting untuk GPIOA
	int bit = 0b10000000000;
	GPIO_ResetBits(GPIOA, bit);

	RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOE, ENABLE); //Mengaktifkan reset dan clock controller untuk port A
	gpio_init.GPIO_Pin = GPIO_Pin_15; //Hanya mengkonfigurasikan PIN0, yaitu button internal;
	gpio_init.GPIO_Mode = GPIO_Mode_OUT; //Mode input
	gpio_init.GPIO_Speed = GPIO_Speed_100MHz; //clock 100MHz
	gpio_init.GPIO_OType = GPIO_OType_PP; //Type PUSH PULL
	gpio_init.GPIO_PuPd = GPIO_PuPd_NOPULL; //Memakai pull down resistor
	GPIO_Init(GPIOE, &gpio_init); //pass semua parameter setting untuk GPIOA
	bit = 0b1000000000000000;
	GPIO_SetBits(GPIOE, bit);
}

