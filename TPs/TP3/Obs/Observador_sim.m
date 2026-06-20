clear; close all;

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

sysd = ss(Ad, Bd, Cd, Dd, Ts);

load('Observador_datos.mat', 'uk', 't');

[y ,t , x] = lsim(sysd, uk, t);

ang_sim = x(:, 1);
velang_sim = x(:, 2);
pos_sim = x(:, 3);
vel_sim = x(:, 4);

save('Observador_simulado.mat', 'ang_sim', 'velang_sim', 'pos_sim', 'vel_sim');

