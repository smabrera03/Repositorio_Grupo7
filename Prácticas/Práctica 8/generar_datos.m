close all;

angulo = double(out.angulo);
referencia = double(out.referencia);
t = double(out.tout);

save('polos_rapidos', 'angulo', 'referencia', 't');