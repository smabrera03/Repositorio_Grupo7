close all; clear all;

a = -0.099863;
p = 10.14;
P = zpk([0], [p, -p], a);

kp = 1000*10;
ki = 10038;
kd = 0.98996;

s = tf('s');
%Cont = -200*(kp + ki * 1/s + kd * s) / (s + 1000);

Cont = -(kp + ki * 1/s + kd * s);

L = minreal(Cont* P);

figure();
bode(L); grid on;
title('Bode de L');

T = minreal(L/(1+L));

figure;
step(T);

A = [0, 1;
        p^2, 0];
    
B = [0;
        1];
    
C = [0, a];

D = 0;

sys = ss(A, B, C, D);

x0 = [0; deg2rad(5)/a];

C_dig = c2d(Cont, 20e-3, 'tustin');

Cp = pid(Cont);

Cp.Kp

Cp.Ki

Cp.Kd


