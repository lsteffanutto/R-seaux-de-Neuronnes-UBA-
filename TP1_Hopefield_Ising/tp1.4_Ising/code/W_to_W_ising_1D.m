function [ matrix_W_ising_1D ] = W_to_W_ising_1D( matrix_W )

matrix_W_ising_1D = matrix_W;
longueur = size(matrix_W);

 for i = 1:longueur
    for j = 1:longueur
        
        if j~=i-1 & j~=i+1
            
            matrix_W_ising_1D(i,j)=1;
            
        end
        
    end
end

