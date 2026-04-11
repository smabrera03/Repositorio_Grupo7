#include <Servo.h>

Servo miServo;

void setup() {
  miServo.attach(9); // pin PWM
  Serial.begin(9600); // Inicia la comunicación serial
}

void loop() {

  /*for(int i = 0; i < 20; i++){
    miServo.writeMicroseconds(1500 + 1*i);
    Serial.print(i);
    Serial.print(":");
    Serial.println(miServo.read());
    delay(250);
  }*/

  miServo.write(90);
  delay(1000);
  unsigned long t_ini = micros();
  miServo.write(120);
  while(miServo.read() != 120){}
  unsigned long t_fin = micros();

  Serial.println(t_fin - t_ini);
  delay(1000);
  //while (micros() - t_ini < 20000) {}
}

// Observamos que la máxima resolución angular en el servo corresponde con 17 +/- 2 us variados del ancho del PWM. Esa variación
// corresponde con 2° (Si bien teóricamente es 1°).

/*
Cuenta para poner en el informe:
rango = (2400us - 544 us)/17us = 109,18
NOTA: el 17us se encontró experimentalmente. Es lo mínimo que hay que cambiar en writeMicroseconds();

Resolución angular = 180 / 109,18 = (1,65 +/- 0,20)°

Velocidad del servo: 
Tarda 100us en pasar de 120 a 90 (delta_tita = 30°)
*/