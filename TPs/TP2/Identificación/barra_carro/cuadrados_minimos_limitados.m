clc; clear; close all;

load('promedio_mediciones.mat');

%{
La planta discreta que estoy modelando es 
Pd = k/((z-1) * (z + p)) = Y(z)/X(z=

La ecuación en diferencias es y(n) = alfa1 * y(n-1) +alfa2 * y(n-2) + alfa3 * x(n-2)
con la restricción a1 + a2 = -1
a2 = p
%}
N = length(y);
X = [y(2:N-1), y(1:N-2), u(1:N-2)];

Y = y(3:N);

% LS sin restricciones
alfa_ls = X \ Y;

% Restricción:
% a1 + a2 = -1
C = [1 1 0];
d = 1;

% Solución restringida
alfa = alfa_ls ...
    - (X' * X)\C' ...
    * inv(C * ((X' * X)\C')) ...
    * (C*alfa_ls - d);

a1 = alfa(1);
pd = alfa(2);
kd  = alfa(3);

Ts = 0.02;

m = 33e-3;
pc = -1/Ts * log(pd); % = -b/m

kc = kd * pc * (1/1 + pd);