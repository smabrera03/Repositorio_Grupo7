clc; clear; close all;

load('barra_carro_-20grad_1.mat');

N = length(y);
X = [-y(2:N-1), -y(1:N-2), u(1:N-2)];

Y = y(3:N);

% LS sin restricciones
theta_ls = X \ Y;

% Restricción:
% a1 + a2 = -1
C = [1 1 0];
d = -1;

% Solución restringida
theta = theta_ls ...
    - (X' * X)\C' ...
    * inv(C * ((X' * X)\C')) ...
    * (C*theta_ls - d);

a1 = theta(1);
a2 = theta(2);
k  = theta(3);

Ts = 0.02;

m = 33e-3;
p_discreto = -a2;
p_continuo = 1/Ts * log(p_discreto); % = -b/m
b = -m * p_continuo