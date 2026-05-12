clc; clear; close all;

load('barra_carro_20grad_1.mat');

Ts = t(2) - t(1);

data = iddata(y, u, Ts);
u = (pi/180) * u;
y = y/100;
sys_d = arx(data, [2 1 2])

polos_d = pole(sys_d);
compare(data, sys_d)

p_discreto = -polos_d(2);
p_continuo = 1/Ts * log(p_discreto);