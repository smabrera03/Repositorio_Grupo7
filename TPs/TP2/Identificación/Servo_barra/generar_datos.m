close all;
u = double(out.u);
y = double(out.y);
t = double(out.tout);

save('datos_45_grad.mat', 'u', 'y', 't'); %para volcar los datos en un archivo
%Para recuperar: load('datos_sin_carrito.mat');