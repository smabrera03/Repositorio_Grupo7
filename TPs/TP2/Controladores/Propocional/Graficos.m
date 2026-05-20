close all; clear;
k1 = 11.4345;
g = 9.807;
k2 = 100 * pi/180 * g;
k = k1 * k2;
p1 = -8;
p2 = -4.8680 + 3.0753i;

P = zpk([], [0 p1 p2 conj(p2)], k);
C = 3.5;
L = C * P;
T = minreal(L/(1 + L));



load('impulso_v1');

figure;
impulse(T); hold on;
plot(t - 2.25, 0.2 * posicion); grid On;