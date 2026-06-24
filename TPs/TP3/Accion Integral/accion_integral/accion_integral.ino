#include <Servo.h>
#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>
#include <Wire.h>
#include <NewPing.h>
#include <BasicLinearAlgebra.h>

#define ABS(x) ((x) < 0 ? -(x) : (x))

#define C 0.0343 //Velocidad del sonido en cm/us
#define TRIGGER_PIN  6   // Pin de arduino conectado al pin del trigger
#define ECHO_PIN     7   // Pin de arduino conectado al pin del echo
#define MAX_DISTANCE 40 // Distancia máxima en centímetros

#define PERIODO 20000 //período del ciclo en us. En este caso se elige un preíodo grande para que el servo tenga tiempo para estabilizarse
#define TS 0.02 //Período en s
#define N_MUESTRAS 50 //Cantidad de vececs que se mide el ángulo de la IMU para estimar el sesgo
#define CICLOS 30 //Cantidad de ciclos que tienen que pasar para cambiar el valor de uk

#define ANGULO_SERVO_MAX 58.55
#define ANGULO_SERVO_MIN -46.84

#define P_REF1 -8.0
#define P_REF2 8.0


typedef enum {HORIZONTAL, INCLINADO} estado_t;

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

/*
//[-20, -20, -10 -10]
Matrix<4,2> L = {
-0.0000000000, 0.3162292009, 
-0.0000000000, -0.7538636508, 
0.3109492009, -0.0000000000, 
-0.1214501598, 0.7188900000
};
*/

/*
[4, ang45, -2 -2.1 -5] NO ANDA

Matrix<1,4> K = {
0.9127966046, -0.4643703599, 1.1152318319, -0.3728966518
};

float H = -0.7057;
*/

/*
[6, ang45, -2.1 -2, -8] NO ANDA
Matrix<1,4> K = {
2.7532844498, 0.0122100316, 3.3279222472, 0.1126850560
};

float H = -2.3984;
*/

/*
[6, ang45, -2.1 -2, -10] NO ANDA
Matrix<1,4> K = {
3.1160377595, 0.1583162710, 4.0066639121, 0.3008126101
};

float H =  -2.9404;
*/

/*
[6, ang45, -3, -3.1, -10] Empieza a mejorar
Matrix<1,4> K = {
4.7803430484, 0.3245316690, 6.6538173496, 0.5468612296
};

float H = -6.3830;
*/


/*
//[6, ang45, -3.6, -3.5, -10] ¿Mejor?
Matrix<1,4> K = {
5.6581564704, 0.4064010321, 8.1350299562, 0.6802141868
};

float H = -8.5628;
*/


/*
[-6, ang45, -4.5, -4.6, -10] NO. mucho ruido
Matrix<1,4> K = {
6.5649858183, 0.4874557815, 9.7168209818, 0.8201477492
};

float H = -11.0357;
*/

//NUEVO
Matrix<4,2> L = {
0.0000000000, 0.3800185872, 
-0.0000000000, -0.7967644150, 
0.3747385872, -0.0000000000, 
-0.1811913221, 0.7188900000
};

//[-8 -8.1 -3 -3.1 -2.9] MUY LENTO
/*
Matrix<1,4> K = {
3.6199693436, 0.3384391039, 4.3120808728, 0.3410717632
};

float H = -3.3169;
*/

//[-8 -8 -4 -4 -4]
/*
Matrix<1,4> K = {
6.7703206877, 0.6072650545, 8.4568663675, 0.7280325556
};

float H = -8.1994;
*/

//
/*
Matrix<1,4> K = {
5.4446369632, 0.4568671431, 6.8394952221, 0.5562359359
};

float H = -6.4125;
*/

// NOTA: 8 8 3  3 8 anduvo
Matrix<1,4> K = {
4.7666579945, 0.4259222904, 5.6192913545, 0.4564977997
};

float H = -4.6566;

float velocidad = 0; //Velocidad del carrito. La estimamos por backward

float ref = 0.0;

size_t n_ciclos = 0;

estado_t estado = HORIZONTAL;

float qk_1 = 0.0;
float qk = 0.0;


/*
MATRICES USADAS EN LA MEDICIÓN DEL TP:
Matrix<4, 2> L = {
-0.0749221777, 0.6376474566, 
-1.0880131272, -0.0807759563, 
0.6613733390, -0.1225064780, 
1.8156617685, -0.9358982539
};


Matrix<1,4> K = {
1, 0.5, 8.9671222670, 0.7007598002
};

float H = -11.6105;
*/
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

  uk_1 = uk;

  xk_1_hat = xk_hat;
  xk_hat = Ad * xk_1_hat + Bd * uk_1 + L * (yk_1 - Cd * xk_1_hat);

  if(estado == INCLINADO){
    ref = P_REF1;
  }else{
    ref = P_REF2;
  }

  qk_1 = qk;
  qk = qk_1 + TS * (ref - yk(0));
  
  uk = ((-K)*xk_hat)(0) - H * qk;

  /*
  if(ABS(ref - yk(0)) < 1){
    uk = 0; 
  }
  */

  if(uk < ANGULO_SERVO_MIN){
    uk = ANGULO_SERVO_MIN;
  } else if(uk > ANGULO_SERVO_MAX){
    uk = ANGULO_SERVO_MAX;
  }

  int duty_cycle_servo = (int)mapFloat(uk, -90, 90, 600, 2400);
  miServo.writeMicroseconds(duty_cycle_servo);


  velocidad = (yk(0) - yk_1(0))/ TS;

  float datos[11] = {uk, qk, ref, yk(0), xk_hat(2), yk(1), xk_hat(0), velocidad_gyro, xk_hat(1), velocidad, xk_hat(3)}; //{referencia, integral del error,posiciones, posiciones angulares, velocidades angulares, velocidades}
  matlab_send(datos, 11);

  if(n_ciclos == 250){
    estado = INCLINADO;
  }else if(n_ciclos == 500){
    estado = HORIZONTAL;
    n_ciclos = 0;
  }
  n_ciclos++;
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
