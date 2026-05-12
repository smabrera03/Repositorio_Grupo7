clear; close all;
load('barra_carro_20grad_1.mat');

b = 1.4505;
m = 33e-3;
g = 9.807 * 100; %pasar a cm/s^2

s = tf('s');
P = g/(s * (s + b/m));

y_est = lsim(P, u, t);

plot(t, y, 'b', 'LineWidth', 1.5);
hold on;
plot(t, y_est, 'r--', 'LineWidth', 1.5);

grid on;
xlabel('Tiempo [s]');
ylabel('Salida');

legend('Medición real', 'Modelo');
title('Comparación medición vs modelo');

%{
Todo mal
Hice mal las mediciones?
Estimé mal los coeficientes?
Planteé mal el modelo de la planta discreta?
error de unidades? OJO: la transferencia está en m/°, pero yo estoy
midiendo la posición en cm

%}
