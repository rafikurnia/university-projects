/*
  EthernetHandling.ino - EMBEDDED YOA !
  Taken from example UDPSendReceive.pde
  Created by Michael Margolis. Aug 21, 2010.
  Modified for Intel Galileo - dino.tinitigan@intel.com
  Edited by Rafi Kurnia Putra. May 3, 2015.
  Embedded System Project 2015
*/

byte macAddr[] = {0x98, 0x4F, 0xEE, 0x00, 0x0A, 0xD7};
unsigned int localPort = 8888;

void initEthernet() {
  EthernetShield.begin(macAddr, ipAddr);
  packetUDP.begin(localPort);
}

void sendPacket() {
  packetUDP.beginPacket("192.168.1.177", 8888);
  packetUDP.write("WAKE UP");
  packetUDP.endPacket();
}
