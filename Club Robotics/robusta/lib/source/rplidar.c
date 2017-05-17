#include "rplidar.h"
#include "main.h"
#include "uart.h"

char buf[RX_BUF_SIZE];
char oldBuf[RX_BUF_SIZE];

int data[360];
int delta2 = 0;
int beda[180];
int here = 0;
int side[4];
int room = 0;
int la, maxKanan, maxKiri;
unsigned long luasKiri, luasKanan;
int belakang, depan, kiriL, kananL, kiriI, kananN;

int const ROOM_1A_MERAH = 1;
int const ROOM_1C_MERAH = 2;
int const ROOM_2_MERAH = 3;
int const ROOM_3_MERAH = 4;
int const ROOM_4_MERAH = 5;

int const ROOM_1A_BIRU = 6;
int const ROOM_1C_BIRU = 7;
int const ROOM_2_BIRU = 8;
int const ROOM_3_BIRU = 9;
int const ROOM_4_BIRU = 10;

int const RATA_KANAN = 1;
int const RATA_KIRI = 6;
int const MERAH = 0;
int const BIRU = 5;

int const DEPAN = 1;
int const KIRIBELAKANG = 2;
int const KANANBELAKANG = 3;

int const RANDOM = 4;

bool cekRuang(int a, int b, int p, int l) {
	int max = 1600;
	bool stat = false;
	if (a == -1) {
		if (a > max) {
			stat = true;
		}
	} else {
		if (a < p + 30 && a > p - 30) {
			stat = true;
		}
	}
	if (b == -1 && b > max) {
		stat = stat && true;
	} else if (b < l + 30 && b > l - 30) {
		stat = stat && true;
	} else
		stat = false;

	if (a > b) {
		return stat || cekRuang(b, a, p, l);
	} else {
		return stat;
	}
}

void LidarInit() {
	uartPrintf(COM3, "*start#");
}
//
//void LidarScan1() {
//	uartPrintf(COM3, "*scan#");
//	char tempChar[10];
//	bool done = false;
//	int index = 0;
//	while (1) {
//		do {
//			uartGets(COM3, buf);
//		} while (!(buf[0] == '*' && buf[8] == 'x'));
//		index = charToInt(buf, 1, 3);
//		data[index] = (charToInt(buf, 4, 7));
//		memset(&buf[0], 0, sizeof(buf));
//		if (index == 359) {
//			break;
//		}
//	}
//	int i;
//	for (i = 0; i < 4; i++)
//		side[i] = 0;
//	i = 0;
//	int n = -15, tol = 0;
//	int count = 0;
//	int minimum = 0, minDeg = 0;
//	int maximum = 0;
//	int lastDeg = 360;
//	bool minus = false;
//	bool plus = false;
//	bool decreasing = false;
//	bool unidentified = false;
//	bool otherObject[360];
//	while (n < 375) {
//		if (n < 0) {
//			minus = true;
//			n += 360;
//		}
//		if (n > 359) {
//			plus = true;
//			n -= 360;
//		}
//		if (data[n] != 0) {
//			if (!decreasing) {
//				if (maximum <= data[n]) {
//					count = 0;
//					maximum = data[n];
//				} else
//					count++;
//				if (count == 10) {
//					decreasing = true;
//					minimum = data[n];
//					count = 0;
//				}
//			}
//			if (decreasing) {
//				if (minimum >= data[n]) {
//					minimum = data[n];
//					minDeg = n;
//					count = 0;
//				} else
//					count++;
//				if (count == 10) {
//					decreasing = false;
//					maximum = data[n];
//					side[i] = minDeg;
//					i++;
//					if (plus && i == 4)
//						break;
//					count = 0;
//				}
//			}
//			delta[n] = data[n] - data[lastDeg];
//			delta[n] = abs(delta[n]);
//			if (delta[n] > 30)
//				unidentified = !unidentified;
//			lastDeg = n;
//		} else
//			delta[n] = -1;
//		otherObject[n] = unidentified;
//		if (minus) {
//			minus = false;
//			n -= 359;
//			continue;
//		}
//		if (plus) {
//			plus = false;
//			n += 361;
//			continue;
//		}
//		n++;
//	}
//}

