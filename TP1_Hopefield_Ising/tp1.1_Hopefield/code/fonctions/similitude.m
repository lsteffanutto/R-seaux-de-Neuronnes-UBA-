function [ pareil, nb_differences ] = similitude( A , B )
pareil=0;
nb_differences=0;

if A==B    %si pareil
   pareil=1; 
   return;
end

if size(A) == size(B)
    
    [lignes,colonnes] = size(A);
    
    for i = 1:lignes
        for j = 1:colonnes
            
            if A(i,j)~=B(i,j)
                nb_differences = nb_differences +1;
            end
            
        end
    end
    return;
end

if size(A) ~= size(B) %si pas la même dimention
    return;
end





end

