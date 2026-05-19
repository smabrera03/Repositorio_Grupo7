clear; close all;
load('barra_carro_20grad_1.mat');
y1 = y;
u1 = u;
load('barra_carro_20grad_2.mat');
y2 = y;
u2 = u;
load('barra_carro_20grad_3.mat');
y3 = y;
u3 = u;
load('barra_carro_20grad_4.mat');
y4 = y;
u4 = u;
load('barra_carro_20grad_5.mat');
y5 = y;
u5 = u;

N = min([length(y1), length(y2), length(y3), length(y4), length(y5)]); 
y = (y1(1:N) + y2(1:N) + y3(1:N) + y4(1:N) + y5(1:N))/5;
u = (u1(1:N) + u2(1:N) + u3(1:N) + u4(1:N) + u5(1:N))/5;
t = t(1:N);

save('promedio_mediciones.mat', 'u', 'y', 't');

y = [y1; y2; y3; y4; y5];
u = [u1; u2; u3; u4; u5];

save('datos_concatenados.mat', 'u', 'y')