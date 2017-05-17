#include "i2c.h"
#include "wallFollowingKiri.h"
#include "wallFollowing.h"
#include "wallFollowingKanan.h"

/*masih sketsa awal*/

void lorongDepanToRoom3Merah() {
	kanan(WFTYPE_WHITE);
	majuBebas(SPEED,1000);
	rataKiri();
}

void lorongSampingToRoom1Merah() {
	kiri(WFTYPE_WHITE);
	majuBebas(SPEED,1000);
	rataKiri();
}

void room3KeRoom2Merah() {
	putarKiri90();
	kanan(WFTYPE_WHITE);
	rataKiri();
	majuBebas(SPEED,1000);
}

void room3KeRoom1Merah() {
	putarKiri90();
	kanan(WFTYPE_GREY);
	kanan(WFTYPE_BLACK);
	kiri(WFTYPE_WHITE);
	rataKanan();
	majuBebas(SPEED,1000);
}

void room3ToRoom4Merah(){
	putarKiri90();
	rataKanan();
	kanan(WFTYPE_3TO4);
	majuBebas(SPEED,1000);
	rataKanan();
	putarKiri90();
	majuBebas(SPEED,1000);
	rataKiri();
}

//void room2ToRoom1aMerah(){
//	kanan();
//	majuBebas(SPEED,1000);
//	rataKanan();
//}
void room2ToRoom3Merah() {
	putarKiri90();
	majuBebas(SPEED,1000);
	kiri(WFTYPE_BLACK);
	kanan(WFTYPE_WHITE);
	majuBebas(SPEED,1000);
	rataKiri();
}

void room2ToRoom4Merah() {
	putarKiri90();
	majuBebas(SPEED,1000);
	kanan(WFTYPE_BLACK);
	majuBebas(SPEED,1000);
	rataKanan();
	putarKiri90();
	majuBebas(SPEED,1000);
	rataKiri();
	majuBebas(SPEED,1000);
}

void room1aToRoom2Merah(){
	kiri(WFTYPE_WHITE);
	rataKiri();
	majuBebas(SPEED,1000);
}

void room1aToRoom3Merah(){
	putarKanan90();
	majuBebas(SPEED,1000);
	kiri(WFTYPE_BLACK); //sampai karpet hitam
	kanan(WFTYPE_WHITE);
	majuBebas(SPEED, 1000);
}

void room1aToRoom4Merah(){
	putarKanan90();
	majuBebas(SPEED, 1000);
	kanan(WFTYPE_BLACK);
	majuBebas(SPEED, 1000);
	rataKanan();
	putarKiri90();
	majuBebas(SPEED, 1000);
}



void room1cToRoom1aMerah() {
	kiriRoom(2);
	rataKiri();
	maju(95);
	Delayms(1000);
	stopMove();
	normal();
}

void room1cToRoom4Merah() {
	putarKiri90();
	majuBebas(SPEED,1000);
	kanan(WFTYPE_WHITE);
	majuBebas(SPEED,1000);
	rataKiri();
}

void room4ToRoom3Merah() {
	putarKanan90();
	rataKiri();
	kiri(WFTYPE_4TO3);
	kanan(WFTYPE_WHITE);
	majuBebas(SPEED,1000);
	rataKiri();
}

void room4ToRoom2Merah() {
	putarKanan90();
	kiri(WFTYPE_GREY);
	kiri(WFTYPE_BLACK);
	kanan(WFTYPE_WHITE);
	rataKiri();
	majuBebas(SPEED, 1000);
}

void room4ToRoom1Merah() {
	putarKanan90();
	kiri(WFTYPE_WHITE);
	rataKanan();
	majuBebas(SPEED, 1000);
}




