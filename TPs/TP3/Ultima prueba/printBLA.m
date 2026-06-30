function printBLA(M, nombre)
% PRINTBLA Imprime una matriz en formato BasicLinearAlgebra para Arduino.
%
% Uso:
%   printBLA(M)
%   printBLA(M, 'Ad')
%
% Ejemplo:
%   Ad = [1.2 3.4; 5.6 7.8];
%   printBLA(Ad, 'Ad');

    if nargin < 2
        nombre = 'M';
    end

    [m,n] = size(M);

    fprintf('Matrix<%d,%d> %s = {\n', m, n, nombre);

    for i = 1:m
        for j = 1:n
            if i == m && j == n
                fprintf('%.10f', M(i,j));
            else
                fprintf('%.10f, ', M(i,j));
            end
        end
        fprintf('\n');
    end

    fprintf('};\n');
end