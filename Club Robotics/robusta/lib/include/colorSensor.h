#ifndef _COLORSENSOR_H_
#define _COLORSENSOR_H_

void ADC_PORT_CONFIG(void);
void ADC_FEATURE_CONFIG(void);
uint16_t read_adc1(uint8_t channel);
uint8_t warna();
int isLine();
extern const int RED;
extern const int BLUE;
extern const int BLACK;
extern const int WHITE;

#endif
