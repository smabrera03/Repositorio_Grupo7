#include <Servo.h>
#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>
#include <Wire.h>

#define PERIODO 200000 //período del ciclo en us. En este caso se elige un preíodo grande para que el servo tenga tiempo para estabilizarse

Adafruit_MPU6050 mpu;
Servo miServo;

void setup() {
  miServo.attach(9); // pin PWM
  Serial.begin(115200); // Inicia la comunicación serial

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


int i = 0; //En cada iteración agrego un i a writeMicroseconds();

float theta_x_gyro = 0; //Posición angular estimada por el giroscopio, asumimos que inicialmente es 0
float theta_x_acc = 0; //Posición angular estimada por el giroscopio, asumimos que inicialmente es 0
float theta_x_fc = 0; //Posición angular estimada por el filtro complementario

float alpha = 0.05;

void loop() {
  unsigned long t_ini = micros();

  //Muevo el servo un poco
  miServo.writeMicroseconds(1500 + i);

  //Estimo el ángulo
  sensors_event_t a, g, t;
  mpu.getEvent(&a, &g, &t);

  theta_x_gyro = theta_x_fc + (180/PI) * g.gyro.x * PERIODO/1000000; //OBS: ¿Qué pasa si el ciclo tarda más de lo esperado?
  theta_x_acc = (180/PI) * atan2(a.acceleration.y, a.acceleration.z);

  theta_x_fc = alpha * theta_x_acc + (1 - alpha) * theta_x_gyro;

  float datos[2] = {(float)i, theta_x_fc};
  //Envío los datos a matlab
  matlab_send(datos, 2);

  i = (i + 1)%50; //Actualizo i. Sé que el servo se va a mover al rededor de i = 17 y esta actualización mantiene i entre 0 y 50

  while(micros() - t_ini < PERIODO){}
}


void matlab_send(float *datos, size_t largo){
  Serial.write("abcd");
  for(size_t i = 0; i < largo; i++){
    byte * b = (byte *) &datos[i];
    Serial.write(b,4);
  }
}