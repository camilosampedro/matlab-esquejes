function [ alto ] = alto_de_columna( inicio_j, columna, fin_j )
j = uint64(inicio_j);               % Tomar la primera fila de la columna
while columna(j) == 0 && j < fin_j  % Mientras no haya un pixel en la
                                    % máscara y no se haya llegado a la
                                    % última fila
    j = j + 1;                      % Avanzar j
end
ultimo_k = j;                       % Guardar esta j encontrada
k = j;                              % Inicializar k (Segundo apuntador) en
                                    % donde vaya j
while k < fin_j                     % Mientras no se haya llegado a la 
                                    % última fila
    if (columna(k) ~= 0)            % Si k ya no es igual a cero, marcar
        ultimo_k = k;               % esta posición
    end
    k = k + 1;                      % Avanzar siempre
end
alto = ultimo_k - j;                % El alto es igual entonces a la última
end                                 % marca de k menos la última j