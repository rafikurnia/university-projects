// This sketch code is based on the RPLIDAR driver library provided by RoboPeak
#include <RPLidar.h>
#include <SimpleTimer.h>

#define stm Serial1
#define ssc Serial2

// the timer object
SimpleTimer timer;
// You need to create an driver instance
RPLidar lidar;

String inputString = "", seq, kec;        // a string to hold incoming data
boolean stringComplete = false, scan = false, start = false, ticking = false, step_ready = true; // whether the string is complete
int data[360], timerID;
int n = -1, qseq, ix;


#define RPLIDAR_MOTOR 3 // The PWM pin for control the speed of RPLIDAR's motor.
// This pin should connected with the RPLIDAR's MOTOCTRL signal

void repeatMe() {
  digitalWrite(8, HIGH);
}

void setup() {
  // bind the RPLIDAR driver to the arduino hardware serial
  //lidar.begin(Serial3);
  // initialize serial:
  stm.begin(115200);
  ssc.begin(115200);
  Serial.begin(115200);
  pinMode(RPLIDAR_MOTOR, OUTPUT);
  pinMode(8, OUTPUT);
  digitalWrite(8, LOW);
  ssc.println("PL 0 SQ 0 IX 0 SM 100\r");
  delay(100);
}

void loop() {
  if (stringComplete) {
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
      ssc.println("PL 0 SQ 0 IX 0 SM 100\r");
      stringComplete = false;
      inputString = "";
    }
    else if (inputString == "N") { // normal
      ssc.println("PL 0 SQ 0 \r");
      Serial.println("PL 0 SQ 0 \r");
      stringComplete = false;
      inputString = "";
    }
    else {
      if (step_ready) {
        ssc.print("PL 0 SQ ");
        ssc.print(seq);
        ssc.print(" SM ");
        ssc.print(kec);
        ssc.println("\r");
//        Serial.print("PL 0 SQ ");
//        Serial.print(seq);
//        Serial.print(" SM ");
//        Serial.print(kec);
//        Serial.println("\r");
        step_ready = false;
        stringComplete = false;
        inputString = "";
      }
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
          }
          stm.println("yyyyy");
          digitalWrite(8, LOW);
          scan = false;
        }
        else timer.run();
      }
      else ticking = false;

      //perform data processing here...

    } else {
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
  wait();
  //delay(10);
}

void qpl() {
  int arrByte[5];
  ssc.print("QPL 0\r");
  while (ssc.available()) {
    for (int i = 0; i < 4; i++) {
      int intByte = ssc.read();
      arrByte[i] = intByte;
//      Serial.print(arrByte[i]);
//      Serial.print(",");
    }
    //break;
  }
  //Serial.println(" ");
  qseq = arrByte[0];
  ix = arrByte[1];
}

void wait() {
  qpl();
  if ( ((ix == 1) || (ix == 3))) {
    if (ix == 3) ix = 0;
    else ix = 2;
    step_ready = true;
  }
  else if ((qseq == 0) || (qseq == 18)) {
    ix = 0;
    step_ready = true;
  }
}

//int charToInt(char c[], int firstComp, int lastComp) {
//  int i, j, result = 0, ten;
//  for (i = firstComp; i <= lastComp; i++) {
//    ten = 1;
//    if (c[i] < 48 || c[i] > 57) return 0;
//    for (j = i; j < lastComp; j++) {
//      ten *= 10;
//    }
//    result += (c[i] - 48) * ten;
//  }
//  return result;
//}

void serialEvent1() // tunggu data dari stm
{
  while (stm.available()) {
    char inChar = (char)stm.read();
    if (inChar == '*') { // * sebagai start bit
      inputString = "";
    }
    else if (inChar == ',') { // kalo ada , berati sequence
      seq = inputString;
      inputString = "";
    }
    else if (inChar == '.') { // kalo ada . berarti kecepatan
      kec = inputString;
      inputString = "";
    }
    else if (inChar == '#') { // # sebagai stop bit
      stringComplete = true;
      Serial.println(inputString);  // jadi kalau mau kirim sesuatu
  }                         // dari stm tinggal kirim *sesuatu#
    // contoh : *start#
    else inputString += inChar;
  }
}

