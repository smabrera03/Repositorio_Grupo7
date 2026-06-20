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

norm_p1 = 10;
ang_p1 = pi/180 * (180 - 45);

p1 = norm_p1 * exp(i * ang_p1);
p2 = conj(p1);

%POLOS DOMINANTES
norm_p3 = 2.5;
zeta_p3 = 0.6;
p3 = -zeta_p3 * norm_p3 + i * norm_p3 * sqrt(1 - zeta_p3^2);
p4 = conj(p3);

p5 = -10;

polos_cont = [p1, p2, p3, p4, p5];

%{
Criterio para elegir los polos: 
ELEGIR POLOS DOMINANTES PARA LA POSICIÓN (POLOS 3 y 4), que es lo que se quiere controlar
Elegirlos de modo tal que se cumpla con lo pedido (2,5s, 15%OS)
Elegir los otros 3 lejos
%}
polos_dis = exp(Ts * polos_cont);

zeta = -real(p3)/abs(p3);
Mp = exp(-zeta * pi /(sqrt(1 - zeta^2))) * 100

K_hat = place(Ad_hat, Bd_hat, polos_dis);
K = K_hat(1:4);
printBLA(K, 'K');
H = K_hat(5)