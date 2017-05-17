#include "wallFollowingKiri.h"
#include "jalanDasar.h"
#include "wallFollowingKanan.h"
#include "i2c.h"
#include "main.h"
#include "rplidar.h"


int sonar[8];

int inisiasi() {
	uint8_t snrFr;
	uint8_t snrL2;
	uint8_t snrLDg;
	uint8_t snrRDg;
	uint8_t snrL1;
	uint8_t snrR1;
	uint8_t snrR2;
	const int ping[8] = { 0xE0, 0xE2, 0xE4, 0xE6, 0xE8, 0xEA, 0xEC, 0xEE };
	uint8_t i;
	for (i = 0; i < 8; i++) {
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
	normal();
	if (snrL1 > 47 || snrL2 > 47) {
		rataKanan();
		putarKiri180();
	} else {
		rataKiri();
	}
	short rata = kiri(WFTYPE_INIT);
	if (rata == 1) {
		putarKiri90();
		rataKanan();
		int room = LidarRoom(RATA_KANAN);
		return room;
	} else {
		rataKiri();
		int room = LidarRoom(RATA_KIRI);
		return room;
	}
}
