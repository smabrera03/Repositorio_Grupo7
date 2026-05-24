%%
close all; clear;
k1 = 11.4345;
g = 9.807;
k2 = 100 * pi/180 * g * 2.1;
k = k1 * k2;
p1 = -10;
p2 = -4.8680 + 3.0753i;

P = zpk([], [0 p1 p2 conj(p2)], k);

kp = 2;
ki = 1.2;

s = tf('s');

C = kp + ki * 1/s; % C = kp (s + ki/kp) /s
L = C * P;
T = minreal(L/(1 + L));


x_lim = [0, 10];
x_label = 'Tiempo [s]';


%Respuesta al impulso
load('impulso_PI_v1');

a = -1/8; %ganancia para ajustar los datos al impulso unitario
t0 = 2.3; %tiempo para mover los datos medidos

fig1 = figure;
[y, timp] = impulse(T);
plot(timp, y, 'r--'); hold on;
plot(t - t0, a * posicion, 'b-'); grid On;

xlim(x_lim);
ylim([-2, 3]);
xlabel(x_label);
ylabel('Posición [cm]');

legend('Simulación', 'Medición');
title('Respuesta al impulso');

saveas(fig1, 'PI-Respuesta al impulso.png');

fig2 = figure;
plot(t - t0, angulo_servo); grid On;
xlim(x_lim);
xlabel(x_label);
ylabel('Acción de control [°]');
title('Acción de control');

saveas(fig2, 'PI-Acción de control(impulso).png');

%Respuesta al escalón
load('escalon_PI_v1.mat');

t0 = 5;
fig3 = figure;
[y, tstep] = step(10 * T);
plot(tstep, y, 'r--'); hold on;
plot(t - t0, posicion, 'b-'); grid On;
yline(10, 'k--');

xlabel(x_label);
xlim(x_lim);
ylabel('Posición [cm]');

legend('Simulación', 'Medición');
title('Respuesta al escalón');

saveas(fig3, 'PI-Respuesta al escalón.png');

fig4 = figure;
plot(t - t0, angulo_servo); grid On;

xlabel(x_label);
ylabel('Acción de control [°]');
xlim(x_lim);
title('Acción de control');

saveas(fig4, 'PI-Acción de control(escalón).png')


%Bode
fig5 = figure;

opt = bodeoptions;
opt.PhaseMatching = 'On';
opt.PhaseMatchingValue = -90;
opt.PhaseMatchingFreq = 0.1;

[Gm,Pm,Wcg,Wcp] = margin(L);
Gm = 20 * log10(Gm);
margin(L, opt);

lineas = findall(fig5, 'Type', 'line');
set(lineas(12:14), 'Color', 'b');
set(lineas(12:14), 'LineWidth', 2);

titulo = sprintf('Bode de L(s). \n Margen de ganancia %.2f dB en %.2f rad/s || Margen de fase %.1f ° en %.2f rad/s', Gm, Wcg, Pm, Wcp);
title(titulo, 'Fontsize', 10);
grid on;

saveas(fig5, 'PI-Bode de L.png');