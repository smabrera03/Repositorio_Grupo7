clear; clc;
k = 11.4354;
p1 = -4.868 + 3.0735*i;
p2 = conj(p1);

Ass = [0 1;
           -p1*p2 p1+p2];
       
 Bss = [0; k];
 
 Css = [1 0];
 
 Dss = 0;
 
 Ts = 0.02;
 
 Ad = eye(2) + Ass*Ts;
 Bd = Bss*Ts;
 Cd = Css;
 Dd = Dss;
 
 Add = [Ad, [0;0]; [0, 0], [1]];
 Bdd = [Bd; [0]];
 Cdd = [Cd, [0]; [0, 1, 1]];
 Ddd = Dd;
 
 polos_obs = [-200, -201, -0.7];
 polos_obs_dis = exp(Ts*polos_obs);
 
 L = (place(Add', Cdd', polos_obs_dis))';
 