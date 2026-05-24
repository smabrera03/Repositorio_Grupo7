%%
close all; clear;
k1 = 11.4345;
g = 9.807;
k2 = 100 * pi/180 * g * 2.1;
k = k1 * k2;
p1 = -10;
p2 = -4.8680 + 3.0753i;

a = -1/8; %ganancia para ajustar los datos al impulso unitario
t0 = 2.3; %tiempo para mover los datos medidos

P = zpk([], [0 p1 p2 conj(p2)], k);

kp = 2.5;
kd = 0.1;

s = tf('s');

C = kp + kd * s; %kd * (s + kp/kd)
L = C * P;
T = minreal(L/(1 + L));


x_label = 'Tiempo [s]';

%Respuesta al impulso
load('impulso_PD_v1.mat');

t0 = 3.9;
a = -0.12;
x_lim = [0, 4];

fig1 = figure;
[y, timp] = impulse(T);
plot(timp, y, 'r--'); hold on;
plot(t - t0, a * posicion, 'b-'); grid On;

xlim(x_lim);
ylim([-1.2, 2.5]);
xlabel(x_label);
ylabel('Posición [cm]');

legend('Simulación', 'Medición');
title('Respuesta al impulso');

saveas(fig1, 'PD-Respuesta al impulso.png');

%Acción de control

fig2 = figure;

plot(t - t0, angulo_servo); grid on;

xlim(x_lim);
xlabel(x_label);
ylabel('Acción de control [°]');
angulo_max = 59;
angulo_min = -47;
ylim([angulo_min - 5, angulo_max + 5]);

yline(angulo_max, 'k--');
yline(angulo_min, 'k--');

title('Acción de control');

saveas(fig2, 'PD-Acción de control(impulso).png');


%Respuesta al escalón

load('escalon_PD_v1.mat');
fig3 = figure;

t0 = 5;
[y, tstep] = step(10 * T);
plot(tstep, y, 'r--'); hold on;
plot(t - t0, posicion, 'b-'); grid On;
yline(10, 'k--');

xlabel(x_label);
xlim(x_lim);
ylabel('Posición [cm]');

legend('Simulación', 'Medición');
title('Respuesta al escalón');

saveas(fig3, 'PD-Respuesta al escalón.png');

%Acción de control
fig4 = figure;
plot(t - t0, angulo_servo); grid on;

xlim(x_lim);
xlabel(x_label);
ylabel('Acción de control [°]');
ylim([angulo_min - 5, angulo_max + 5]);

yline(angulo_max, 'k--');
yline(angulo_min, 'k--');

title('Acción de control');

saveas(fig4,'PD-Acción de control(escalón).png');

fig5 = figure;

opt = bodeoptions;
opt.PhaseMatching = 'On';
opt.PhaseMatchingValue = -90;
opt.PhaseMatchingFreq = 0.1;

[Gm,Pm,Wcg,Wcp] = margin(L);
Gm = 20 * log10(Gm);
margin(L, opt);

titulo = sprintf('Bode de L(s). \n Margen de ganancia %.2f dB en %.2f rad/s || Margen de fase %.1f ° en %.2f rad/s', Gm, Wcg, Pm, Wcp);
title(titulo);
grid on;

saveas(fig5, 'PD-Bode de L.png');

% Derivada ruidosa
load('PD-Derivada ruidosa.mat');
t0 = 8;
x_lim = [0, 5];

fig6 = figure;
subplot(2,1,1);
plot(t - t0, error);
title('Error');
xlabel(x_label);
xlim(x_lim);
ylabel('Error [cm]');
ylim([-20, 20]);
grid on;

subplot(2,1,2);
plot(t - t0, derivada);
title('Derivada');
xlabel(x_label);
ylabel('Derivada [cm/s]');
xlim(x_lim);
ylim([-3000, 3000]);
grid on

saveas(fig6, 'PD-Derivada ruidosa.png');