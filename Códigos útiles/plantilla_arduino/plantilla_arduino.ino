#include <NewPing.h>
#include <Servo.h>
#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>

#define TRIGGER_PIN  6   // Pin de arduino conectado al pin del trigger
#define ECHO_PIN     7   // Pin de arduino conectado al pin del echo
#define MAX_DISTANCE 50 // Distancia máxima en centímetros
#define PERIODO 20000 //Período en us
#define N_MUESTRAS 50 //Cantidad de vececs que se mide el ángulo de la IMU para estimar el sesgo
#define C 0.0343 //Velocidad del sonido en cm/us

NewPing sonar(TRIGGER_PIN, ECHO_PIN, MAX_DISTANCE); // Setup
Servo miServo;
Adafruit_MPU6050 mpu;
float theta_bias = 0;

void setup() {
  miServo.attach(9); // pin PWM
  Serial.begin(9600);

  if (!mpu.begin()) {
    Serial.println("IMU no encontrada");
    while (1) {
      delay(10);
    }
  }
  Serial.println("IMU inicializada correctamente");

  mpu.setAccelerometerRange(MPU6050_RANGE_8_G);
  mpu.setGyroRange(MPU6050_RANGE_500_DEG);
  mpu.setFilterBandwidth(MPU6050_BAND_44_HZ);

  sensors_event_t a, g, t;
  for(int i = 0; i < N_MUESTRAS; i++){ //Se calcula es sesgo como el promedio de (N_MUESTRAS) mediciones
    mpu.getEvent(&a, &g, &t);
    theta_bias += (180/PI) * atan2(a.acceleration.y, a.acceleration.z);
  }
  theta_bias/=N_MUESTRAS;
}


float theta_x_acc = 0; //Posición angular estimada por el acelerómetro, asumimos que inicialmente es 0
float theta_x_fc = 0; 
float theta_x_gyro_fc = 0;

float alfa = 0.1;

void loop() {
  unsigned long t_ini = micros();

  //Sensor ultrasónico
  float med = (C/2) * sonar.ping(MAX_DISTANCE); //medición en cm
  Serial.println(med);


  //Servomotor
  int angulo = 0;
  int duty_cycle_servo = (int)mapFloat(angulo, -90, 90, 600, 2400);
  miServo.writeMicroseconds(duty_cycle_servo);

  //IMU
  sensors_event_t a, g, t;
  mpu.getEvent(&a, &g, &t);
  

  theta_x_acc = (180/PI) * atan2(a.acceleration.y, a.acceleration.z) - theta_bias;
  theta_x_gyro_fc = theta_x_fc + (180/PI) * g.gyro.x * (PERIODO/1000000);
  
  theta_x_fc = alfa * theta_x_acc + (1 - alfa) * theta_x_gyro_fc;

  float datos[3] = {theta_x_acc, theta_x_gyro_fc, theta_x_fc};
  matlab_send(datos, 3};

  while (micros() - t_ini < PERIODO) {}
}

float mapFloat(float valor, float x_inicial, float x_final, float y_inicial, float y_final){
  return (y_final - y_inicial)/(x_final - x_inicial) * (valor - x_inicial) + y_inicial;
}

void matlab_send(float *datos, size_t largo){
  Serial.write("abcd");

  for(size_t i = 0; i < largo; i++){
    byte * b = (byte *) &datos[i];
    Serial.write(b,4);
  }
}

