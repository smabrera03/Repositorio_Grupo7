p1 = -13.2515;
p2 = -32.6059;
k = 138.9035;
%Nota: volvimos a modelar la planta y ahora tenemos otros polos. De todos
%modos, sabemos que anda así que no lo cambiamos
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
 
 polos_obs = [-200, -201];
 polos_obs_dis = exp(Ts*polos_obs);
 
 L = (place(Ad', Cd', polos_obs_dis))';
 
 