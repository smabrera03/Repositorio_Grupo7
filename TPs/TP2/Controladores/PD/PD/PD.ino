#include <NewPing.h>
#include <Servo.h>
#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>

#define TRIGGER_PIN  6   // Pin de arduino conectado al pin del trigger
#define ECHO_PIN     7   // Pin de arduino conectado al pin del echo
#define MAX_DISTANCE 40 // Distancia máxima en centímetros
#define PERIODO 20000 //Período en us
#define N_MUESTRAS 50 //Cantidad de vececs que se mide el ángulo de la IMU para estimar el sesgo
#define C 0.0343 //Velocidad del sonido en cm/us
#define X_REF 0.0
#define ESC 0.0
#define TS 0.02

#define ANGULO_SERVO_MAX 58.55
#define ANGULO_SERVO_MIN -46.84

NewPing sonar(TRIGGER_PIN, ECHO_PIN, MAX_DISTANCE); // Setup
Servo miServo;
Adafruit_MPU6050 mpu;
float theta_bias = 0;

void setup() {
  miServo.attach(9); // pin PWM
  Serial.begin(115200);

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

float kp = 2.5;
//float kd = 0.01;
float kd = 0;

float error[2] = {0, 0};//Vector de errores
//Nota importante: error[0] es e(n) (el error actual), y error[1] = e(n - 1) (el error anterior)

float derivada[2] = {0, 0};
//Idem

int n_ciclos = 0;
float x_ref = X_REF;

void loop() {
  unsigned long t_ini = micros();

  //Sensor ultrasónico
  float posicion = posicion_carrito();

  //IMU
  sensors_event_t a, g, t;
  mpu.getEvent(&a, &g, &t);
  
  theta_x_acc = (180/PI) * atan2(a.acceleration.y, a.acceleration.z) - theta_bias;
  theta_x_gyro_fc = theta_x_fc + (180/PI) * g.gyro.x * (PERIODO/1000000);
  
  theta_x_fc = alfa * theta_x_acc + (1 - alfa) * theta_x_gyro_fc;

  //Servomotor
  if (n_ciclos == 250) {
    x_ref = X_REF + ESC;
  }
  //actualizo error
  error[1] = error[0];
  error[0] = x_ref - posicion;

  //Actualizo la derivada
  derivada[1] = derivada[0];
  derivada[0] = (2.0/TS) * (error[0] - error[1]) - derivada[0];

  float angulo = kp * error[0] + kd * derivada[0];

  if(angulo < ANGULO_SERVO_MIN){
    angulo = ANGULO_SERVO_MIN;
  } else if(angulo > ANGULO_SERVO_MAX){
    angulo = ANGULO_SERVO_MAX;
  }
  int duty_cycle_servo = (int)mapFloat(angulo, -90, 90, 600, 2400);
  miServo.writeMicroseconds(duty_cycle_servo);

  float datos[4] = {posicion, angulo, error[0], derivada[0]};
  matlab_send(datos, 4);

  n_ciclos++;

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


float posicion_carrito(){ //Esta función devuelve la posición del carro en nuestro sistema de referencia
  unsigned long tiempo = sonar.ping(MAX_DISTANCE);
  float medicion = (C/2) * tiempo; 
  if(tiempo == 0){ //Se excedió el tiempo máximo, el carrito se cayó de la barra o está pegado al sensor
    medicion = 15.5; //Quiero que cuando el carrito se caiga, el sensor lo detecte en 0.
  } else if(medicion < 2){
    medicion = 2; //Para las mediciones menores a 2cm
  }
  return mapFloat(medicion, 15.5, 32, 0, 17.25);
}

