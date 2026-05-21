%%
close all; clear;
k1 = 11.4345;
g = 9.807;
k2 = 100 * pi/180 * g * 2.1;
k = k1 * k2;
p1 = -10;
p2 = -4.8680 + 3.0753i;

a = -1/8; %ganancia para ajustar los datos al impulso unitario
t0 = 2.3; %tiempo para mover los datos medidos

P = zpk([], [0 p1 p2 conj(p2)], k);

kp = 2;
ki = 1.2;

s = tf('s');

C = kp + ki * 1/s;
L = C * P;
T = minreal(L/(1 + L));




load('impulso_PI_v1');

figure;
impulse(T, t); hold on;
plot(t - t0, a * posicion); grid On;
title('Respuesta al impulso');

figure;
plot(t - t0, a * angulo_servo); grid On;
title('Acción de control');

%Respuesta al escalón
load('escalon_PI_v1.mat');

t0 = 5;
figure;
step(10 * T, t); hold on;
plot(t - t0, posicion); grid On;
title('Respuesta al escalón');

figure;
plot(t - t0, angulo_servo); grid On;
title('Acción de control');