#ifndef _RPLIDAR_H_
#define _RPLIDAR_H_

void LidarInit();
void LidarScan();
int LidarRoom(int type);

extern int data[360];
//extern int delta[360];
extern int side[4];
extern int room;

extern int const ROOM_1A_MERAH;
extern int const ROOM_1C_MERAH;
extern int const ROOM_2_MERAH;
extern int const ROOM_3_MERAH;
extern int const ROOM_4_MERAH;

extern int const ROOM_1A_BIRU;
extern int const ROOM_1C_BIRU;
extern int const ROOM_2_BIRU;
extern int const ROOM_3_BIRU;
extern int const ROOM_4_BIRU;

extern int const RATA_KANAN;
extern int const RATA_KIRI;
extern int const MERAH;
extern int const BIRU;

#endif