int ScanLilin(int type) {
	int n = 0, pos = -1;
	if (type == ROOM_3_BIRU || type == ROOM_3_MERAH) {
		int count = 0;
		bool lilin = false;
		for (n = 90; n < 270; n++) {
			int x = n - 1;
			if (data[n] == 0)
				continue;
			while (data[x] == 0) {
				x -= 1;
			}
			beda[n - 90] = data[x] - data[n];
			if (count > 2) {
				lilin = false;
				count = 0;
				delta2 = 0;
				pos = n;
				here = 2;
			} else if (lilin) {
				if ((data[n] - data[x]) < (delta2 + 30)
						&& (data[n] - data[x]) > (delta2 - 30)) {
					lilin = false;
					pos = n;
					here = data[n] - data[x];
					break;
				}
				count += 1;
			} else if (data[x] - data[n] > 100
					&& data[x] - data[x - 1] < 1000) {
				if (data[x] - data[n] < 200) {
					delta2 = data[x] - data[n];
				} else
					delta2 = -1000;

				lilin = true;
				here = 3;
			}
		}
	}
	return pos;
}
int LidarRoom(int type) {
	int index = 0, ruang = 0, n;
	LidarScan();
	if (type == MERAH || type == BIRU) { //deteksi dari luar, udah ketauan biru atau merah
		int warna = 0;
		belakang = rangeMax(0);
		depan = rangeMin(180);
		kiriL = rangeMax(90);
		kananL = rangeMax(270);
		if (belakang + depan > 1500) { //kalau belakang jauh
			if (warna == 0) {
				if (kiriL > kananL) {
					if (type == MERAH) {
						la = 1;
						return ROOM_1A_MERAH;
					} else {
						la = 2;
						return ROOM_1C_BIRU;
					}
				} else {
					if (type == MERAH) {
						la = 3;
						return ROOM_1C_MERAH;
					} else {
						la = 4;
						return ROOM_1A_BIRU;
					}
				}
			} else {
				la = 5;
				return ROOM_2_MERAH + type;
			}
		} else {
			int max = 0;
			for (index = 90; index < 270; index++) {
				if (data[index] > max && data[index] - data[index - 1] < 1000
						&& data[index] - data[index + 1] < 1000)
					max = data[index];
			}
			if (max > 780 || depan + belakang > 1000) {
				la = 6;
				return ROOM_3_MERAH + type;
			} else {
				la = 7;
				return ROOM_4_MERAH + type;
			}
		}
	} else if (type == RATA_KIRI || type == RATA_KANAN) { //type 2 buat yang rata kiri, type 3 buat yang rata kananL
		int warna = 0;
		belakang = rangeMin(0);
		kiriL = rangeMax(90);
		kananL = rangeMax(270);
		depan = rangeMax(180);

		if (depan + belakang > 1500) {
			if (type == RATA_KIRI) {
				la = 8;
				if (kananL > 1000) {
					return ROOM_1C_BIRU;
				} else {
					return ROOM_1A_MERAH;
				}
			} else {
				la = 9;
				if (kiriL > 1000) {
					return ROOM_1C_MERAH;
				} else {
					return ROOM_1A_BIRU;
				}
			}
		} else {
			int max = 0;
			for (index = -90; index < 90; index++) { //ubah lagi
				int m = index;
				if (m < 0)
					m += 180;
				if (data[m] > max && data[m] - data[m - 1] < 1000
						&& data[m] - data[m + 1] < 1000) {
					max = data[m];
				}
			}
			if (max > 780 || belakang + depan > 1000) {
				la = 10;
				return ROOM_3_MERAH + type - 1;
			} else
				la = 11;
			return ROOM_4_MERAH + type - 1;
		}
	} else {
		int warna = 0;
		belakang = rangeMin(0);
		kiriL = rangeMax(90);
		kananL = rangeMax(270);
		depan = rangeMax(180);
		luasKiri = 0;
		for (n = 0; n < 90; n++) {
			if (!(data[n] - data[n + 1] > 1000 && data[n] - data[n + 1] > 1000)) {
				luasKiri += data[n];
			}
		}
		luasKanan = 0;
		for (n = 270; n < 360; n++) {
			if (!(data[n] - data[n + 1] > 1000 && data[n] - data[n + 1] > 1000)) {
				luasKanan += data[n];
			}
		}
		maxKanan = max(KANANBELAKANG);
		maxKiri = max(KIRIBELAKANG);

		if (depan + belakang > 1500 || depan > 1000) {
			if (luasKanan > luasKiri) {
				la = 8;
				if (kananL > 1000 || depan > 1530) {
					return ROOM_1C_BIRU;
				} else {
					return ROOM_1A_MERAH;
				}
			} else {
				la = 9;
				if (kiriL > 1000 || depan > 1530) {
					return ROOM_1C_MERAH;
				} else {
					return ROOM_1A_BIRU;
				}
			}
		} else {
			int max = 0;
			for (index = -90; index < 90; index++) { //ubah lagi
				int m = index;
				if (m < 0)
					m += 180;
				if (data[m] > max && data[m] - data[m - 1] < 1000
						&& data[m] - data[m + 1] < 1000) {
					max = data[m];
				}
			}
			if (max > 780 || belakang + depan > 1000) {
				la = 15;
				if (luasKanan > luasKiri){
					la = 100;
					return ROOM_3_BIRU;
				}
				else
					return ROOM_3_MERAH;
			} else {
				la = 11;
				if (luasKanan > luasKiri)
					return ROOM_4_BIRU;
				else
					return ROOM_4_MERAH;
			}
		}
	}
}

