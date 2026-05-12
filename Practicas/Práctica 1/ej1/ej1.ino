// El potenciómetro tiene algo de ruido (a veces glitchea)

void setup() {
  Serial.begin(9600); // Inicia la comunicación serial
}

void loop() {

  // Punto 1
  unsigned long t_ini = micros();
  int valor = analogRead(A0);
  unsigned long t_fin = micros();
  unsigned long delta = t_fin - t_ini;
  float f = 1000000 / delta; // f = 8928 Hz (se utilizó 'Serial.println()'))

  // Punto 2
  int angulo = map(valor, 0, 1023, 0, 270); 
  Serial.println(angulo);

  // Punto 3
  unsigned long t_final = micros();
  unsigned long delta2 = t_final - t_ini;

  if (delta2 < 20000) {
    delayMicroseconds(20000 - delta2); // Máximo 16 ms, CORREGIR
  }
  else {
    Serial.println('El loop tarda demasiado.');
  }
}
