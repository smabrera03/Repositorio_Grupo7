clc; clear; close all;

load('barra_carro_20grad_1.');

%{
Planta continua = g/(s * (s +  b/m)), donde b es el coeficiente de
viscosidad

Planta discretizada = k/( (z-1) * ( z + p)) = k/(z^2 +(p-1) * z - p) =
kz^-2/(1 + (p -1) * z^-1 - p * z^-2)

La ecuación en diferencias es y(n) = afla1 * y(n-1) + alfa2 * y(n-2) + alfa3 * u(n-2)
Además sabemos que alfa1 = 1 - p, alfa2 = p, 
Luego b/m = - 1/Ts * ln(p)
%}
N = length(y);
Y = y(3:N);
%Matriz X del problema de CM con las versiones atrasadas de la entrada y la
%salida
X = [y(2:N-1), y(1:N-2), u(1:N-2)];

theta = X \ Y; %el operador / resuelve cuadrados mínimos.

% Parámetros estimados
alfa1 = theta(1);
alfa2 = theta(2);
k  = theta(3);

Ts = 0.02;

m = 33e-3;
p_discreto = alfa2
p_continuo = 1/Ts * log(p_discreto) % = -b/m
b = m *(- p_continuo)