int LidarRoom1(int type) {
	int index = 0, ruang = 0, n;
	LidarScan();
	if (type == MERAH || type == BIRU) { //deteksi dari luar, udah ketauan biru atau merah
		int warna = 0;
		belakang = rangeMax(0);
		depan = rangeMin(180);
		kiriL = rangeMax(90);
		kananL = rangeMax(270);
		if (belakang + depan > 1500) { //kalau belakang jauh
			if (warna == 0) {
				if (kiriL > kananL) {
					if (type == MERAH) {
						la = 1;
						return ROOM_1A_MERAH;
					} else {
						la = 2;
						return ROOM_1C_BIRU;
					}
				} else {
					if (type == MERAH) {
						la = 3;
						return ROOM_1C_MERAH;
					} else {
						la = 4;
						return ROOM_1A_BIRU;
					}
				}
			} else {
				la = 5;
				return ROOM_2_MERAH + type;
			}
		} else {
			int max = 0;
			for (index = 90; index < 270; index++) {
				if (data[index] > max && data[index] - data[index - 1] < 1000
						&& data[index] - data[index + 1] < 1000)
					max = data[index];
			}
			if (max > 780 || depan + belakang > 1000) {
				la = 6;
				return ROOM_3_MERAH + type;
			} else {
				la = 7;
				return ROOM_4_MERAH + type;
			}
		}
	} else if (type == RATA_KIRI || type == RATA_KANAN) { //type 2 buat yang rata kiri, type 3 buat yang rata kananL
		int warna = 0;
		belakang = rangeMin(0);
		kiriL = rangeMax(90);
		kananL = rangeMax(270);
		depan = rangeMax(180);

		if (depan + belakang > 1500) {
			if (type == RATA_KIRI) {
				la = 8;
				if (kananL > 1000) {
					return ROOM_1C_BIRU;
				} else {
					return ROOM_1A_MERAH;
				}
			} else {
				la = 9;
				if (kiriL > 1000) {
					return ROOM_1C_MERAH;
				} else {
					return ROOM_1A_BIRU;
				}
			}
		} else {
			int max = 0;
			for (index = -90; index < 90; index++) { //ubah lagi
				int m = index;
				if (m < 0)
					m += 180;
				if (data[m] > max && data[m] - data[m - 1] < 1000
						&& data[m] - data[m + 1] < 1000) {
					max = data[m];
				}
			}
			if (max > 780 || belakang + depan > 1000) {
				la = 10;
				return ROOM_3_MERAH + type - 1;
			} else
				la = 11;
			return ROOM_4_MERAH + type - 1;
		}
	} else {
		int warna = 0;
		belakang = rangeMin(0);
		kiriL = rangeMax(90);
		kananL = rangeMax(270);
		depan = rangeMax(180);
		luasKiri = 0;
		for (n = 0; n < 90; n++) {
			if (!(data[n] - data[n + 1] > 1000 && data[n] - data[n + 1] > 1000)) {
				luasKiri += data[n];
			}
		}
		luasKanan = 0;
		for (n = 270; n < 360; n++) {
			if (!(data[n] - data[n + 1] > 1000 && data[n] - data[n + 1] > 1000)) {
				luasKanan += data[n];
			}
		}
		maxKanan = max(KANANBELAKANG);
		maxKiri = max(KIRIBELAKANG);

		if (depan + belakang > 1500 || depan > 1000) {
			if (luasKanan > luasKiri) {
				la = 8;
				if (kananL > 1000 || depan > 1530) {
					return ROOM_1C_BIRU;
				} else {
					return ROOM_1A_MERAH;
				}
			} else {
				la = 9;
				if (kiriL > 1000 || depan > 1530) {
					return ROOM_1C_MERAH;
				} else {
					return ROOM_1A_BIRU;
				}
			}
		} else {
			int max = 0;
			for (index = -90; index < 90; index++) { //ubah lagi
				int m = index;
				if (m < 0)
					m += 180;
				if (data[m] > max && data[m] - data[m - 1] < 1000
						&& data[m] - data[m + 1] < 1000) {
					max = data[m];
				}
			}
			if (max > 780 || belakang + depan > 1000) {
				la = 15;
				if (luasKanan > luasKiri){
					la = 100;
					return ROOM_3_BIRU;
				}
				else
					return ROOM_3_MERAH;
			} else {
				la = 11;
				if (luasKanan > luasKiri)
					return ROOM_4_BIRU;
				else
					return ROOM_4_MERAH;
			}
		}
	}
}


