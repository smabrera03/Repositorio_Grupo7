close all; clear; clc;
k1 = 11.4345;
g = 9.807;
k2 = 100 * pi/180 * g * 2.1;
k = k1 * k2;
p1 = -10;
p2 = -4.8680 + 3.0753i;

a = 0.25; %ganancia para ajustar los datos al impulso unitario
t0 = 2.1; %tiempo para mover los datos medidos

P = zpk([], [0 p1 p2 conj(p2)], k);
C = 3.5;
L = C * P;
T = minreal(L/(1 + L));


%Respuesta al impulso
load('impulso_v1');

fig1 = figure;
[y, timp] = impulse(T);
plot(timp, y, 'r--'); hold on;
plot(t - t0, a * posicion, 'b-'); grid On;

xlim([0, 10]);
ylim([-4, 4]);
xlabel('Tiempo [s]');
ylabel('Posición [cm]');

legend('Simulación', 'Medición');
title('Respuesta al impulso');

saveas(fig1,  'proporcional-respuesta al impulso.png');

%Respuesta al escalón
load('escalon_v1.mat');

t0 = 4.9;
a = 1;
fig2 = figure;
[y, tstep] = step(10 * T);
plot(tstep, y, 'r--'); hold on;
plot(t - t0, a * posicion, 'b-'); grid On;
yline(10, 'k--');

xlim([0, 10]);
ylim([0, 24]);
xlabel('Tiempo [s]');
ylabel('Posición [cm]');

legend('Simulación', 'Medición');
title('Respuesta al escalón');

saveas(fig2, 'proporcional-respuesta al escalón.png');


%Bode de L

fig3 = figure;

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

saveas(fig3, 'Proporcional-Bode de L.png');