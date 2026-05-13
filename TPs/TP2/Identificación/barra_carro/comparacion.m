clear; close all;
load('barra_carro_20grad_1.mat');

Ts = 0.02;

b = 0.1; %Lo encontré tanteando
m = 33e-3;
g = 9.807; %OJO: está en m/s^2

s = tf('s');
P = 100*g * pi/180 * 1/(s * (s + b/m)); %cm/°


y_est = lsim(P, u, t);

plot(t, y, 'b', 'LineWidth', 1.5);
hold on;
plot(t, y_est, 'r--', 'LineWidth', 1.5);

grid on;
xlabel('Tiempo [s]');
ylabel('Salida');

legend('Medición real', 'Modelo');
title('Comparación medición vs modelo');

error = y - y_est;
rmse = sqrt(mean(error.^2));
rmse_y = sqrt(mean(y.^2));
fit = (1 - rmse/rmse_y) * 100

%{
Todo mal
Hice mal las mediciones?
Estimé mal los coeficientes?
Planteé mal el modelo de la planta discreta?
error de unidades? OJO: la transferencia está en m/°, pero yo estoy
midiendo la posición en cm
Probar lo que decía el chat. Agregarle un cero al modelo de la
transferencia discreta ¿Por qué? ¿Por qué no nos hizo falta antes?
%}
