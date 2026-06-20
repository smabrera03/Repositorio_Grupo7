close all; clear;

Ass = [0 1 0 0;
    -33.1549 -9.7360 0 0;
    0 0 0 1;
    35.9445 0 0 -10];

Bss = [0; 11.4345; 0; 0];

Css = [0 0 1 0; 
            1 0 0 0];

Dss = [0;0];

Ts = 0.02;
Ad = eye(4) + Ass*Ts;
Bd = Bss*Ts;
Cd = Css;
Dd = Dss;


p1 = -10;
norm_p2 = 5;
ang_p2 = pi/180 * (180 - 80);
p2 = norm_p2 * exp(i * ang_p2);

factor_amortiguamiento = -real(p2)/abs(p2);

 polos_realim_cont = [p1, p1 - 0.1, p2, conj(p2)];
 
%{
 Elección de los polos: 
 Primero pensamos en polos reales, pero ello significaría no tener
 overshoot, lo que es muy exigente para esta planta. Necesitamos polos
 complejos conjugados en la posición. 
 
 Los polos del ángulo pueden ser reales (críticamente amortiguado), como ya
 lo eran.
 
 Elejimos los los módulos para que la acción de control de sea demasiado
 violenta (prueba y error)
 %}
 polos_realim_dis = exp(Ts*polos_realim_cont);
 
 K = place(Ad, Bd, polos_realim_dis);

 inversa = inv(eye(4) - (Ad - Bd*K));
 printBLA(K, 'K');
F1 = inv(Cd(1, :) * inversa * Bd);
F2 = inv(Cd(2, :) * inversa * Bd);
%Obs: Cd(2, :) * inversa * Bd = 0
F = [F1, 0];