close all; 
posicion = double(out.posicion);
angulo_servo = double(out.angulo);
error = double(out.error);
derivada = double(out.derivada);
t = double(out.tout);


save('PD-derivada ruidosa', 'posicion', 'angulo_servo', 'error', 'derivada',  't'); %para volcar los datos en un archivo
%Para recuperar: load('datos_sin_carrito.mat');