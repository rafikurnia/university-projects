#include "wallFollowingKiri.h"
#include "wallFollowing.h"
#include "main.h"
#include "jalanDasar.h"
#include "i2c.h"
#include "liblcd.h"
#include "colorSensor.h"

#define MIN_DIST 14
#define MID_DIST 16
#define FAR_DIST 19
#define MAX_DIST 35

const int WFTYPE_INIT = 4;
const int WFTYPE_WHITE = 1;
const int WFTYPE_BLACK = 2;
const int WFTYPE_GREY = 3;
const int WFTYPE_3TO4 = 5;
const int WFTYPE_4TO3 = 6;
const int WFTYPE_LINE = 7;

int x = 0;
bool base = true;
char lcdChar[16];

uint8_t countBlack; // buat stm studio
const int pingNameL[9] = { 0xE0, 0xE2, 0xE4, 0xE6, 0xE8, 0xEA, 0xEC, 0xEE };

uint8_t snrFr;
uint8_t snrL2;
uint8_t snrLDg;
uint8_t snrRDg;
uint8_t snrL1;
uint8_t snrR1;
uint8_t snrR2;
bool tikungan = false;
uint8_t b, a;
int n;
int kiri(int type) {
	bool tikungan = false, tunggu_rata = false;
	int i, sonar[8], x = 0;

	while (1) {
		const int ping[8] = { 0xE0, 0xE2, 0xE4, 0xE6, 0xE8, 0xEA, 0xEC, 0xEE };
		bool tunggu_rata = false;
		uint8_t i;
		if (type == WFTYPE_WHITE) {
			if (warna() == WHITE) {
				x++;
				if (x > 1) {
					stopMove();
					normal();
					break;
				} else
					x = 0;
			}
		} else if (type == WFTYPE_BLACK) {
			if (warna() == BLACK) {
				stopMove();
				normal();
				break;
			}
		} else if (type == WFTYPE_GREY) {
			if (warna() == BLUE || warna() == RED) {
				stopMove();
				normal();
				break;
			}
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
		for (i = 0; i < 8; i++) {
			if (i > 0 && i < 5)
				continue;
			sonarRange(ping[i]);
			Delayms(1);
			sonar[i] = sonarGet(ping[i]);
		}
		lcd_clear();
		sprintf(lcdChar, "%d %d %d", snrL1, snrL2, b);
		lcd_putsfxy(lcdChar, 0, 0);
		snrFr = sonar[0];
		snrL2 = sonar[5];
		snrL1 = sonar[6];
		snrLDg = sonar[7];
		a = 0;
		if (tikungan) {
//			if (type == WFTYPE_INIT){
//				maju3(SPEED);
//				while(snrFr > MID_DIST + 1){
//					sonarRange(ping[0]);
//					Delayms(1);
//					snrFr = sonarGet(ping[0]);
//				}
//				Delayms(50);
//				stopMove();
//				Delayms(50);
//				normal();
//				return 1;
//				break;
			if (snrFr < 16) { //depan mentok
				putarKanan15(SPEED);
				b = 0;
			} else if (snrLDg < 18) { //diagonal dekat
				belokKanan41(SPEED);
				b = 1;
			} else if (snrL1 < 19) { //kiri sangat dekant
				maju3(SPEED);
				b = 3;
			} else if (snrL2 < 22) {
				belokKiri04(SPEED);
				b = 2;
			} else
				belokKiri04;
			if (snrL1 < 22 && snrL2 < 22) {
				tikungan = false;
			}
		} else if (snrFr < 18) { //mentok depan
			putarKanan15(SPEED);
			b = 4;
		} else if (snrLDg < 18) { //mepet depan
			belokKanan40(SPEED);
			b = 5;
			//belokkananjauh(SPEED);
		} else {
			if (snrL1 > 30 && snrL2 > 30) {
				tikungan = true;
			} else if (snrL1 > 30) { //kiri kosong sangat jauh
				tikungan = true;
				a = 1;
			} else if (snrL1 - snrL2 > MID_DIST) { //mau masuk tikungan
				belokKiri04(SPEED);
				b = 6;
			} else if (snrL2 - snrL1 > 0) { //miring ke kiri
				b = 7;
				belokKanan32(SPEED);
			} else if (snrL1 - snrL2 > 0) { //miring ke kanan
				b = 8;
				belokKiri13(SPEED);
			} else if (snrR1 - snrR2 == 0) { //cukup rata
				if (snrL1 >= 16) { //kiri kosong agak jauh
					belokKiri13(SPEED);
					b = 9;
				} else if (snrL1 >= 14) { //kiri kosong agak jauh
					maju3(SPEED);
					b = 10;
				} else {
					belokKanan31(SPEED);
					b = 11;
				}
			} else {
				maju3(SPEED);
				b = 12;
			}
		}
	}
	return 0;
}

int kiri2(int type) {
	bool tikungan = false, tunggu_rata = false;
	int i, sonar[8];

	while (1) {
		const int ping[8] = { 0xE0, 0xE2, 0xE4, 0xE6, 0xE8, 0xEA, 0xEC, 0xEE };
		bool tunggu_rata = false;
		uint8_t i;
		for (i = 0; i < 8; i++) {
			if (i > 0 && i < 5)
				continue;
			sonarRange(ping[i]);
			Delayms(1);
			sonar[i] = sonarGet(ping[i]);
		}
		snrFr = sonar[0];
		snrRDg = sonar[1];
		snrR1 = sonar[2];
		snrR2 = sonar[3];
		snrL2 = sonar[5];
		snrL1 = sonar[6];
		snrLDg = sonar[7];

		a = 0;
		if (snrFr < 18) { //mentok depan
			putarKanan15(SPEED);
			b = 4;
		} else if (snrLDg < 18) { //mepet depan
			belokKanan40(SPEED);
			b = 5;
			//belokkananjauh(SPEED);
		} else {
			if (snrL1 - snrL2 > MID_DIST) { //mau masuk tikungan
				belokKiri04(SPEED);
				b = 6;
			} else if (snrL2 - snrL1 > 0) { //miring ke kiri
				b = 7;
				belokKanan32(SPEED);
			} else if (snrL1 - snrL2 > 0) { //miring ke kanan
				b = 8;
				belokKiri23(SPEED);
			} else if (snrL1 - snrL2 == 0) { //cukup rata
				if (snrL1 >= MID_DIST) { //kiri kosong agak jauh
					belokKiri23(SPEED);
					b = 9;
				} else if (snrL1 >= MIN_DIST) { //kiri kosong agak jauh
					maju3(SPEED);
					b = 10;
				} else {
//					serongKanan45(SPEED);
					belokKanan32(SPEED);
					b = 11;
				}
			} else {
				maju3(SPEED);
				b = 12;
			}
		}
	}
	return 0;
}

void kiriRoom() {
	int d = 5;
	int f = 4;
	int n = 5;
	int a;
	int i, sonar[8];
	while (1) {
		//baca sonar
		const int ping[8] = { 0xE0, 0xE2, 0xE4, 0xE6, 0xE8, 0xEA, 0xEC, 0xEE };
		bool tunggu_rata = false;
		uint8_t i;
		for (i = 0; i < 8; i++) {
			if (i > 0 && i < 5)
				continue;
			sonarRange(ping[i]);
			Delayms(1);
			sonar[i] = sonarGet(ping[i]);
		}
		snrFr = sonar[0];
		snrRDg = sonar[1];
		snrR1 = sonar[2];
		snrR2 = sonar[3];
		snrL2 = sonar[5];
		snrL1 = sonar[6];
		snrLDg = sonar[7];

		if ((snrLDg < 9 + d) && (snrR1 < 11 + n)) { //kejepit
			maju(-SPEEDROOM);
			Delayms(2000);
			muterkirijauh(-SPEEDROOM);
			Delayms(1500);
			a = 1;
		} else if (snrFr < 12 + f) { //depan dekat, putar kanan
			muterkirijauh(-SPEEDROOM);
			a = 2;
		} else if ((snrR1 < 12 + 1 + n)
				&& (snrL1 < 13 + 1 + n || snrL1 < 13 + 1 + n)) { //depan jauh, kiri kanan dekat
			muterkirijauh(-SPEEDROOM);
			a = 3;
			while (1) {
				sonarRange(LEFTDIAG);
				Delayms(15);
				snrLDg = sonarGet(LEFTDIAG);
				if (snrLDg < 14 + d) {
					break;
				}
			}
		} else if (snrLDg < 11 + d) { //depan
			a = 4;
			muterkirijauh(-SPEEDROOM);
		} else if ((snrLDg - snrL2 >= 50)
				|| ((snrL1 >= 25 + n) && (snrL2 >= 25 + n))) {
			a = 5;
			belokkirijauh(SPEEDROOM);
			while (1) {
				for (i = 0; i < 4; i++) {
					sonarRange(pingNameL[i]);
					Delayms(15);
				}
				snrFr = sonarGet(FRONT);
				snrL2 = sonarGet(LEFTBACK);
				snrLDg = sonarGet(LEFTDIAG);
				snrL1 = sonarGet(LEFTFRONT);
				//add kalau kena white, break;
				if ((snrL1 < 15 + n) || (snrL2 < 15 + n) || (snrLDg < 11 + d)
						|| (snrFr < 7 + 2 + f))
					break;
			}
		} else if (snrL1 > 14 + n) {
			a = 6;
			belokkirijauh(SPEED);
			while (1) {
				sonarRange(FRONT);
				sonarRange(LEFTDIAG);
				Delayms(15);
				snrLDg = sonarGet(FRONT);
				snrFr = sonarGet(LEFTDIAG);
				if ((snrFr < 11 + f) || (snrLDg < 11 + d))
					break;
			}
		} else if (snrL2 - snrL1 >= 3) {
			a = 7;
			if (snrLDg < 15) {
				belokkanansedang(SPEEDROOM);
			} else {
				belokkirijauh(SPEED); //kiri tajam
			}
		} else if (snrL1 - snrL2 >= 3) {
			a = 8;
			belokkirijauh(SPEED);
		} else {
			a = 9;
			maju(SPEEDROOM);
		}
	}
}

void rataKiri() {
	int i, sonar[8];
	int count = 0, meh = 0;
	while (1) {
		const int ping[8] = { 0xE0, 0xE2, 0xE4, 0xE6, 0xE8, 0xEA, 0xEC, 0xEE };
		uint8_t i;
		for (i = 0; i < 8; i++) {
			if (i > 0 && i < 5)
				continue;
			sonarRange(ping[i]);
			Delayms(1);
			sonar[i] = sonarGet(ping[i]);
		}
		snrFr = sonar[0];
		snrL2 = sonar[5];
		snrL1 = sonar[6];
		snrLDg = sonar[7];
		if (snrL2 > 17 && snrL1 > 16) {
			geserKiri3(SPEED);
			Delayms(100);
		} else if (snrL1 == snrL2) { //udah rata
			count++;
			stopMove();
			Delayms(50);
			normal();
			if (count > 3) {
				stopMove();
				normal();
				break;
			} else if (meh == 2) {
				putarKiri3(SPEED);
			} else
				putarKanan3(SPEED);
		} else if (snrL1 - snrL2 >= 5) {
			putarKiri45(SPEED);
			meh = 1;
		} else if (snrL1 - snrL2 >= 4) {
			putarKiri30(SPEED);
			meh = 1;
		} else if (snrL1 - snrL2 >= 2) {
			putarKiri15(SPEED);
			meh = 1;
		} else if (snrL1 - snrL2 >= 1) {
			putarKiri5(SPEED);
			meh = 1;
		} else if ((snrLDg - snrL1 >= 3) || (snrLDg - snrL2 >= 3)) {
			putarKiri15(SPEED);
			meh = 1;
		} else if (snrL2 - snrL1 >= 5) {
			putarKanan45(SPEED);
			meh = 2;
		} else if (snrL2 - snrL1 >= 4) {
			putarKanan30(SPEED);
			meh = 2;
		} else if (snrL2 - snrL1 >= 2) {
			putarKanan15(SPEED);
			meh = 2;
		} else if (snrL2 - snrL1 >= 1) {
			putarKanan5(SPEED);
			meh = 2;
		} else if ((snrL2 - snrLDg >= 3) || (snrL1 - snrLDg >= 3)) {
			putarKanan15(SPEED);
			meh = 2;
		}
	}
}
