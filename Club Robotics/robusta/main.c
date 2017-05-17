#include "main.h"
#include "rplidar.h"
#include "jalandasar.h"
#include "tes.h"
#include "uart.h"
#include "wallFollowingKiri.h"
#include "wallFollowingKanan.h"
#include "i2c.h"
#include "exti0.h"
#include "liblcd.h"
#include "kipas.h"
#include "colorSensor.h"

int sonar[8], color[6], photon, proximity[5];
int room1, l1, var1;
char lcdChar[16];
char menuChar[16][15] = { "MAIN", "SONAR", "ADC", "COLOR",
		"TPA", "UVTRON", "PROXIMITY", "WF KIRI", "WF KANAN",
		"KIRI 90", "KANAN 90", "KIRI 180", "KANAN 180",
		"RATA KIRI", "RATA KANAN" };

void tesHere() {
	putarKiri90();
	kanan(WFTYPE_GREY);
	kanan(WFTYPE_BLACK);
	rataKanan();
	majuBebas(70, 1000);
	kiri(WFTYPE_WHITE);
	rataKanan();
	majuBebas(70, 1000);
}

int main(void) {
	int x, i = 0;
	const int ping[8] = { 0xE0, 0xE2, 0xE4, 0xE6, 0xE8, 0xEA, 0xEC, 0xEE };

	initAll();

	lcd_clear();
	lcd_putsfxy("Robusta", 0,1);
	while(!tombol1() && !tombol2() && !tombol3() && !tombol4()&& !tombolStart());
	Delayms(200);

	for (i = 0; i < 8; i++) {
		sonarSetGain(ping[i], 5);
	}
	sonarSetRange(0xE0, 400);
	sonarSetRange(0xE2, 400);
	sonarSetRange(0xE4, 400);
	sonarSetRange(0xE6, 400);
	sonarSetRange(0xE8, 400);
	sonarSetRange(0xEA, 400);
	sonarSetRange(0xEC, 400);
	sonarSetRange(0xEE, 400);

	i = -1;
	int j = 0;
	bool execute = false;
	char lcdNext[16];
	int max = sizeof(menuChar[16]), line = 0, nextLine;

	while (1) {
		if (tombol3()) {
			Delayms(200);
			i++;
			j = i - 1;
			line = 1;
			if (i >= max - 1) {
				i -= max;
				j = i+1;
				line = 0;
			}
		} else if (tombol4()) {
			Delayms(200);
			i--;
			j = i + 1;
			line = 0;
			if (i <= -2) {
				i = max-2;
				j = max-3;
				line = 1;
			}
		} else if (tombolStart() || tombol1()) {
			execute = true;
		}
		nextLine = 0;
		if (nextLine == line) nextLine = 1;
		lcd_clear();
		sprintf(lcdNext, "  %d %s", j+2, menuChar[j+1]);
		sprintf(lcdChar, "> %d %s", i+2, menuChar[i+1]);
		lcd_putsfxy(lcdChar, 0, line);
		lcd_putsfxy(lcdNext, 0, nextLine);
		int option = i+2;
		switch (option) {
		case 1:
			if (execute) {
				tesHere();
			}
			break;
		case 2:
			if (execute) {
				tesSonar();
			}
			break;
		case 3:
			if (execute) {
				tesADC();
			}
			break;
		case 4:
			if (execute) {
				tesColor();
			}
			break;
		case 5:
			if (execute) {
				tesTPA();
			}
			break;
		case 6:
			if (execute) {
				tesUVtron();
			}
			break;
		case 7:
			if (execute) {
				tesProximity();
			}
			break;
		case 8:
			if (execute) {
				kiri(WFTYPE_WHITE);
			}
			break;
		case 9:
			if (execute) {
				kanan(WFTYPE_WHITE);
			}
			break;
		case 10:
			if (execute) {
				putarKiri90();
			}
			break;
		case 11:
			if (execute) {
				putarKanan90();
			}
			break;
		case 12:
			if (execute) {
				putarKiri180();
			}
			break;
		case 13:
			if (execute) {
				putarKanan180();
			}
			break;
		case 14:
			if (execute) {
				rataKiri();
			}
			break;
		case 15:
			if (execute) {
				rataKanan();
			}
			break;
		default:
			break;
		}
		Delayms(100);
		if (execute) {
			execute = false;
		}
	}
}

void initAll(){
	SystemInit();
	GPIO_InitTypeDef gpio_init;
	TM_DELAY_Init();
	uartInit();
	i2c_init();
	ADC_PORT_CONFIG();
	ADC_FEATURE_CONFIG();
	UB_Ext_INT0_Init();
	proximityInit();
	tombolInit();
	kipasInit();
	resetArduino();
	lcd_init();
//	LidarInit();
}

