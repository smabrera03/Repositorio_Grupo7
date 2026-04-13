#define N 100

void setup() {
  Serial.begin(115200);

}

void loop() {
  float dato = 4.5;
  Serial.flush(); //Vacía el buffer

  unsigned long t_ini = micros();

  for(int i = 0; i < N; i++){
    matlab_send(&dato, 1);
  }

  Serial.flush(); //Espera que el buffer se vacíe. 
  unsigned long t_fin = micros();
  
  Serial.println("");
  Serial.print("En envio tardo: ");
  Serial.println((float)(t_fin - t_ini)/N);

  while(micros() - t_ini < 500000){}
}


void matlab_send(float *datos, size_t largo){
  for(size_t i = 0; i < largo; i++){
    byte * b = (byte *) &datos[i];
    Serial.write(b,4);
  }
}

/*
El envío tarda 340,12 us por float
*/