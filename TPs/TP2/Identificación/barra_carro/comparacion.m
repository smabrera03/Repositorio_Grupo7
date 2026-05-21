clear; close all;
load('promedio_mediciones.mat');

Ts = 0.02;

y = y-mean(y(1:201));

pc = 3; %entre 3 2.7
g = 9.807; %OJO: está en m/s^2
kc_calc = 100 * pi/180 * g;

%21/5 como la identificación no da, modifiqué pc y kc_calc

pc = 10;
kc_calc  = 100 * pi/180 * g * 2.1;

s = tf('s');
P = kc_calc * 1/(s * (s + pc)); %cm/°


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
