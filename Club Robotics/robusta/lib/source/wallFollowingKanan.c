#include "wallFollowingKanan.h"
#include "wallFollowing.h"
#include "main.h"
#include "jalanDasar.h"
#include "i2c.h"
#include "colorSensor.h"
#include  "wallFollowingKiri.h"

#define MIN_DIST 14
#define MID_DIST 16
#define FAR_DIST 19
#define MAX_DIST 35

int snrFr;
int snrRDg;
int snrR2;
int snrR1;
char lcdChar[16];

void kanan(int type) {
	bool tikungan = false, base = true;
	int i, a, b, x, sonar[8];
	while (1) {
		const int ping[8] = { 0xE0, 0xE2, 0xE4, 0xE6, 0xE8, 0xEA, 0xEC, 0xEE };
		uint8_t i;
		if (type == WFTYPE_WHITE) {
			if (warna() == WHITE) {
				stopMove();
				normal();
				break;
			}
		} else if (type == WFTYPE_BLACK) {
			if (warna() == BLACK) {
				x++;
				if (x > 3) {
					stopMove();
					normal();
					break;
				} else
					x = 0;
			}
		} else if (type == WFTYPE_GREY) {
			if (warna() == BLUE || warna() == RED) {
				x++;
				if (x > 2) {
					stopMove();
					normal();
					break;
				}
			} else
				x = 0;
		} else if (type == WFTYPE_INIT) {
			if (x > 10 && base) {
				base = false;
				lcd_clear();
				sprintf(lcdChar, "no base");
				lcd_putsfxy(lcdChar, 1, 1);
			} else if (base && warna() == 3) {
				lcd_clear();
				sprintf(lcdChar, "base");
				lcd_putsfxy(lcdChar, 1, 1);
				x++;
			} else if (!base && warna() == 4) {
				lcd_clear();
				sprintf(lcdChar, "line");
				lcd_putsfxy(lcdChar, 1, 1);
				break;
			}
		} else if (type == WFTYPE_LINE) {
			if (isLine() == 1) {
				stopMove();
				normal();
				break;
			}
		}
		for (i = 0; i < 4; i++) {
			sonarRange(ping[i]);
			Delayms(1);
			sonar[i] = sonarGet(ping[i]);
		}
		snrFr = sonar[0];
		snrRDg = sonar[1];
		snrR1 = sonar[2];
		snrR2 = sonar[3];
		lcd_clear();
		sprintf(lcdChar, "%d %d %d", snrR1, snrR2, b);
		lcd_putsfxy(lcdChar, 0, 0);
		if (tikungan) { // ketika snrR1 dan snrR2 jauh sekali
			if (snrFr < 16) { //depan mentok
				putarKiri15(SPEED);
				b = 0;
			} else if (snrRDg < 18) { //diagonal dekat
				belokKiri14(SPEED);
				b = 1;
			} else if (snrR1 < 19) { //kiri sangat dekant
				maju3(SPEED);
				b = 3;
			} else if (snrR2 < 20) {
				belokKanan30(SPEED);
				b = 2;
			} else
				belokKiri04;
			if (snrR1 < 22 && snrR2 < 22) {
				tikungan = false;
			}
		} else if (snrFr < 18) { //mentok depan
			putarKiri15(SPEED);
			b = 4;
		} else if (snrRDg < 18) { //mepet depan
			belokKiri04(SPEED);
			b = 5;
		} else {
			if (snrR1 > 30 && snrR2 > 30) {
				tikungan = true;
			} else if (snrR1 > 30) { //kiri kosong sangat jauh
				tikungan = true;
				a = 1;
			} else if (snrR1 - snrR2 > MID_DIST) { //mau masuk tikungan
				belokKanan40(SPEED);
				b = 6;
			} else if (snrR2 - snrR1 > 0) { //miring ke kiri
				b = 7;
				belokKiri23(SPEED);
			} else if (snrR1 - snrR2 > 0) { //miring ke kanan
				b = 8;
				belokKanan32(SPEED);
			} else if (snrR1 - snrR2 == 0) { //cukup rata
				if (snrR1 >= 16) {
					belokKanan31(SPEED);
				} else if (snrR1 >= 14) { //kiri kosong agak jauh
					maju3(SPEED);
					b = 10;
				} else {
					belokKiri13(SPEED);
					b = 11;
				}
			} else {
				maju3(SPEED);
				b = 12;
			}
		}
	}
}

void rataKanan() {
	int i;
	int count = 0, meh = 0;
	int sonar[8];
	while (1) {
		const int ping[8] = { 0xE0, 0xE2, 0xE4, 0xE6, 0xE8, 0xEA, 0xEC, 0xEE };
		uint8_t i;
		for (i = 0; i < 4; i++) {
			sonarRange(ping[i]);
			Delayms(1);
			sonar[i] = sonarGet(ping[i]);
		}
		snrFr = sonar[0];
		snrRDg = sonar[1];
		snrR1 = sonar[2];
		snrR2 = sonar[3];
		if (snrR2 > 17 && snrR1 > 16) {
			geserKanan3(SPEED);
			Delayms(100);
		} else if (snrR1 == snrR2) { //udah rata
			count++;
			stopMove();
			Delayms(50);
			normal();
			if (count > 3) {
				stopMove();
				normal();
				break;
			} else if (meh == 2) {
				putarKanan3(SPEED);
			} else
				putarKiri3(SPEED);
		} else if (snrR1 - snrR2 >= 5) {
			putarKanan45(SPEED);
			meh = 1;
		} else if (snrR1 - snrR2 >= 4) {
			putarKanan30(SPEED);
			meh = 1;
		} else if (snrR1 - snrR2 >= 2) {
			putarKanan15(SPEED);
			meh = 1;
		} else if (snrR1 - snrR2 >= 1) {
			putarKanan5(SPEED);
			meh = 1;
		} else if ((snrRDg - snrR1 >= 3) || (snrRDg - snrR2 >= 3)) {
			putarKanan15(SPEED);
			meh = 1;
		} else if (snrR2 - snrR1 >= 5) {
			putarKiri45(SPEED);
			meh = 2;
		} else if (snrR2 - snrR1 >= 4) {
			putarKiri30(SPEED);
			meh = 2;
		} else if (snrR2 - snrR1 >= 2) {
			putarKiri15(SPEED);
			meh = 2;
		} else if (snrR2 - snrR1 >= 1) {
			putarKiri5(SPEED);
			meh = 2;
		} else if ((snrR2 - snrRDg >= 3) || (snrR1 - snrRDg >= 3)) {
			putarKiri15(SPEED);
			meh = 2;
		}
	}
}

