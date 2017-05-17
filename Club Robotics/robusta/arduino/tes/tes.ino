// This sketch code is based on the RPLIDAR driver library provided by RoboPeak
#include <RPLidar.h>
#include <SimpleTimer.h>

#define stm Serial3
#define ssc Serial2
#define pc Serial

// the timer object
SimpleTimer timer;
// You need to create an driver instance
RPLidar lidar;

String inputString = "", seq, kec, oldseq = "-1", oldkec;        // a string to hold incoming data
boolean stringComplete = false, scan = false, start = false, ticking = false, step_ready = false; // whether the string is complete
int data[360], timerID;
int n = -1, other = 1;
unsigned short qseq, ix, time;


#define RPLIDAR_MOTOR 3 // The PWM pin for control the speed of RPLIDAR's motor.
// This pin should connected with the RPLIDAR's MOTOCTRL signal

void repeatMe() {
  digitalWrite(8, HIGH);
}

void setup() {
  // bind the RPLIDAR driver to the arduino hardware serial
  lidar.begin(Serial1);
  // initialize serial:
  stm.begin(115200);
  ssc.begin(115200);
  Serial.begin(115200);
  pinMode(RPLIDAR_MOTOR, OUTPUT);
  pinMode(8, OUTPUT);
  digitalWrite(8, LOW);
  oldseq = "-1";
  ssc.println("PL 0 SQ 0 IX 0 SM 100\r");
}

void loop() {
  if (stringComplete) {
    //    pc.println(inputString);
    if (inputString == "scan") {
      scan = true;
      stringComplete = false;
      inputString = "";
    }
    else if (inputString == "start") {
      start = true;
      stringComplete = false;
      inputString = "";
    }
    else if (inputString == "stop") {
      start = false;
      stringComplete = false;
      inputString = "";
    }
    else if (inputString == "S") { // stop move
      ssc.println("PL 0\r");
      ssc.println("PL 1\r");
      stringComplete = false;
      inputString = "";
      other = 1;
      oldseq = "-1";
    }
    else if (inputString == "N") { // normal
      ssc.println("PL 0 SQ 0 SM 100\r");
      stringComplete = false;
      inputString = "";
      other = 1;
      oldseq = "-1";
    }
    else {
//      unsigned short arrByte[4];
//      ssc.print("QPL 0\r");
//      if (seq != oldseq || kec != oldkec || oldseq == "-1") {
//        while (ssc.available()) {
//          for (int i = 0; i < 4; i++) {
//            int intByte = ssc.read();
//            arrByte[i] = intByte;
//          }
//          if((arrByte[2] == 1) || (arrByte[2] == 3) && arrByte[3] == 0) break;
//        }
//        pc.println("haai");
//        qseq = arrByte[0];
//        ix = arrByte[2];
//        time = arrByte[3];
//        if (( ((ix == 1) || (ix == 3)) && (time == 0)) || qseq == 0 || oldseq == "-1") {
          ssc.print("PL 0 SQ ");
          ssc.print(seq);
          ssc.print(" SM ");
          ssc.print(kec);
          ssc.println("\r");
          pc.print("PL 0 SQ ");
          pc.print(seq);
          pc.print(" SM ");
          pc.print(kec);
          pc.println();
          oldseq = seq;
          oldkec = kec;
          step_ready = false;
          stringComplete = false;
          inputString = "";
//        }

    }
  }
  if (start) {
    int qual[360];
    byte oldQual;
    int oldAngle = 0;
    if (IS_OK(lidar.waitPoint())) {
      if (scan) {
        float distance = lidar.getCurrentPoint().distance; //distance value in mm unit
        float angle    = lidar.getCurrentPoint().angle; //anglue value in degree
        bool  startBit = lidar.getCurrentPoint().startBit; //whether this point is belong to a new scan
        byte  quality  = lidar.getCurrentPoint().quality; //quality of the current measurement
        int angleInt = (int) angle;
        if ((oldAngle == angleInt && oldQual < quality) || oldAngle != angleInt ) {
          data[angleInt] = distance;
          qual[angleInt] = quality;
          oldAngle = angleInt;
          oldQual = quality;
        }
        if (!ticking) {
          ticking = true;
          timerID = timer.setTimeout(500, repeatMe);
          timer.restartTimer(timerID);
        }
        else if (digitalRead(8) == HIGH) {
          int i;
          char temp[15];
          for (i = 0; i < 360; i++) {
            int tempInt = data[i];
            sprintf(temp, "*%03d%04dx", i, tempInt);
            stm.println(temp);
            stm.flush();
            pc.println(data[i]);
          }
          for (i = 0; i < 360; i++) {
            pc.print (i);
            pc.print(" ");
            pc.println(data[i]);

          }
          stm.println("yyyyyyyyy");
          pc.println("____");
          int n = 0, pos = -1, delta;
          int count = 0;
          bool lilin = false;
          pc.print("====");
          pc.println(pos);
          digitalWrite(8, LOW);
          scan = false;
        }
        else timer.run();
      }
      else ticking = false;

      //perform data processing here...

    } else {
      pc.println("fuuu");
      analogWrite(RPLIDAR_MOTOR, 0); //stop the rplidar motor

      // try to detect RPLIDAR...
      rplidar_response_device_info_t info;
      if (IS_OK(lidar.getDeviceInfo(info, 100))) {
        // detected...
        lidar.startScan();

        // start motor rotating at max allowed speed
        analogWrite(RPLIDAR_MOTOR, 255);
        delay(1000);
      }
    }
  }
}
void serialEvent3() // tunggu data dari stm
{
  while (stm.available()) {
    char inChar = (char)stm.read();
    if (inChar == '*') { // * sebagai start bit
      inputString = "";
    }
    else if (inChar == ',') { // kalo ada , berati sequence
      seq = inputString;
      pc.println(inputString);
      inputString = "";
    }
    else if (inChar == '.') { // kalo ada . berarti kecepatan
      kec = inputString;
      pc.println(inputString);
      inputString = "";
    }
    else if (inChar == '#') { // # sebagai stop bit
      stringComplete = true;
      //      Serial.println(inputString);  // jadi kalau mau kirim sesuatu
    }                         // dari stm tinggal kirim *sesuatu#
    // contoh : *start#
    else inputString += inChar;
  }
}