void resetArduino() {
	GPIO_InitTypeDef gpio_init;
	RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOD, ENABLE);
	gpio_init.GPIO_Pin = GPIO_Pin_13;
	gpio_init.GPIO_Mode = GPIO_Mode_OUT;
	gpio_init.GPIO_Speed = GPIO_Speed_100MHz;
	gpio_init.GPIO_OType = GPIO_OType_PP;
	gpio_init.GPIO_PuPd = GPIO_PuPd_NOPULL;
	GPIO_Init(GPIOD, &gpio_init);

	GPIO_ResetBits(GPIOD, GPIO_Pin_13);
	Delayms(50);
	GPIO_SetBits(GPIOD, GPIO_Pin_13);
}

void tesSonar() {
	const int ping[8] = { 0xE0, 0xE2, 0xE4, 0xE6, 0xE8, 0xEA, 0xEC, 0xEE };
	uint8_t i;
	while (!tombol4() && !tombol3()) {
		lcd_clear();
		for (i = 0; i < 8; i++) {
			sonarRange(ping[i]);
//			Delayms(1);
			sonar[i] = sonarGet(ping[i]);
			sprintf(lcdChar, "%d", sonar[i]);
			if (i < 5)
				lcd_putsfxy(lcdChar, i * 3, 0);
			else
				lcd_putsfxy(lcdChar, (i - 5) * 3, 1);
		}
		Delayms(25);
	}
}
void tesColor() {
	while (!tombol4()&& !tombol3()) {
		int x = warna();
		lcd_clear();
		if (x == BLACK) {
			lcd_putsf("BLK");
		} else if (x == BLUE) {
			lcd_putsf("BLU");
		} else if (x == RED) {
			lcd_putsf("RED");
		} else {
			lcd_putsf("WHT");
		}
		Delayms(200);
	}
}
void tesADC() {
	uint8_t i;
	while (!tombol4() && !tombol3()) {
		lcd_clear();
		for (i = 0; i < 6; i++) {
			color[i] = read_adc1(i + 10);
			sprintf(lcdChar, "%d", color[i]);
			if (i < 3)
				lcd_putsfxy(lcdChar, i * 5, 0);
			else {
				lcd_putsfxy(lcdChar, (i - 3) * 5, 1);
			}
		}

		Delayms(100);

	}
}

void tesUVtron() {
	lcd_clear();
	lcd_putsf("scanning...");
	while (!tombol4() && !tombol3())
		photon = uvtron_check();
}

void tesProximity() {
//	char lcdChar[16];
	while (!tombol4()&& !tombol3()) {
		proximity[0] = proximityDepan();
		proximity[1] = proximityDepanKanan();
		proximity[2] = proximityDepanKiri();
		proximity[3] = proximitySampingKanan();
		proximity[4] = proximitySampingKiri();
		sprintf(lcdChar, "%d %d %d %d %d", proximity[0], proximity[1], proximity[2], proximity[3], proximity[4]);
		lcd_putsfxy(lcdChar, 0, 0);
		Delayms(100);
		lcd_clear();
	}
}

void tesAll() {
	const int ping[8] = { 0xE0, 0xE2, 0xE4, 0xE6, 0xE8, 0xEA, 0xEC, 0xEE };
	uint8_t i;
	while (1) {
		for (i = 0; i < 8; i++) {
			if (i > 0 && i < 5)
				continue;
			sonarRange(ping[i]);
			Delayms(1);
			sonar[i] = sonarGet(ping[i]);
		}
		for (i = 0; i < 6; i++) {
			color[i] = read_adc1(i + 10);
		}
		photon = uvtron_check();
		proximity[0] = proximityDepan();
		proximity[1] = proximityDepanKanan();
		proximity[2] = proximityDepanKiri();
		proximity[3] = proximitySampingKanan();
		proximity[4] = proximitySampingKiri();
	}
}

void tesTPA() {
	int i = 0, x, b = 0;
	while (!tombol4() && !tombol3()) {
		if (i > 29) {
			b = 1;
		} else if (i == 0) {
			b = 0;
		}
		tpaSetServo(i);
		x = getTpa81();
		lcd_clear();
		sprintf(lcdChar, "%d", x);
		lcd_putsfxy(lcdChar, 1, 1);
		while (x > 50 && !tombol4()&& !tombol3()) {
			tpaSetServo(i);
//			x = getTpa81();
//			lcd_clear();
//			sprintf(lcdChar, "%d", x);
//			lcd_putsfxy(lcdChar, 1, 1);
		}
		Delayms(50);
		if (b == 0) {
			i++;
		} else
			i--;
	}
}
