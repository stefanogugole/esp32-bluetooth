#include "BluetoothSerial.h"

BluetoothSerial SerialBT;
int i = 0;

//MAC bluetooth esp32 con MPU6050: 78:21:84:92:6F:6A
String MACadd = "78:21:84:92:6F:6A";
uint8_t address[6]  = {0x78, 0x21, 0x84, 0x92, 0x6F, 0x6A};
//uint8_t address[6]  = {0x00, 0x1D, 0xA5, 0x02, 0xC3, 0x22};
String name = "ESP32client"; //                  <------- set this to be the name of the other ESP32!!!!!!!!!
//char *pin = "1234"; //<- standard pin would be provided by default
bool connected;

String text = "";


void setup() {
  Serial.begin(115200);
  //SerialBT.setPin(pin);
  
  SerialBT.begin("ESP32_BLE_RX", true); 
  //SerialBT.setPin(pin);
  
  //Serial.println("The device started in master mode, make sure remote BT device is on!");
  
  // connect(address) is fast (upto 10 secs max), connect(name) is slow (upto 30 secs max) as it needs
  // to resolve name to address first, but it allows to connect to different devices with the same name.
  // Set CoreDebugLevel to Info to view devices bluetooth address and device names
  
  connected = SerialBT.connect("ESP32_BLE_TX");
  //connected = SerialBT.connect(address);
  
  if(connected) {
    Serial.println("Connected Succesfully!");
  } else {
    while(!SerialBT.connected(10000)) {
      Serial.println("Failed to connect. Make sure remote device is available and in range, then restart app."); 
    }
  }
  // disconnect() may take upto 10 secs max
  if (SerialBT.disconnect()) {
    Serial.println("Disconnected Succesfully!");
  }
  // this would reconnect to the name(will use address, if resolved) or address used with connect(name/address).
  SerialBT.connect();
}

void loop() {

  /*
  if (Serial.available()) {
    SerialBT.write(Serial.read());
  }
  */
  /*
  if (SerialBT.available()) {
    Serial.println(SerialBT.readString());
  }
  */
  
   if (SerialBT.available() > 0) {
    text = SerialBT.readStringUntil('\n');
    text.remove(text.length()-1, 1);
    Serial.println(text);
    
  }
 // delay(10);
}