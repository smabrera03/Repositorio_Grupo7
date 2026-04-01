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

void loop() {
  unsigned long t_ini = micros();

  sensors_event_t a, g, t;
  mpu.getEvent(&a, &g, &t);

  float datos[6] = {a.acceleration.x, a.acceleration.y, a.acceleration.z, g.gyro.x, g.gyro.y, g.gyro.z};

  matlab_send(datos, 6);

  while (micros() - t_ini < 20000) {}
}


void matlab_send(float *datos, size_t largo){
  Serial.write("abcd");

  for(size_t i = 0; i < largo; i++){
    byte * b = (byte *) &datos[i];
    Serial.write(b,4);
  }
  


  /*b = (byte *) &dato2;
  Serial.write(b,4);
  b = (byte *) &dato3;
  Serial.write(b,4);*/
  //etc con mas datos tipo float. Tambien podría pasarse como parámetro a esta funcion un array de floats.
}
