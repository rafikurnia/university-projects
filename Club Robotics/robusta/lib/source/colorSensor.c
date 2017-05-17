#include "main.h"
#include "colorSensor.h"

uint16_t Nilai_ADC;

const int RED = 1;
const int BLUE = 2;
const int BLACK = 3;
const int WHITE = 4;
const int BB_THRES[6] = { 2800, 3500, 3400, 2400, 3000, 2800 };
const int BR_THRES[6] = { 2500, 2000, 2700, 1000, 1250, 1500 };
const int RW_THRES[6] = { 1500, 500, 600, 230, 220, 250};

void ADC_PORT_CONFIG(void) {
	//mengaktifkan RCC untuk GPIOC dan ADC1
	RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOC, ENABLE);
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_ADC1, ENABLE);

	GPIO_InitTypeDef GPIO_InitStructure;
	GPIO_StructInit(&GPIO_InitStructure);

	//karena menggunakan ADC 1 , bisa dipakai IN10 dan IN11 , baca datasheet
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_0 | GPIO_Pin_1 | GPIO_Pin_2
			| GPIO_Pin_3 | GPIO_Pin_4 | GPIO_Pin_5;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AN; //pakai mode Analog inpuy
	GPIO_InitStructure.GPIO_PuPd = GPIO_PuPd_NOPULL; // tidak pakai pull up atau pull down
	GPIO_Init(GPIOC, &GPIO_InitStructure);
}
void ADC_FEATURE_CONFIG(void) {
	//Setting konfigurasi ADC1
	ADC_CommonInitTypeDef ADC_CommonInitStructure;
	ADC_InitTypeDef ADC_InitStructure;

	ADC_CommonInitStructure.ADC_Mode = ADC_Mode_Independent;
	ADC_CommonInitStructure.ADC_Prescaler = ADC_Prescaler_Div2;
	ADC_CommonInitStructure.ADC_DMAAccessMode = ADC_DMAAccessMode_Disabled;
	ADC_CommonInitStructure.ADC_TwoSamplingDelay = ADC_TwoSamplingDelay_5Cycles;

	ADC_CommonInit(&ADC_CommonInitStructure);

	ADC_InitStructure.ADC_Resolution = ADC_Resolution_12b;
	ADC_InitStructure.ADC_ScanConvMode = DISABLE;
	ADC_InitStructure.ADC_ContinuousConvMode = ENABLE;
	ADC_InitStructure.ADC_ExternalTrigConvEdge = ADC_ExternalTrigConvEdge_None;
	ADC_InitStructure.ADC_ExternalTrigConv = ADC_ExternalTrigConv_T1_CC1;
	ADC_InitStructure.ADC_DataAlign = ADC_DataAlign_Right;
	ADC_InitStructure.ADC_NbrOfConversion = 1;

	ADC_StructInit(&ADC_InitStructure);
	ADC_Init(ADC1, &ADC_InitStructure);

	ADC_EOCOnEachRegularChannelCmd(ADC1, ENABLE);
	ADC_Cmd(ADC1, ENABLE); //The ADC is powered on by setting the ADON bit in the ADC_CR2 register.
	//When the ADON bit is set for the first time, it wakes up the ADC from the Power-down mode.
}

/*
 Fungsi read_adc1() untuk mempermudah
 pemanggilan nilai data ADC yang
 ingin diolah
 */
uint16_t read_adc1(uint8_t channel) {
	uint16_t ADC_Value;
	ADC_RegularChannelConfig(ADC1, channel, 1, ADC_SampleTime_480Cycles); //setting Channel ADC yg akan diolah
	ADC_SoftwareStartConv(ADC1); //start capture data
	while (ADC_GetFlagStatus(ADC1, ADC_FLAG_EOC) == RESET)
		; //tunggu konversi selesai
	ADC_Value = ADC_GetConversionValue(ADC1); // get data
	return ADC_Value;
}

uint8_t warna() {
	uint8_t i;
	uint16_t color[5] = { 0, 0, 0, 0, 0 }, adc;
	for (i = 0; i < 6; i++) {
		adc = read_adc1(i + 10);
		if (adc > BB_THRES[i]) {
			color[BLACK]++;
			if (color[BLACK] > 3)
				return BLACK;
		} else if (adc > BR_THRES[i]) {
			color[BLUE]++;
			if (color[BLUE] > 3)
				return BLUE;
		} else if (adc > RW_THRES[i]) {
			color[RED]++;
			if (color[RED] > 3)
				return RED;
		} else {
			color[WHITE]++;
			if (color[WHITE] > 3)
				return WHITE;
		}
	}
	return 0;
}

int isLine() {
	uint8_t i;
	char lcdChar[16];
	uint16_t color[5] = { 0, 0, 0, 0, 0 }, adc;
	for (i = 0; i < 6; i++) {
		color[i] = read_adc1(i + 10);
		sprintf(lcdChar, "%d", color[i]);
		if (i < 3)
			lcd_putsfxy(lcdChar, i * 5, 0);
		else
			lcd_putsfxy(lcdChar, (i - 3) * 5, 1);
	}
	if ((color[0] > BR_THRES[0] && color[2] > BR_THRES[2]
			&& (color[3] < RW_THRES[3] || color[4] < RW_THRES[4]))
			|| (color[1] > BR_THRES[1] && color[2] > BR_THRES[2]
					&& color[5] < RW_THRES[5])
			|| (color[1] > BR_THRES[1] && color[5] > BR_THRES[5]
					&& color[2] < RW_THRES[2])) {
		return 1;
	}
	return 0;
}

//
