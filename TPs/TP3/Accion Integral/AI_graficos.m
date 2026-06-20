close all; clear;

load('AI_datos.mat');
load('AI_sim.mat');

figure;
plot(t, uk, 'LineWidth', 2);
grid on;
xlabel('Tiempo [s]');
xlim([0, t(end)]);
ylabel('Acción de control [°]');
exportgraphics(gcf, 'AI_img\uk.pdf', 'ContentType', 'image', 'Resolution', 300);

figure;
plot(t, ref, 'b-'); hold on;
%plot(t, pos_med, 'b-');
plot(t, pos_obs, 'r-.'); hold on;
plot(t, pos_sim, 'k--');
grid on;
legend('Referencia', 'Posición observada', 'Posición simulada');
xlim([0, t(end)]);
xlabel('Tiempo [s]');
ylim([-13, 10]);
ylabel('Posición [cm]');
exportgraphics(gcf, 'AI_img\pos.pdf', 'ContentType', 'image', 'Resolution', 300);

figure;
plot(t, vel_obs, 'r-'); hold on;
plot(t, vel_sim, 'k--');
grid on;
legend('Velocidad observada', 'Velocidad simulada');
xlim([0, t(end)]);
xlabel('Tiempo [s]');
ylim([-40, 40]);
ylabel('Velocidad [cm/s]');
exportgraphics(gcf, 'AI_img\vel.pdf', 'ContentType', 'image', 'Resolution', 300);

%{
Mismo problema de antes (o parecido): La acción de control va creciendo,
pero la posición no cambia. El observador "le hecha la culpa" a la
velocidad, y termina siendo distinta de cero cuando debería ser 0
%}
figure;

plot(t, ang_obs, 'r-'); hold on;
plot(t, ang_sim, 'k--');
grid on;
legend('Ángulo observado', 'Ángulo simulado');
xlim([0, t(end)]);
xlabel('Tiempo [s]');
ylabel('Ángulo de la barra [°]');
exportgraphics(gcf, 'AI_img\ang.pdf', 'ContentType', 'image', 'Resolution', 300);

figure;
plot(t, velang_obs, 'r-'); hold on;
plot(t, velang_sim, 'k--');
grid on;
legend('Velocidad angular observada', 'Velocidad angular simulada');
xlim([0, t(end)]);
xlabel('Tiempo [s]');
ylabel('Velocidad angular [°/s]');
exportgraphics(gcf, 'AI_img\velang.pdf', 'ContentType', 'image', 'Resolution', 300);
