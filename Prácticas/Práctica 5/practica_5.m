clear all; close all; clc;

p = -0.002397;
k = -0.004233;
P = zpk([], [p], k);

opt = bodeoptions;

opt.PhaseMatching = 'On';
opt.PhaseMatchingFreq = 0.001;
opt.PhaseMatchingValue = -180;

figure('Name', 'Bode de P(s)');
bode(P, opt); grid On;

s = tf('s');

kp = -1 * 5;
ki = p * 5;
C = kp + ki/s; % kp + ki/s = kp *(s + ki/kp)/s

L = C * P;

figure('Name', 'Bode de L(s)');
bode(L, opt); grid On;

S = minreal(1/(1 + L));
C_P = minreal(C * S);
T = minreal(L * S);

figure('Name', 'Rta escalón T');
step((-0.05) * T); grid On;

figure('Name', 'Acción de control');
step((-0.05) * C_P); grid On; %En la planta linealizada, la acción de control u está limitada entre -0.5 y 0.5

Ts = 1;
z = tf('z', Ts);
s_back = (z - 1) / (z * Ts);

C_z = kp + ki/s_back

%{

C(z) = (-5.012z + 5)/(z - 1) =  (-5.012 + 5z^-1)/(1 - z^-1) = U/E

(-5.012 + 5z^-1) * E = (1 - z^-1) * u

-5.012 * e(k) + 5 * e(k-1) = u(k) - u(k-1)

u(k) = -5.012 * e(k) + 5 * e(k-1) + u(k-1)

%}




