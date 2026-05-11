// Ejercicio 2 -- Grupo 7

#include <NewPing.h>

#define TRIGGER_PIN  6   // Arduino pin tied to trigger pin on the ultrasonic sensor.
#define ECHO_PIN     7   // Arduino pin tied to echo pin on the ultrasonic sensor.
#define MAX_DISTANCE 50 // Maximum distance we want to ping for (in centimeters). Maximum sensor distance is rated at 400-500cm.
#define C 0.0343 //Velocidad del sonido en cm/us
#define PERIODO 20000 //Período en us
NewPing sonar(TRIGGER_PIN, ECHO_PIN, MAX_DISTANCE); // NewPing setup of pins and maximum distance.

void setup() {
  Serial.begin(9600);
}


void loop() {
  unsigned long t_ini = micros();

  float med = (C/2) * sonar.ping(MAX_DISTANCE); //medición en cm. sonar.ping devuelve us.
  Serial.println(med); //OBS: Tiene algo de ruido
  // OBSERVACIóN IMPORTANTE: Tiene que haber un delay entre 2 mediciones. Si no, hay errores

  while (micros() - t_ini < PERIODO) {}
}
