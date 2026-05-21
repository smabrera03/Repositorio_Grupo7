close all; 
posicion = double(out.posicion);
x_ref = double(out.x_ref);
angulo_servo = double(out.angulo);
t = double(out.tout);


save('escalon_PI_v1', 'posicion', 'x_ref', 'angulo_servo',  't'); %para volcar los datos en un archivo
%Para recuperar: load('datos_sin_carrito.mat');