/*
  LedHandling.ino - EMBEDDED YOA !
  Created by Rafi Kurnia Putra. May 3, 2015.
  Embedded System Project 2015
*/

void setLed(int level) {
  int i;
  if (level > 6) level = 6;
  else if (level < 0) level = 0;

  for (i = 0; i < 6; i++) {
    switch (level) {
      case 0:
        led[i]->turnOff();
        break;
      case 1:
        if (i > 0) led[i]->turnOff();
        else led[i]->turnOn();
        break;
      case 2:
        if (i > 1) led[i]->turnOff();
        else led[i]->turnOn();
        break;
      case 3:
        if (i > 2) led[i]->turnOff();
        else led[i]->turnOn();
        break;
      case 4:
        if (i > 3) led[i]->turnOff();
        else led[i]->turnOn();
        break;
      case 5:
        if (i > 4) led[i]->turnOff();
        else led[i]->turnOn();
        break;
      case 6:
        led[i]->turnOn();
        break;
    }
  }
}
