// Ejercicio 2 -- Grupo 7

#include <NewPing.h>

#define TRIGGER_PIN  6   // Arduino pin tied to trigger pin on the ultrasonic sensor.
#define ECHO_PIN     7   // Arduino pin tied to echo pin on the ultrasonic sensor.
#define MAX_DISTANCE 100 // Maximum distance we want to ping for (in centimeters). Maximum sensor distance is rated at 400-500cm.

NewPing sonar(TRIGGER_PIN, ECHO_PIN, MAX_DISTANCE); // NewPing setup of pins and maximum distance.

void setup() {
  Serial.begin(115200);
}

void loop() {
  unsigned long t_ini = micros();
  unsigned long med = sonar.ping(MAX_DISTANCE);
  unsigned long t_fin = micros();
  Serial.println(med);

  while(micros() - t_ini < 1000000){}
}

/*
SEGÚN HOJA DE DATOS:
Mínima resolución en distancia: delta_x = 3mm
Eso lo pasamos a mínima resolución de tiempo con la siguiente cuenta:
delta_t = 2 * delta_x/vel_sonido = 17,48 us (vel_sonido = 343,2 m/s a 20 °C)

Tiempo que tarda en medir una distancia de 50 cm:
Teórico = 2,91 ms
Medido =  2,93 ms
*/
