// El potenciómetro tiene algo de ruido (a veces glitchea)

void setup() {
  Serial.begin(115200); // Inicia la comunicación serial
}

float mapFloat(float valor, float x_inicial, float x_final, float y_inicial, float y_final){
  return (y_final - y_inicial)/(x_final - x_inicial) * (valor - x_inicial) + y_inicial;
}

void loop() {

  // Punto 1
  unsigned long t_ini = micros();

  int valor = analogRead(A0);

  // Punto 2
  int angulo = map(valor, 0, 1023, 0, 270); 
  Serial.println(angulo);

  while (micros() - t_ini < 20000) {}
}
