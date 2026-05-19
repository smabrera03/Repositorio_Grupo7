close all; 
posicion = double(out.posicion);
angulo_servo = double(out.angulo_servo);
angulo_barra = double(out.angulo_barra);
t = double(out.tout);


save('impulso_P', 'posicion', 'angulo_servo', 'angulo_barra', 't'); %para volcar los datos en un archivo
%Para recuperar: load('datos_sin_carrito.mat');