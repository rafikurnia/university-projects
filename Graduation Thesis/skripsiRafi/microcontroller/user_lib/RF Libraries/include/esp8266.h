#ifndef __ESP_8266_H
#define __ESP_8266_H

#include <stdbool.h>
#include "stm32_ub_button.h"
#include "stm32_ub_uart.h"
#include "stm32_ub_font.h"
#include "stm32_ub_lcd_ili9341.h"
#include "rf_stepstick.h"

UART_RXSTATUS_t check;
char rx_buf[RX_BUF_SIZE];

bool esp8266_init();
void esp8266_delay(uint32_t a);
int waitForRespond(int timeOut, bool DEBUG);
int waitAndEcho();
bool esp8266_isConnected();
bool esp8266_isMulti();
bool esp8266_reset();
bool esp8266_setMode();
bool esp8266_disconnect();
bool esp8266_connect(bool DEBUG);
bool esp8266_multi();
bool esp8266_handshake();
bool esp8266_sendString(char* data);
bool esp8266_close();
void esp8266_sendOp(char* data);

#endif
