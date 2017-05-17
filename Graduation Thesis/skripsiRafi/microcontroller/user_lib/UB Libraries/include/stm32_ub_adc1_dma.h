//--------------------------------------------------------------
// File     : stm32_ub_adc1_dma.h
//--------------------------------------------------------------

//--------------------------------------------------------------
#ifndef __STM32F4_UB_ADC1_DMA_H
#define __STM32F4_UB_ADC1_DMA_H


//--------------------------------------------------------------
// Includes
//--------------------------------------------------------------
#include "stm32f4xx.h"
#include "stm32f4xx_gpio.h"
#include "stm32f4xx_rcc.h"
#include "stm32f4xx_adc.h"
#include "stm32f4xx_dma.h"


//--------------------------------------------------------------
// Liste aller ADC-Kanäle
// (keine Nummer doppelt und von 0 beginnend)
//--------------------------------------------------------------
typedef enum {
	  ADC_PA3 = 0,  // PA5
	  ADC_PA5 = 1,   // PC3
	  ADC_PA6 = 2,  // PA5
	  ADC_PA7 = 3,   // PC3
	  ADC_PB0 = 4,  // PA5
	  ADC_PB1 = 5,   // PC3
	  ADC_PC1 = 6,  // PA5
	  ADC_PC3 = 7,   // PC3
}ADC1d_NAME_t;

#define  ADC1d_ANZ   8 // Anzahl von ADC1d_NAME_t (maximum = 16)


//--------------------------------------------------------------
// Adressen der ADCs
// (siehe Seite 66+427 vom Referenz Manual)
//--------------------------------------------------------------
#define ADC_BASE_ADR        ((uint32_t)0x40012000)
#define ADC_ADC1_OFFSET     ((uint32_t)0x00000000)

//--------------------------------------------------------------
// Adressen der Register
// (siehe Seite 427+428 vom Referenz Manual)
//--------------------------------------------------------------
#define ADC_REG_DR_OFFSET         0x4C

#define ADC1_DR_ADDRESS    (ADC_BASE_ADR | ADC_ADC1_OFFSET | ADC_REG_DR_OFFSET)



//--------------------------------------------------------------
// ADC-Clock
// Max-ADC-Frq = 36MHz
// Grundfrequenz = APB2 (APB2=90MHz)
// Mögliche Vorteiler = 2,4,6,8
//--------------------------------------------------------------

//#define ADC1d_VORTEILER     ADC_Prescaler_Div2 // Frq = 45 MHz
#define ADC1d_VORTEILER     ADC_Prescaler_Div4   // Frq = 22.5 MHz
//#define ADC1d_VORTEILER     ADC_Prescaler_Div6 // Frq = 15 MHz
//#define ADC1d_VORTEILER     ADC_Prescaler_Div8 // Frq = 11.25 MHz


//--------------------------------------------------------------
// DMA Einstellung
// (siehe Seite 304+305 vom Referenz Manual)
// Moegliche DMAs fuer ADC1 :
//   DMA2_STREAM0_CHANNEL0
//   DMA2_STREAM4_CHANNEL0
//--------------------------------------------------------------

#define ADC1_DMA_STREAM0            0
//#define ADC1_DMA_STREAM4          4

#ifdef ADC1_DMA_STREAM0
 #define ADC1_DMA_STREAM            DMA2_Stream0
 #define ADC1_DMA_CHANNEL           DMA_Channel_0
#elif defined ADC1_DMA_STREAM4
 #define ADC1_DMA_STREAM            DMA2_Stream4
 #define ADC1_DMA_CHANNEL           DMA_Channel_0
#endif





//--------------------------------------------------------------
// Struktur eines ADC Kanals
//--------------------------------------------------------------
typedef struct {
  ADC1d_NAME_t ADC_NAME;  // Name
  GPIO_TypeDef* ADC_PORT; // Port
  const uint16_t ADC_PIN; // Pin
  const uint32_t ADC_CLK; // Clock
  const uint8_t ADC_CH;   // ADC-Kanal
}ADC1d_t;



//--------------------------------------------------------------
// Globale Funktionen
//--------------------------------------------------------------
void UB_ADC1_DMA_Init(void);
uint16_t UB_ADC1_DMA_Read(ADC1d_NAME_t adc_name);


//--------------------------------------------------------------
#endif // __STM32F4_UB_ADC1_DMA_H
