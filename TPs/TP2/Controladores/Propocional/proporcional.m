close all; clear;
k1 = 11.4345;
g = 9.807;
k2 = 100 * pi/180 * g;
k = k1 * k2;
p1 = -3;
p2 = -4.8680 + 3.0753i;

P = zpk([], [0 p1 p2 conj(p2)], k);

figure;
rlocus(P); %Vemos que k < 2.17

Ts = 0.02;
pade = zpk([4/Ts], [-4/Ts], -1);

opt = bodeoptions;

opt.PhaseMatching = 'On';
opt.PhaseMatchingValue = -90;
opt.PhaseMatchingFreq = 0.1;

figure;
bode(1 * P * pade, opt); 
grid on;

kp = 0.7; %Probar valores entre 0.3 y 0.7

C = kp;
Cd = c2d(C, 'tustin', Ts);
L = minreal(P * C);
T = minreal(L/(1 + L));

figure;
step(T); grid on;

sys_ss = ss(P);
[Ass, Bss, Css, Dss] = ssdata(sys_ss);

pos0 = 5/Css(1);
x0 = [pos0 0 0 0];
