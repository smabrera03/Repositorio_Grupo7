close all; clear; clc;

Ass = [0 1 0 0;
    -33.1549 -9.7360 0 0;
    0 0 0 1;
    35.9445 0 0 -10];

Bss = [0; 11.4345; 0; 0];

Css = [0 0 1 0; 
            1 0 0 0];

Dss = [0;0];

O = [Css;
        Css*Ass;
        Css*Ass^2;
        Css*Ass^3];
    
Controlabilidad = [Bss, Ass*Bss, Ass^2*Bss, Ass^3*Bss];

rango_O = rank(O); %Observable

rango_C = rank(Controlabilidad); %Controlable


Ts = 0.02;
Ad = eye(4) + Ass*Ts;
Bd = Bss*Ts;
Cd = Css;
Dd = Dss;

polos_obs_cont = [-50, -40, -20, -10]; %Una década más rápidos que la dinámica más rápida de la planta
%NOTA: Los polos tienen que ser menores que 50 Hz*2 * pi/2 = 157.08 rad/s.
%De otra forma, le pediriamos al observador una dinámica mayor a la que nos
%permite la tasa de muestreo
%{
elegimos los polos para que sean más rápidos que el polo más rápido de 
cada transferencia (3 o 4 veces como mínimo). Igual mucho no cambia
El de 150 lo ajustamos por lo que veíamos en el gráfico. Esa dinámica del
observador era muy lenta. Es decir, hicimos los polos 3 o 4 veces más
rápido y después ajustamos en base al gráfico.
%}
polos_obs_dis = exp(Ts*polos_obs_cont);

L = place(Ad', Cd', polos_obs_dis)';


printBLA(L, 'L');


