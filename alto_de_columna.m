function [ alto ] = alto_de_columna( inicio_j, columna, fin_j )
%ALTO_COLUMNA Summary of this function goes here
%   Detailed explanation goes here
j = uint64(inicio_j);
while columna(j) == 0 && j < fin_j
    j = j + 1;
end
ultimo_k = j;
k = j;
while k < fin_j
    if (columna(k) ~= 0)
        ultimo_k = k;
    end
    k = k + 1;
end
alto = ultimo_k - j;

end