void LidarScan() {
	int index = 0, ruang = 0, n;
	for (n = 0; n < 360; n++) {
		data[n] = -1;
	}
	memset(&buf[0], 0, sizeof(buf));
	uartPrintf(COM3, "*scan#");
	char tempChar[10];
	bool done = false;
	bool error = false;
	while (1) {
		do {
			uartGets(COM3, buf);
			if (buf[0] == 'y') {
				done = true;
				break;
			}
		} while (!(buf[0] == '*' && buf[8] == 'x'));
		if (done)
			break;
		for (n = 1; n < 8; n++) {
			if (buf[n] > 57 || buf[n] < 48) {
				error = true;
				break;
			}
		}
		index = charToInt(buf, 1, 3);
		data[index] = (charToInt(buf, 4, 7));
		memset(&buf[0], 0, sizeof(buf));
		if (index == 359) {
			break;
		}
	}
	for (n = 0; n < 360; n++) {
		if (data[n] == -1)
			data[n] = -2;
	}
}

int rangeMax(int sudut) {
	int tol = 3, n;
	int result = 0;
	for (n = sudut - tol; n <= sudut + tol; n++) {
		int m = n;
		if (m < 0)
			m += 180;
		if (data[m] > result && data[m] != 0) {
			result = data[m];
		}
	}
	return result;
}
int rangeMin(int sudut) {
	int tol = 3, n;
	int result = 30000;
	for (n = sudut - tol; n <= sudut + tol; n++) {
		int m = n;
		if (m < 0)
			m += 180;
		if (data[m] < result && data[m] != 0) {
			result = data[m];
		}
	}
	return result;
}

int max(int type) {
	int index, max = 0;
	if (type == KIRIBELAKANG) {
		for (index = 0; index < 90; index++) { //ubah lagi
			int m = index;
			if (m < 0)
				m += 180;
			if (data[m] > max && data[m] - data[m - 1] < 1000
					&& data[m] - data[m + 1] < 1000) {
				max = data[m];
			}
		}
	} else if (type = KANANBELAKANG) {
		for (index = 270; index < 360; index++) { //ubah lagi
			int m = index;
			if (m < 0)
				m += 180;
			if (data[m] > max && data[m] - data[m - 1] < 1000
					&& data[m] - data[m + 1] < 1000) {
				max = data[m];
			}
		}
	}
	return max;

}
