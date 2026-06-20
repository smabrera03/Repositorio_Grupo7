%{
Simular la evolución natural del sistema ante CCII

1) simular la evolución del sistema ante la entrada uj
2) simular la evolución del sistema a laz cerrado ante CCII
quiero 2
%}

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

K = [ 0.8952    0.0586    4.9511    0.4751];
F = [0 0];

Ad_CL = Ad - Bd*K;
Bd_CL = Bd*F;
Cd_CL = Cd;
Dd_CL = [0 0; 0 0]; %dos entradas: p_ref, ang_ref y dos salidas: ang y pos

sysd = ss(Ad_CL, Bd_CL, Cd_CL, Dd_CL, Ts);

load('realimentacion_datos.mat');

t0 = 4.04; %solo considero los datos a partir de este punto
[~, t0_idx] = min(abs(t - t0));
t = t(t0_idx:end);

%Condiciones iniciales:
x0 = [ang_obs(t0_idx), velang_obs(t0_idx), pos_obs(t0_idx), vel_obs(t0_idx)];

%referencia nula:
ref = zeros(2, length(t));
[y ,t , x] = lsim(sysd, ref, t, x0);


ang_sim = x(:, 1);
velang_sim = x(:, 2);
pos_sim = x(:, 3);
vel_sim = x(:, 4);

uk_sim = -K * x';

save('realimentacion_simulada.mat', 't0', 'uk_sim', 'ang_sim', 'velang_sim', 'pos_sim', 'vel_sim');

