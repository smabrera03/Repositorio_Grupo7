close all; clear all;

a = -0.099863;
p = 10.14;
P = zpk([0], [p, -p], a);


Ass = [0, 1;
        p^2, 0];
    
Bss = [0;
        1];
    
Css = [0, a];

Dss = 0;

sys = ss(Ass, Bss, Css, Dss);

x0 = [0; deg2rad(5)/a];

Ts = 0.01;

kp = -500;
ki = -5000;
kd = -2
;
N = 1000;

Cont = pid(kp, ki, kd, 1/N);
Contd = c2d(Cont, Ts, 'tustin')
