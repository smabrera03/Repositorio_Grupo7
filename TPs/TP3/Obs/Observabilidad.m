close all; clear; clc;


Ass = [0 1 0 0;
    -33.1549 -9.7360 0 0;
    0 0 0 1;
    35.9445 0 0 -10];

Bss = [0; 11.4345; 0; 0];

Css = [1 0 0 0];

Dss = [0];

O = [Css;
        Css*Ass;
        Css*Ass^2;
        Css*Ass^3];
    
Controlabilidad = [Bss, Ass*Bss, Ass^2*Bss, Ass^3*Bss];

disp('Caso C= [1 0 0 0 ]');

disp('Rango de O');
rank(O)
disp('Rango de C');
rank(Controlabilidad)
disp('No observable, controlable');

disp('Caso C = [0 0 1 0]');

Css = [0 0 1 0];

O = [Css;
        Css*Ass;
        Css*Ass^2;
        Css*Ass^3];
    
Controlabilidad = [Bss, Ass*Bss, Ass^2*Bss, Ass^3*Bss];

disp('Rango de O');
rank(O)
disp('Ragno de C');
rank(Controlabilidad),

disp('Controlable y observable');

disp('Caso C = [0 0 1 0; 1 0 0 0] ');

Css = [0 0 1 0;
           1 0 0 0];

O = [Css;
        Css*Ass;
        Css*Ass^2;
        Css*Ass^3];
    
Controlabilidad = [Bss, Ass*Bss, Ass^2*Bss, Ass^3*Bss];

disp('Rango de O');
rank(O)
disp('Ragno de C');
rank(Controlabilidad),

disp('Controlable y observable');

%{
Si se toma solo el ánuglo como salida, no es observable

Si se toma solo la posición como salida es observable

Si se toman ambos, es observable.
%}
