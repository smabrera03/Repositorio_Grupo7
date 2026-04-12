void setup() {
  Serial.begin(115200);

}

void loop() {
  unsigned long t_ini = micros();
  float dato = 4.5;

  for(int i = 0; i < 100; i++){
    matlab_send(&dato, 1);
    dato = dato + 1;
  }

  unsigned long t_fin = micros();
  
  Serial.println('El envío tardó: ');
  Serial.println((t_fin - t_ini)/100);

  while(micros() - t_ini < 500000){}
}


void matlab_send(float *datos, size_t largo){
  Serial.write("abcd");

  for(size_t i = 0; i < largo; i++){
    byte * b = (byte *) &datos[i];
    Serial.write(b,4);
  }
}

/*
Si envío siempre el mismo float, tardo 625 us por float
El envío tarda 625 us por float
*/