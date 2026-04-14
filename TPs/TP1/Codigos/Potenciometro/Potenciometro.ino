// El potenciómetro tiene algo de ruido (a veces glitchea)

void setup() {
  Serial.begin(115200); // Inicia la comunicación serial
}

float mapFloat(float valor, float x_inicial, float x_final, float y_inicial, float y_final){
  return (y_final - y_inicial)/(x_final - x_inicial) * (valor - x_inicial) + y_inicial;
}

void loop() {

  // Resolución

  /*int valor = analogRead(A0);

  float angulo = mapFloat((float)valor, 0, 1023, 0, 270); 
  float tension = 1000 * mapFloat((float)valor, 0, 1023, 0, 5); //Se multiplica por 1000 para ver mejor en el monitor
  Serial.println(tension);*/

  // Tiempo de medición

  delay(3000);

  unsigned long t_ini = micros();

  int valor = analogRead(A0);

  unsigned long t_fin = micros();

  Serial.println((t_fin - t_ini));
}


/*
              Mediciones:
Resolución ángulo: 270/1023 ° = 0,264° = 0°15'50,15''
Resolución tensión: 5/1023 V = 4,89 mV
Tiempo = 112 +/- 4 us
Buscar en la hoja de datos del uno (conversión del ADC)
*/
