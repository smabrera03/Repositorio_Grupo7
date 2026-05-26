#include "TimerOne.h"

typedef union{
  float number;
  uint8_t bytes[4];
} FLOATUNION_t;



void setup()
{
  Serial.begin(115200);
}

float error[2] = {0, 0};
float integral[2] = {0, 0};
float u_k[2] = {0, 0};

float p = -0.002397;
float kp = -5.0;
float ki = p * 5.0;


size_t cont = 0;
void loop()
{
  // Ajustar condiciones iniciales de trabajo
  static float u0 = 0.5, h_ref = 0.45, h = 0.45, u;
  static float Ts = 1;
  FLOATUNION_t aux;
  static float sampling_period_ms = 1000*Ts;
  //=========================
  // Definir parametros y variables del control

  if(cont >= 10){
    h_ref = 0.40;
  }
  //=========================

  if (Serial.available() >= 4) {
 
    aux.number = getFloat();
    h = aux.number;
  }
  //=========================
  //CONTROL
  error[1] = error[0];
  error[0] = h_ref - h;

  integral[1] = integral[0];
  integral[0] = Ts * error[0] + integral[1];

  u_k[1] = u_k[0];
  u_k[0] = (-5.012) * error[0] + 5 * error[1] + u_k[1];

  u = u_k[0] + u0;
  //=========================
    
  matlab_send(u,h_ref,u0);
  cont++;
  delay(sampling_period_ms);
}

void matlab_send(float u, float h, float u0){
  Serial.write("abcd");
  byte * b = (byte *) &u;
  Serial.write(b,4);
  b = (byte *) &h;
  Serial.write(b,4);
  b = (byte *) &u0;
  Serial.write(b,4);
}

float getFloat(){
    int cont = 0;
    FLOATUNION_t f;
    while (cont < 4 ){
        f.bytes[cont] = Serial.read() ;
        cont = cont +1;
    }
    return f.number;
}
