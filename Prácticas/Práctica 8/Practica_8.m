k = 11.4345;
p1 = -4.8680 + 3.0753 * i;
p2 = -4.8680 - 3.0753 * i;

Ass = [0 1;
           -p1*p2 p1+p2];
       
 Bss = [0; k];
 
 Css = [1 0];
 
 Dss = 0;

 [num, den] = ss2tf(Ass, Bss, Css, Dss);
 P = tf(num, den);
 
 %figure;
 %bode(P); grid On;
 Ts = 0.02;
 
 Ad = eye(2) + Ass*Ts;
 Bd = Bss*Ts;
 Cd = Css;
 Dd = Dss;
 
 polos_obs_cont = [-60, -61]; %Anda con -60
 polos_obs_dis = exp(Ts*polos_obs_cont);
 
 L = (place(Ad', Cd', polos_obs_dis))'
 
 polos_realim_cont = [-6.5, -6.6];
 polos_realim_dis = exp(Ts*polos_realim_cont);
 
 K = place(Ad, Bd, polos_realim_dis)
 
inversa = inv(eye(2) - (Ad - Bd*K));
F = inv(Cd * inversa * Bd)

load('polos_lentos.mat');

angulo_lentos = angulo;
t_lentos = t;

load('polos_rapidos.mat');

angulo_rapidos = angulo;
t_rapidos = t;

%t_lentos en mas largo que t_rapdios. Recorto los datos de los polos lentos

N = length(t_rapidos);
angulo_lentos = angulo_lentos(1:N);
t = t_lentos(1:N);
referencia = referencia(1:N);

figure;
plot(t, referencia); hold on;
plot(t, angulo_lentos); hold on;
plot(t, angulo_rapidos); 
legend('referencia', 'respuesta lenta', 'respuesta rapida');
grid on;