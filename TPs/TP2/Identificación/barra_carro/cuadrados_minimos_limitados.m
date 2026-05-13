clc; clear; close all;

load('barra_carro_20grad_1.mat');

%{
La planta discreta que estoy modelando es 
Pd = k/((z-1) * (z + p)) = Y(z)/X(z=

La ecuación en diferencias es y(n) = -a1 * y(n-1) - a2 * y(n-2) + k * x(n-2)
con la restricción a1 + a2 = -1
a2 = p
%}
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