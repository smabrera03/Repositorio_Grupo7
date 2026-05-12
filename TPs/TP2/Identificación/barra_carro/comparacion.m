clear; close all;
load('barra_carro_20grad_1.mat');
y1 = y;
u1 = u;
load('barra_carro_20grad_2.mat');
y2 = y;
u2 = u;
load('barra_carro_20grad_3.mat');
y3 = y;
u3 = u;
load('barra_carro_20grad_4.mat');
y4 = y;
u4 = u;
load('barra_carro_20grad_5.mat');
y5 = y;
u5 = u;

N = min([length(y1), length(y2), length(y3), length(y4), length(y5)]); 
y_prom = (y1(1:N) + y2(1:N) + y3(1:N) + y4(1:N) + y5(1:N))/5
u_prom = (u1(1:N) + u2(1:N) + u3(1:N) + u4(1:N) + u5(1:N))/5

y = y_prom;
u = u_prom;

t = t(1:N);
Ts = 0.02;

b = 0.1; %Lo encontré tanteando
m = 33e-3;
g = 9.807; %OJO: está en m/s^2

s = tf('s');
P = 100*g * pi/180 * 1/(s * (s + b/m)); %m/°


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
