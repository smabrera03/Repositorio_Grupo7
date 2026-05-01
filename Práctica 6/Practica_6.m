close all; clear all;

a = -0.099863;
p = 10.14;
P = zpk([0], [p, -p], a);


Ass = [0, 1;
        p^2, 0];
    
Bss = [0;
        1];
    
Css = [0, a];

Dss = 0;

sys = ss(Ass, Bss, Css, Dss);

x0 = [0; deg2rad(5)/a];





