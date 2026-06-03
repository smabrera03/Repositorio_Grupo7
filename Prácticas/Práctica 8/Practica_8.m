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
 
 figure;
 bode(P); grid On;
 Ts = 0.02;
 
 Ad = eye(2) + Ass*Ts;
 Bd = Bss*Ts;
 Cd = Css;
 Dd = Dss;
 
 polos_obs_cont = [-60, -61]; %Anda con -60
 polos_obs_dis = exp(Ts*polos_obs_cont);
 
 L = (place(Ad', Cd', polos_obs_dis))'
 
 polos_realim_cont = [-6, -0.6];
 polos_realim_dis = exp(Ts*polos_realim_cont);
 
 K = place(Ad, Bd, polos_realim_dis)
 
 K = [-2, -0.3];
inversa = inv(eye(2) - (Ad + Bd*K));
F = inv(Cd * inversa * Bd) %Está todo mal