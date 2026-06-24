#include <Servo.h>
#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>
#include <Wire.h>
#include <NewPing.h>
#include <BasicLinearAlgebra.h>

#define C 0.0343 //Velocidad del sonido en cm/us
#define TRIGGER_PIN  6   // Pin de arduino conectado al pin del trigger
#define ECHO_PIN     7   // Pin de arduino conectado al pin del echo
#define MAX_DISTANCE 40 // Distancia máxima en centímetros

#define PERIODO 20000 //período del ciclo en us. En este caso se elige un preíodo grande para que el servo tenga tiempo para estabilizarse
#define TS 0.02 //Período en s
#define N_MUESTRAS 50 //Cantidad de vececs que se mide el ángulo de la IMU para estimar el sesgo
#define CICLOS 30 //Cantidad de ciclos que tienen que pasar para cambiar el valor de uk
#define UK_REF1 0.0 //ángulo que se moverá el servo
#define UK_REF2 -20.0

#define ANGULO_SERVO_MAX 58.55
#define ANGULO_SERVO_MIN -46.84

NewPing sonar(TRIGGER_PIN, ECHO_PIN, MAX_DISTANCE); // Setup
Adafruit_MPU6050 mpu;
Servo miServo;

float theta_bias = 0;

void setup() {
  miServo.attach(9); // pin PWM
  Serial.begin(115200); // Inicia la comunicación serial

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

  miServo.writeMicroseconds(1500);
  delay(500);

  sensors_event_t a, g, t;
  for(int i = 0; i < N_MUESTRAS; i++){ //Se calcula es sesgo como el promedio de (N_MUESTRAS) mediciones
    mpu.getEvent(&a, &g, &t);
    theta_bias += (180/PI) * atan2(a.acceleration.y, a.acceleration.z);
  }
  theta_bias/=N_MUESTRAS;
}


float theta_x_gyro = 0; //Posición angular estimada por el giróscopo, asumimos que inicialmente es 0
float theta_x_acc = 0; //Posición angular estimada por el acelerómetro, asumimos que inicialmente es 0

float alpha = 0.1; //NO TOCAR

float uk = 0;
float uk_1 = 0;
int n_ciclo = 0; //número del ciclo

using namespace BLA;

Matrix<4, 4> Ad = {
1.0000000000, 0.0200000000, 0.0000000000, 0.0000000000, 
-0.6630980000, 0.8052800000, 0.0000000000, 0.0000000000, 
0.0000000000, 0.0000000000, 1.0000000000, 0.0200000000, 
0.7188900000, 0.0000000000, 0.0000000000, 0.8000000000
};

Matrix<4, 1> Bd = {
0.0000000000, 
0.2286900000, 
0.0000000000, 
0.0000000000
};


Matrix<2, 4> Cd = {
0.0000000000, 0.0000000000, 1.0000000000, 0.0000000000, 
1.0000000000, 0.0000000000, 0.0000000000, 0.0000000000
};

Matrix<4, 1> xk_hat = {0, 0, 0, 0}; //Orden: theta, omega, p y v 
Matrix<4, 1> xk_1_hat = {0, 0, 0, 0};

Matrix<2, 1> yk_1 = {0, 0};
Matrix<2, 1> yk = {0, 0};


//observador mediciones
/*
Matrix<4, 2> L = {
-0.0749221777, 0.6376474566, 
-1.0880131272, -0.0807759563, 
0.6613733390, -0.1225064780, 
1.8156617685, -0.9358982539
};
*/

/*
Observador informe
Matrix<4,2> L = {
0.0000000000, 0.8885889227, 
0.0000000000, 4.9458722847, 
0.8833089227, -0.0000000000, 
5.4271828091, 0.7188900000
};*/

/*
Matrix<4,2> L = {
-0.0000000000, 0.4579311196, 
-0.0000000000, -0.0225111943, 
0.4526511196, -0.0000000000, 
0.5724929901, 0.7188900000
};
*/


//[-25 -25 -20 -20]
Matrix<4,2> L = {
-0.0000000000, 0.5284292943, 
-0.0000000000, 0.6780620908, 
0.5231492943, -0.0000000000, 
1.2544547571, 0.7188900000
};


float velocidad = 0; //Velocidad del carrito. La estimamos por backward
void loop() {
  unsigned long t_ini = micros();

  sensors_event_t a, g, t;
  mpu.getEvent(&a, &g, &t);
  float velocidad_gyro = (180/PI) * g.gyro.x;
  theta_x_gyro = yk(1) + velocidad_gyro * PERIODO/1000000; //OBS: ¿Qué pasa si el ciclo tarda más de lo esperado?
  theta_x_acc = (180/PI) * atan2(a.acceleration.y, a.acceleration.z) - theta_bias;

  yk_1 = yk;
  yk(1) = alpha * theta_x_acc + (1 - alpha) * theta_x_gyro;
  yk(0) = posicion_carrito();
  //Agregar ultrasónico

  uk_1 = uk;

  xk_1_hat = xk_hat;
  xk_hat = Ad * xk_1_hat + Bd * uk_1 + L * (yk_1 - Cd * xk_1_hat);

  if((n_ciclo / CICLOS) % 2 == 0){
    uk = UK_REF1;
  } else {
    uk = UK_REF2;
  };


  if(uk < ANGULO_SERVO_MIN){
    uk = ANGULO_SERVO_MIN;
  } else if(uk > ANGULO_SERVO_MAX){
    uk = ANGULO_SERVO_MAX;
  }

  int duty_cycle_servo = (int)mapFloat(uk, -90, 90, 600, 2400);
  miServo.writeMicroseconds(duty_cycle_servo);

  n_ciclo++;

  velocidad = (yk(0) - yk_1(0))/ TS;

  float datos[9] = {uk, yk(0), xk_hat(2), yk(1), xk_hat(0), velocidad_gyro, xk_hat(1), velocidad, xk_hat(3)}; //{posiciones, posiciones angulares, velocidades angulares, velocidades}
  matlab_send(datos, 9);

  while(micros() - t_ini < PERIODO){}
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
