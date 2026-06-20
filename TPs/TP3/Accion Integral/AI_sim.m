close all; clear;

Ass = [0 1 0 0;
    -33.1549 -9.7360 0 0;
    0 0 0 1;
    35.9445 0 0 -10];

Bss = [0; 11.4345; 0; 0];

Css = [0 0 1 0];

Dss = [0];

Ts = 0.02;
Ad = eye(4) + Ass*Ts;
Bd = Bss*Ts;
Cd = Css;
Dd = Dss;

K_hat = [8.3705    0.5610    8.9671    0.7008  -11.6105];

cero_4x1 = [0; 0; 0; 0];
Ad_au = [Ad, cero_4x1; 
                -Cd * Ts, eye(1)]  - [Bd;0] * K_hat;
            
Bd_au = [0; 0; 0; 0; Ts];
Cd_au = [Cd, 0];
Dd_au = Dd;

sysd = ss(Ad_au, Bd_au, Cd_au, Dd_au, Ts);

load('AI_datos', 'ref', 't', 'pos_obs');

[~, ~, x_au] = lsim(sysd, ref, t);

ang_sim = x_au(:, 1);
velang_sim = x_au(:, 2);
pos_sim = x_au(:, 3);
vel_sim = x_au(:, 4);
int_sim = x_au(:, 5);

save('AI_sim.mat' ,'ang_sim', 'velang_sim', 'pos_sim', 'vel_sim', 'int_sim');
