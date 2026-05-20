close all; 
posicion = double(out.posicion);
angulo_servo = double(out.angulo_servo);
t = double(out.tout);


save('impulso_v1', 'posicion', 'angulo_servo', 't'); %para volcar los datos en un archivo
%Para recuperar: load('datos_sin_carrito.mat');