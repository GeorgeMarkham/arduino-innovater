#include <SoftwareSerial.h>

SoftwareSerial bt_serial(2, 4); // RX, TX  WAS (7,8)
// RX on HM10 to TX (pin 4) on Arduino
// TX on HM10 to RX (pin 2) on Arduino


void setup() {
  // Set baud rate on BT and Serial output
  Serial.begin(9600);
  bt_serial.begin(9600);
}

void loop() {
  // Poll the pin values
  double val_0 = analogRead(2);
  double val_1 = analogRead(1);
  double val_2 = analogRead(0);
  double val_3 = analogRead(3);
  double val_4 = analogRead(4);
  double val_5 = analogRead(5);

   /* 670 - 690 range determined through testing voltages when the pins are high */
  if(val_0 > 670 && val_0 < 690 ){
    Serial.println("PAD 0");
    bt_serial.println(0);
  }
  if(val_1 > 670 && val_1 < 690 ){
    Serial.println("PAD 1");
    bt_serial.println(1);
  }
  if(val_2 > 670 && val_2 < 690 ){
    Serial.println("PAD 2");
    bt_serial.println(2);
  }
  if(val_3 > 670 && val_2 < 690 ){
    Serial.println("PAD 3");
    bt_serial.println(3);
  }
  if(val_4 > 670 && val_1 < 690 ){
    Serial.println("PAD 4");
    bt_serial.println(4);
  }
  if(val_5 > 670 && val_0 < 690 ){
    Serial.println("PAD 5");
    bt_serial.println(5);
  }
}
