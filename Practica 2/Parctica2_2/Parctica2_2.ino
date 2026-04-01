#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>
#include <Wire.h>

Adafruit_MPU6050 mpu;

void setup() {
  Serial.begin(115200);
  while (!Serial)
    delay(10); // will pause Zero, Leonardo, etc until serial console opens

  Serial.println("Adafruit MPU6050 test!");

  // Try to initialize!
  if (!mpu.begin()) {
    Serial.println("Failed to find MPU6050 chip");
    while (1) {
      delay(10);
    }
  }
  Serial.println("MPU6050 Found!");

  mpu.setAccelerometerRange(MPU6050_RANGE_8_G);
  mpu.setGyroRange(MPU6050_RANGE_500_DEG);
  mpu.setFilterBandwidth(MPU6050_BAND_44_HZ);


}

float theta_x_gyro = 0; /*Posición angular estimada por el giroscopio, asumimos que inicialmente es 0*/
float theta_x_acc = 0; /*Posición angular estimada por el giroscopio, asumimos que inicialmente es 0*/

void loop() {
  unsigned long t_ini = micros();

  sensors_event_t a, g, t;
  mpu.getEvent(&a, &g, &t);
  
  theta_x_gyro = theta_x_gyro + (180/3.14159) * g.gyro.x * 0.02; //esta estimación tiene el problema del bias. 
  theta_x_acc = (180/3.14159) * atan2(a.acceleration.y, a.acceleration.z);

  float datos[2] = {theta_x_gyro, theta_x_acc};
  matlab_send(datos, 2);

  while (micros() - t_ini < 20000) {}
}


void matlab_send(float *datos, size_t largo){
  Serial.write("abcd");

  for(size_t i = 0; i < largo; i++){
    byte * b = (byte *) &datos[i];
    Serial.write(b,4);
  }
}

