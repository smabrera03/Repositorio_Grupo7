%{
Convención para los nombres de las variables:
Ángulos:
    ang_med
    ang_obs
    ang_sim

Velocidad angular:
    velagn_med
    velang_obs
    velang_sim

Posiciones:
    pos_med
    pos_obs
    pos_sim

Velocidades (lineales):
    vel_med
    vel_obs
    vel_sim

Acción de control:
    uk
%}

clear; close all;

load('Observador_datos.mat');
%corrijo los nombres
ang_med = theta_medida;
ang_obs = theta_obs;

velang_med = vel_angular_medida;
velang_obs = vel_angular_obs;

vel_med = vel_medida;

load('Observador_simulado.mat');

fig1 = figure(1);
plot(t, uk, 'LineWidth', 2);
grid on;
xlim([0, t(end)]);
xlabel('Tiempo [s]');
ylim([-30, 30]);
ylabel('Acción de control [°]');
exportgraphics(fig1, 'obs_img\uk.pdf', 'ContentType', 'image', 'Resolution', 300);

fig2 = figure(2);
plot(t, pos_med, 'b-'); hold on;
plot(t, pos_obs, 'r-.'); hold on;
plot(t, pos_sim, 'k--');
grid on;
legend('Posición medida', 'Posición observada', 'Posición simulada');
xlim([0, t(end)]);
xlabel('Tiempo [s]');
ylabel('Posición [cm]');
exportgraphics(fig2, 'obs_img\pos.pdf', 'ContentType', 'image', 'Resolution', 300);

figure(3);
plot(t, vel_obs, 'r-.'); hold on;
plot(t, vel_sim, 'k--');
grid on;
legend('Velocidad observada', 'Velocidad simulada');
xlim([0, t(end)]);
xlabel('Tiempo [s]');
ylabel('Velocidad');
exportgraphics(gcf, 'obs_img\vel.pdf', 'ContentType', 'image', 'Resolution', 300);
%NOTA: no incluyo la estimación de la derivada por backwards xq es
%excesivamente ruidosa

figure(4);
plot(t, ang_med, 'b-'); hold on;
plot(t, ang_obs, 'r-.'); hold on;
plot(t, ang_sim, 'k--');
grid on;
legend('Ángulo medido', 'Ángulo observado', 'Ángulo simulado');
xlim([0, t(end)]);
xlabel('Tiempo [s]');
ylabel('Ángulo de la barra [°]');
exportgraphics(gcf, 'obs_img\ang.pdf', 'ContentType', 'image', 'Resolution', 300);

figure(5);
plot(t, velang_med, 'b-'); hold on;
plot(t, velang_obs, 'r-.'); hold on;
plot(t, velang_sim, 'k--');
grid on;
legend('Velocidad angular medida', 'Velocidad angular observada', 'Velocidad angular simulada');
xlim([0, t(end)]);
xlabel('Tiempo [s]');
ylabel('Velocidad angular [°/s]');
exportgraphics(gcf, 'obs_img\velang.pdf', 'ContentType', 'image', 'Resolution', 300);