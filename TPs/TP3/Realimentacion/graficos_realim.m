clear; close all;

load('realimentacion_datos.mat');
load('realimentacion_simulada.mat');

[~, t0_idx] = min(abs(t - t0));
t = t(t0_idx:end) - t0;
%recorto los datos medidos:
uk = uk(t0_idx:end);

pos_obs = pos_obs(t0_idx:end);
vel_obs = vel_obs(t0_idx:end);
ang_obs = ang_obs(t0_idx:end);
velang_obs = velang_obs(t0_idx:end);

fig1 = figure(1);
plot(t, uk, 'LineWidth', 2); hold on;
plot(t, uk_sim);
grid on;
xlim([0, t(end)]);
xlabel('Tiempo [s]');
ylabel('Acción de control [°]');
exportgraphics(gcf, 'realim_img\uk.pdf', 'ContentType', 'image', 'Resolution', 300);

fig2 = figure(2);
plot(t, pos_obs, 'r-.'); hold on;
plot(t, pos_sim, 'k--');
grid on;
legend('Posición observada', 'Posición simulada');
xlim([0, t(end)]);
xlabel('Tiempo [s]');
ylabel('Posición [cm]');
exportgraphics(gcf, 'realim_img\pos.pdf', 'ContentType', 'image', 'Resolution', 300);

figure(3);
plot(t, vel_obs, 'r-.'); hold on;
plot(t, vel_sim, 'k--');
grid on;
legend('Velocidad observada', 'Velocidad simulada');
xlim([0, t(end)]);
xlabel('Tiempo [s]');
ylabel('Velocidad');
exportgraphics(gcf, 'realim_img\vel.pdf', 'ContentType', 'image', 'Resolution', 300);

figure(4);
plot(t, ang_obs, 'r-.'); hold on;
plot(t, ang_sim, 'k--');
grid on;
legend('Ángulo observado', 'Ángulo simulado');
xlim([0, t(end)]);
xlabel('Tiempo [s]');
ylabel('Ángulo de la barra [°]');
exportgraphics(gcf, 'realim_img\ang.pdf', 'ContentType', 'image', 'Resolution', 300);

figure(5);
plot(t, velang_obs, 'r-.'); hold on;
plot(t, velang_sim, 'k--');
grid on;
legend('Velocidad angular observada', 'Velocidad angular simulada');
xlim([0, t(end)]);
xlabel('Tiempo [s]');
ylabel('Velocidad angular [°/s]');
exportgraphics(gcf, 'realim_img\velang.pdf', 'ContentType', 'image', 'Resolution', 300);
