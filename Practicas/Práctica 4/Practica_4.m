close all;
polos = [-13.2515, -32.6059];
k = 138.9035; 
%Valores hallados en 'Identificacion_calculos.m'.

P = zpk([], polos, k);

figure;
bode(P); grid on;
title('Bode planta');

q = db2mag(35);
s = tf('s');
C = q/s; 

figure;
L = C*P;
bode(L); grid on;
title('Bode L');

CS = minreal(C/(1+L));
figure;
step(CS);

T = minreal(L/(1+L));
figure;
step(T);

