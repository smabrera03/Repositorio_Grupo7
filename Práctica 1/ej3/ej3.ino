// Ejercicio 3 -- Grupo 7

#include <Servo.h>

Servo miServo;

void setup() {
  miServo.attach(9); // pin PWM
  Serial.begin(9600); // Inicia la comunicación serial
}

void loop() {
  unsigned long t_ini = micros();

  int valor = analogRead(A0);
  Serial.println(valor);

  // 1 ms → posición mínima
  //miServo.writeMicroseconds(500);
  //delay(2000);

  //miServo.write(0);
  //delay(2000);

  // 1.5 ms → posición media
  //miServo.writeMicroseconds(1500);
  //delay(2000);

  //miServo.write(90);
  //delay(2000);

  // 2 ms → posición máxima
  //miServo.writeMicroseconds(2400);
  //delay(2000);

  //miServo.write(180);
  //delay(2000);

  int angulo = map(valor, 0, 1023, 500, 2400); 

  miServo.writeMicroseconds(angulo);

  while (micros() - t_ini < 1000000) {}

}
