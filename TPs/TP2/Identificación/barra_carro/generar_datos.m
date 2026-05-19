close all; 
u = double(out.u);
y = double(out.y);
t = double(out.tout);

y_max = 17.25; %posición máxima posible del carrito según nuestro sistema de referencia. 
idx_caida = find(y > y_max, 1) - 1;

%y_min = -14; 
%idx_caida = find(y < y_min, 1) - 1;
%A partir de acá consideramos que se cayó. 
%comentar o descomentar uno según la entrada que le hayas dado al servo


u = u(1:idx_caida);
y = y(1:idx_caida);
t = t(1:idx_caida);


save('barra_carro_30grad_1.mat', 'u', 'y', 't'); %para volcar los datos en un archivo
%Para recuperar: load('datos_sin_carrito.mat');