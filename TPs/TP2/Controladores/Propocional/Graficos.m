close all; clear;
k1 = 11.4345;
g = 9.807;
k2 = 100 * pi/180 * g * 2.1;
k = k1 * k2;
p1 = -10;
p2 = -4.8680 + 3.0753i;

a = 0.25; %ganancia para ajustar los datos al impulso unitario
t0 = 2.1; %tiempo para mover los datos medidos

P = zpk([], [0 p1 p2 conj(p2)], k);
C = 3.5;
L = C * P;
T = minreal(L/(1 + L));




load('impulso_v1');

figure;
impulse(T); hold on;
plot(t - t0, a * posicion); grid On;
title('Respuesta al impulso');


%Respuesta al escalón
load('escalon_v1.mat');

t0 = 4.9;
a = 1;
figure;
step(10 * T); hold on;
plot(t - t0, a * posicion); grid On;
title('Respuesta al escalón');