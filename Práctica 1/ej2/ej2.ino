// Ejercicio 2 -- Grupo 7

#include <NewPing.h>

#define TRIGGER_PIN  6   // Arduino pin tied to trigger pin on the ultrasonic sensor.
#define ECHO_PIN     7   // Arduino pin tied to echo pin on the ultrasonic sensor.
#define MAX_DISTANCE 50 // Maximum distance we want to ping for (in centimeters). Maximum sensor distance is rated at 400-500cm.

NewPing sonar(TRIGGER_PIN, ECHO_PIN, MAX_DISTANCE); // NewPing setup of pins and maximum distance.

void setup() {
  Serial.begin(9600);
}

unsigned long t_inicial = 0;
unsigned long t_final = 0;
unsigned long delta2 = 0;

void loop() {
  t_inicial = millis();
  // Serial.println(delta2);

  unsigned long t_ini = micros();
  unsigned long med = sonar.ping(MAX_DISTANCE);
  unsigned long t_fin = micros();
  unsigned long delta = t_fin - t_ini;
  float f = 1000000 / delta;
  //Serial.println(f); // Varía en función de la longitud medida
  Serial.println(med / 29.287); //OBS: Tiene algo de ruido
  // OBSERVACIóN IMPORTANTE: Tiene que haber un delay entre 2 mediciones. Si no, hay errores

  t_final = millis(); // Implementar con un while
  delta2 = t_final - t_inicial;
  if(delta2 < 20){
    delay(20 - delta2);
  }
}
