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
  unsigned long t_fin = micros();

  Serial.println(t_fin - t_ini);

  while (micros() - t_ini < 1000000) {}
}



/*
Según la hoja de datos la aceleración se mide con un ADC de 16 bit. Estamos midiendo en un rango de +/- 8g. Por lo tanto
delta_a = 16g/2^(16) = 244,14 ug = 2,39 mm/s^2

NOTA: la aceleración que devuelve el acelerómetro es en m/s^2

Sobre la resolución del ángulo: propagar errores con este dato y la fórmula del arcotangente.

Tiempo que tarda en hacer una medición: 3048 +/-4 us.

PERO: según la hoja de datos, el acelerómetro opera a 1kHz, eso es, una medición cada 1000 us.
*/