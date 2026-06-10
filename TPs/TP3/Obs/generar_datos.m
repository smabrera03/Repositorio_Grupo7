t = double(out.tout);
uk = double(out.uk);

posiciones = double(out.posiciones);
pos_medida = posiciones(:, 1);
pos_obs = posiciones(:, 2);

theta = double(out.theta);
theta_medida = theta(:, 1);
theta_obs = theta(:, 2);

vel_angular = double(out.vel_angular);
vel_angular_medida = vel_angular(:, 1);
vel_angular_obs = vel_angular(:, 2);

vel = double(out.vel);
vel_medida = vel(:, 1);
vel_obs = vel(:, 2);

save('Observador_datos', 't', 'uk', 'pos_medida', 'pos_obs', 'theta_medida', 'theta_obs', 'vel_angular_medida', 'vel_angular_obs', 'vel_medida', 'vel_obs'); %para volcar los datos en un archivo
%Para recuperar: load('datos_sin_carrito.mat');
