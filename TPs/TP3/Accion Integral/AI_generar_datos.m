t = double(out.tout);
uk = double(out.uk);
qk = double(out.qk);


posiciones = double(out.posiciones);
ref = posiciones(:, 1);
pos_med = posiciones(:, 2);
pos_obs = posiciones(:, 3);

theta = double(out.theta);
ang_med = theta(:, 1);
ang_obs = theta(:, 2);

vel_angular = double(out.vel_angular);
velang_med = vel_angular(:, 1);
velang_obs = vel_angular(:, 2);

vel = double(out.vel);
vel_med = vel(:, 1);
vel_obs = vel(:, 2);

save('AI_datos_corregidos', 't', 'ref', 'qk', 'uk', 'pos_med', 'pos_obs', 'ang_med', 'ang_obs', 'velang_med', 'velang_obs', 'vel_med', 'vel_obs'); %para volcar los datos en un archivo
%Para recuperar: load('datos_sin_carrito.mat');
