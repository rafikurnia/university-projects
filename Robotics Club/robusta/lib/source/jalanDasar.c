// @original author : Rudy Nurhady
// @updated by      : Rafi Kurnia Putra
// @date            : 22 Maret 2015

#include "main.h"
#include "jalanDasar.h"
#include "uart.h"


void print(uint8_t move, int speed) {
  static uint8_t oldmove, oldSpeed;
  char tempChar[30] = "";
  move--;
  if (oldmove != move || oldSpeed != speed) {
    sprintf (tempChar, "*%d,%d.#", move, speed);
    uartPrintf(COM3, tempChar);
    oldmove = move;
  }
}

void stopMove() {
  uartPrintf(COM3, "*S#");
  Delayms(25);
}

void normal() {
  uartPrintf(COM3, "*N#");
}

void maju1(int speed) {
  print(2, speed);
}

void maju2(int speed) {
  print(3, speed);
}

void maju3(int speed) {
  print(4, speed);
}

void maju4(int speed) {
  print(5, speed);
}

void majuBebas(int speed, int delay){
	maju3(speed);
	Delayms(delay);
	stopMove();
	normal();
}

void mundur1(int speed) {
  print(1, -speed);
}

void mundur2(int speed) {
  print(2, -speed);
}

void mundur3(int speed) {
  print(3, -speed);
}

void mundur4(int speed) {
  print(4, -speed);
}

void belokKanan10(int speed) {
  print(6, speed);
}

void belokKanan20(int speed) {
  print(7, speed);
}

void belokKanan30(int speed) {
  print(8, speed);
}

void belokKanan40(int speed) {
  print(9, speed);
}

void belokKanan21(int speed) {
  print(10, speed);
}

void belokKanan31(int speed) {
  print(11, speed);
}

void belokKanan41(int speed) {
  print(12, speed);
}

void belokKanan32(int speed) {
  print(13, speed);
}

void belokKanan42(int speed) {
  print(14, speed);
}

void belokKanan43(int speed) {
  print(15, speed);
}

void belokKiri01(int speed) {
  print(16, speed);
}

void belokKiri02(int speed) {
  print(17, speed);
}

void belokKiri03(int speed) {
  print(18, speed);
}

void belokKiri04(int speed) {
  print(19, speed);
}

void belokKiri12(int speed) {
  print(20, speed);
}

void belokKiri13(int speed) {
  print(21, speed);
}

void belokKiri14(int speed) {
  print(22, speed);
}

void belokKiri23(int speed) {
  print(23, speed);
}

void belokKiri24(int speed) {
  print(24, speed);
}

void belokKiri34(int speed) {
  print(25, speed);
}

void putarKanan1(int speed) {
  print(26, speed);
}

void putarKanan3(int speed) {
  print(27, speed);
}

void putarKanan5(int speed) {
  print(28, speed);
}

void putarKanan7(int speed) {
  print(29, speed);
}

void putarKanan10(int speed) {
  print(30, speed);
}

void putarKanan15(int speed) {
  print(31, speed);
}

void putarKanan30(int speed) {
  print(32, speed);
}

void putarKanan45(int speed) {
  print(33, speed);
}

void putarKanan50(int speed) {
  print(34, speed);
}


void putarKiri1(int speed) {
  print(27, -speed);
}

void putarKiri3(int speed) {
  print(27, -speed);
}

void putarKiri5(int speed) {
  print(28, -speed);
}

void putarKiri7(int speed) {
  print(29, -speed);
}

void putarKiri10(int speed) {
  print(30, -speed);
}

void putarKiri15(int speed) {
  print(31, -speed);
}

void putarKiri30(int speed) {
  print(32, -speed);
}

void putarKiri45(int speed) {
  print(33, -speed);
}

void putarKiri50(int speed) {
  print(34, -speed);
}

//void serongKanan15(int speed) {
//  print(44, speed);
//}
//
//void serongKanan25(int speed) {
//  print(45, speed);
//}
//
//void serongKanan35(int speed) {
//  print(46, speed);
//}
//
//void serongKanan45(int speed) {
//  print(47, speed);
//}
//
//void serongKanan11(int speed) {
//  print(48, speed);
//}
//
//void serongKanan21(int speed) {
//  print(49, speed);
//}
//
//void serongKanan31(int speed) {
//  print(50, speed);
//}
//
//void serongKanan41(int speed) {
//  print(51, speed);
//}
//
//void serongKiri15(int speed) {
//  print(52, speed);
//}
//
//void serongKiri25(int speed) {
//  print(53, speed);
//}
//
//void serongKiri35(int speed) {
//  print(54, speed);
//}
//
//void serongKiri45(int speed) {
//  print(55, speed);
//}
//
//void serongKiri11(int speed) {
//  print(56, speed);
//}
//
//void serongKiri21(int speed) {
//  print(57, speed);
//}
//
//void serongKiri31(int speed) {
//  print(58, speed);
//}
//
//void serongKiri41(int speed) {
//  print(59, speed);
//}

void geserKanan1(int speed) {
  print(35, speed);
}

void geserKanan2(int speed) {
  print(36, speed);
}

void geserKanan3(int speed) {
  print(37, speed);
}

void geserKanan4(int speed) {
  print(38, speed);
}

void geserKiri1(int speed) {
  print(35, -speed);
}

void geserKiri2(int speed) {
  print(36, -speed);
}

void geserKiri3(int speed) {
  print(37, -speed);
}

void geserKiri4(int speed) {
  print(38, -speed);
}

void putarKiri90(){
	putarKiri45(100);
	Delayms(550);
	stopMove();
	normal();
}

void putarKanan90(){
	putarKanan45(100);
	Delayms(500);
	stopMove();
	normal();
}

void putarKiri180(){
	putarKiri45(100);
	Delayms(900);
	stopMove();
	normal();
}

void putarKanan180(){
	putarKanan45(100);
	Delayms(900);
	stopMove();
	normal();
}
//
//void findingTheFire(int speed) {
//  print(67, speed);
//}
//
//void dance(int speed) {
//  print(68, speed);
//}
//
//void nungging1(int speed) {
//  print(69, speed);
//}
//
//void nungging2(int speed) {
//  print(70, speed);
//}
//
//void nungging3(int speed) {
//  print(71, speed);
//}
//
//void nungging4(int speed) {
//  print(72, speed);
//}
//
//void nungging5(int speed) {
//  print(73, speed);
//}
