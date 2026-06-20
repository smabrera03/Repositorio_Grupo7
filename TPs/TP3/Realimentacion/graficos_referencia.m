clear; close all;

load('referencia_datos.mat');
load('referencia_simulada.mat');
[~, t0_idx] = min(abs(t - t0));
t = t(t0_idx:end) - t0;
uk = uk(t0_idx:end);
ref = ref(t0_idx:end);
pos_obs = pos_obs(t0_idx:end);
vel_obs = vel_obs(t0_idx:end);
ang_obs = ang_obs(t0_idx:end);
velang_obs = velang_obs(t0_idx:end);

figure;
plot(t, uk, 'LineWidth', 2);
grid on;
xlabel('Tiempo [s]');
xlim([0, t(end)]);
ylabel('Acción de control [°]');
exportgraphics(gcf, 'ref_img\uk.pdf', 'ContentType', 'image', 'Resolution', 300);

figure;
plot(t, ref, 'b-'); hold on;
plot(t, pos_obs, 'r-.'); hold on;
plot(t, pos_sim, 'k--');
grid on;
legend('Referencia', 'Posición observada', 'Posición simulada');
xlim([0, t(end)]);
xlabel('Tiempo [s]');
ylim([-15, 15]);
ylabel('Posición [cm]');
exportgraphics(gcf, 'ref_img\pos.pdf', 'ContentType', 'image', 'Resolution', 300);

figure;
plot(t, vel_obs, 'r-'); hold on;
plot(t, vel_sim, 'k--');
grid on;
legend('Velocidad observada', 'Velocidad simulada');
xlim([0, t(end)]);
xlabel('Tiempo [s]');
ylim([-80, 80]);
ylabel('Velocidad [cm/s]');
exportgraphics(gcf, 'ref_img\vel.pdf', 'ContentType', 'image', 'Resolution', 300);

figure;
plot(t, ang_obs, 'r-'); hold on;
plot(t, ang_sim, 'k--');
grid on;
legend('Ángulo observado', 'Ángulo simulado');
xlim([0, t(end)]);
xlabel('Tiempo [s]');
ylabel('Ángulo de la barra [°]');
exportgraphics(gcf, 'ref_img\ang.pdf', 'ContentType', 'image', 'Resolution', 300);

figure;
plot(t, velang_obs, 'r-'); hold on;
plot(t, velang_sim, 'k--');
grid on;
legend('Velocidad angular observada', 'Velocidad angular simulada');
xlim([0, t(end)]);
xlabel('Tiempo [s]');
ylabel('Velocidad angular [°/s]');
exportgraphics(gcf, 'ref_img\velang.pdf', 'ContentType', 'image', 'Resolution', 300);

%{
DUDA: ¿Error en estado estacionario hace que las variables observadas sean
distintas de cero?
La acción de control no es cero, pero la posición tampoco cambia. El
observador "le hecha la culpa" a la velocidad del carro.
%}

