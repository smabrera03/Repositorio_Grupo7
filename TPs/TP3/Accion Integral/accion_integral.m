close all; clear;

Ass = [0 1 0 0;
    -33.1549 -9.7360 0 0;
    0 0 0 1;
    35.9445 0 0 -10];

Bss = [0; 11.4345; 0; 0];

Css = [0 0 1 0];

Dss = [0;0];

Ts = 0.02;
Ad = eye(4) + Ass*Ts;
Bd = Bss*Ts;
Cd = Css;
Dd = Dss;

cero_4x1 = [0; 0; 0; 0];

Ad_hat = [Ad, cero_4x1; 
                -Cd * Ts, eye(1)];
            
Bd_hat = [Bd; 0];

norm_p1 = 12.2;
ang_p1 = pi/180 * (180 - 26);

p1 = norm_p1 * exp(i * ang_p1);
p2 = conj(p1);

norm_p3 = 4.5;
ang_p3 = pi/180 * (180 - 77);
p3 = norm_p3 * exp(i * ang_p3);
p4 = conj(p3);

p5 = -1.33;

polos_cont = [p1, p2, p3, p4, p5];
polos_dis = exp(Ts * polos_cont);

zeta = -real(p2)/abs(p2);
Mp = exp(-zeta * pi /(sqrt(1 - zeta^2))) * 100

K_hat = place(Ad_hat, Bd_hat, polos_dis);
K = K_hat(1:4);
printBLA(K, 'K');
H = K_hat(5)