

#include <Adafruit_MPU6050.h>


#include <MPU6050.h>

#include <Wire.h>

#include "BluetoothSerial.h" //Header File for Serial Bluetooth, will be added by default into Arduino

#define I2C_SDA 21

#define I2C_SCL 22



BluetoothSerial ESP_BT; //Object for Bluetooth


//istruzioni https://forum.arduino.cc/t/esp32-to-esp32-bluetooth-communication/558370/2
//MAC bluetooth esp32 con MPU6050: 78:21:84:92:6F:6A
//MAC bluetooth esp32  senza: 78:21:84:92:52:A2





//Collega: D22 -> SCL, D21 -> SDA, GND -> GND, 3V3 -> VCC





// Basic demo for accelerometer readings from Adafruit MPU6050

// ESP32 Guide: https://RandomNerdTutorials.com/esp32-mpu-6050-accelerometer-gyroscope-arduino/
// ESP8266 Guide: https://RandomNerdTutorials.com/esp8266-nodemcu-mpu-6050-accelerometer-gyroscope-arduino/
// Arduino Guide: https://RandomNerdTutorials.com/arduino-mpu-6050-accelerometer-gyroscope/


#include <Adafruit_Sensor.h>
Adafruit_MPU6050 mpu;
unsigned long myTime;

#define trigPin 12 // define TrigPin
#define echoPin 14 // define EchoPin.
#define MAX_DISTANCE 300 // Maximum sensor distance is rated at 400-500cm.
//timeOut= 2*MAX_DISTANCE /100 /340 *1000000 = MAX_DISTANCE*58.8
float timeOut = MAX_DISTANCE * 60; 
int soundVelocity = 340; // define sound speed=340m/s

float getSonar() {
  unsigned long pingTime;
  float distance;
  // make trigPin output high level lasting for 10μs to triger HC_SR04
  digitalWrite(trigPin, HIGH); 
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  // Wait HC-SR04 returning to the high level and measure out this waitting time
  pingTime = pulseIn(echoPin, HIGH, timeOut); 
  // calculate the qdistance according to the time
  distance = (float)pingTime * soundVelocity / 2 / 10000; 
  return distance; // return the distance value
}

void setup(void) {
  pinMode(trigPin,OUTPUT);// set trigPin to output mode
  pinMode(echoPin,INPUT); // set echoPin to input mode
  Wire.begin(I2C_SDA, I2C_SCL); // remap I2C
  ESP_BT.begin("ESP32_BLE_TX_Prof"); //Name of your Bluetooth Signal
  //Serial.println("Bluetooth Device is Ready to Pair");

  

  Serial.begin(115200);
  while (!Serial)
    delay(10); // will pause Zero, Leonardo, etc until serial console opens

  //Serial.println("Adafruit MPU6050 test!");

  // Try to initialize!
  if (!mpu.begin()) {
    //Serial.println("Failed to find MPU6050 chip");
    while (1) {
      delay(10);                  //esce solo al riavvio?
    }
  }
  //Serial.println("MPU6050 Found!");

  mpu.setAccelerometerRange(MPU6050_RANGE_4_G); //2G
  
  /*
  Serial.print("Accelerometer range set to: ");
  switch (mpu.getAccelerometerRange()) {
  case MPU6050_RANGE_2_G:
    Serial.println("+-2G");
    break;
  case MPU6050_RANGE_4_G:
    Serial.println("+-4G");
    break;
  case MPU6050_RANGE_8_G:
    Serial.println("+-8G");
    break;
  case MPU6050_RANGE_16_G:
    Serial.println("+-16G");
    break;
  }

  */
  mpu.setGyroRange(MPU6050_RANGE_500_DEG);

  /*
  Serial.print("Gyro range set to: ");
  switch (mpu.getGyroRange()) {
  case MPU6050_RANGE_250_DEG:
    Serial.println("+- 250 deg/s");
    break;
  case MPU6050_RANGE_500_DEG:
    Serial.println("+- 500 deg/s");
    break;
  case MPU6050_RANGE_1000_DEG:
    Serial.println("+- 1000 deg/s");
    break;
  case MPU6050_RANGE_2000_DEG:
    Serial.println("+- 2000 deg/s");
    break;
  }

  */

  mpu.setFilterBandwidth(MPU6050_BAND_5_HZ);

  
  delay(100);
}

void loop() {
  /* Get new sensor events with the readings */
  sensors_event_t a, g, temp;
  mpu.getEvent(&a, &g, &temp);
  myTime = millis();

  //SP_BT.print("");

  ESP_BT.print("{");

  ESP_BT.print("time:");
  ESP_BT.print(myTime);
  ESP_BT.print(",");

  ESP_BT.print("ax:");
  ESP_BT.print(a.acceleration.x);
  ESP_BT.print(",");
  ESP_BT.print("ay:");
  ESP_BT.print(a.acceleration.y);
  ESP_BT.print(",");
  ESP_BT.print("az:");
  ESP_BT.print(a.acceleration.z);
  ESP_BT.print(",");
  
  /*
  ESP_BT.print("gx:");
  ESP_BT.print(g.gyro.x);
  ESP_BT.print(",");
  ESP_BT.print("gy:");
  ESP_BT.print(g.gyro.y);
  ESP_BT.print(",");
  ESP_BT.print("gz:");
  ESP_BT.print(g.gyro.z);
  ESP_BT.print(",");

  */

  ESP_BT.print("h:");
  ESP_BT.print(getSonar());
  //ESP_BT.print(",");
  
  



  ESP_BT.println("}");

/*
ESP_BT.print(myTime);
ESP_BT.print(":");
ESP_BT.print(a.acceleration.x);
ESP_BT.print(":");
ESP_BT.println(getSonar());
*/

delay(15);  //20

/*
  Serial.print("Filter bandwidth set to: ");
  switch (mpu.getFilterBandwidth()) {
  case MPU6050_BAND_260_HZ:
    Serial.println("260 Hz");
    break;
  case MPU6050_BAND_184_HZ:
    Serial.println("184 Hz");
    break;
  case MPU6050_BAND_94_HZ:
    Serial.println("94 Hz");
    break;
  case MPU6050_BAND_44_HZ:
    Serial.println("44 Hz");
    break;
  case MPU6050_BAND_21_HZ:
    Serial.println("21 Hz");
    break;
  case MPU6050_BAND_10_HZ:
    Serial.println("10 Hz");
    break;
  case MPU6050_BAND_5_HZ:
    Serial.println("5 Hz");
    break;
  }

  */
/*
  Serial.println("");

*/
/* Print out the values
  Serial.print("AX:");
  Serial.print(a.acceleration.x);
 /*  Serial.print(", ");
  Serial.print("Y:");
  Serial.print(a.acceleration.y);
   Serial.print(", ");
  Serial.print("Z:");
  Serial.print(a.acceleration.z);
   Serial.println(",");
 /* Serial.println(" m/s^2");*/

 //Serial.print("AX:");
 /*
 Serial.print(myTime);  //AD ogni riga stampo la coppia (millisecondi, valoreDiAx)
 Serial.print(":");
 Serial.print(a.acceleration.x);
 */
/*
  Serial.print("Rotation X: ");
  Serial.print(g.gyro.x);
  Serial.println(",");
  Serial.print(", Y: ");
  Serial.print(g.gyro.y);
  Serial.println(",");
  Serial.print(", Z: ");
  Serial.print(g.gyro.z);
  Serial.println(" rad/s");
  

  Serial.print("Temperature: ");
  Serial.print(temp.temperature);
  Serial.println(" degC");
*/
  //Serial.println(a.acceleration.x);
  //Serial.println("");
  
}
