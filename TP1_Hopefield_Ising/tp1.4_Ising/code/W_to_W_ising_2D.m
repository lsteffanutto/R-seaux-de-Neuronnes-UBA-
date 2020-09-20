function [ matrix_W_ising_2D ] = W_to_W_ising_2D( matrix_W )

matrix_W_ising_2D = matrix_W;
longueur = size(matrix_W);

 for i = 1:longueur
    for j = 1:longueur
         
         if i==1 & j==1
             matrix_W_ising_2D(i,j)=0;
         end
         
         if i==1 & j~=1
            matrix_W_ising_2D(i,j+1)=1;
            matrix_W_ising_2D(i,j-1)=1;
            matrix_W_ising_2D(i+1,j)=1;
         end
         
         if i==1 & j~=1
            matrix_W_ising_2D(i,j-1)=1;
            matrix_W_ising_2D(i+1,j)=1;
         end
         
         if j==1 & i~=1
            matrix_W_ising_2D(i,j+1)=1;
            matrix_W_ising_2D(i+1,j)=1;
            matrix_W_ising_2D(i-1,j)=1;

         end
         
          if j==1 & i=1
            matrix_W_ising_2D(i,j+1)=1;
            matrix_W_ising_2D(i+1,j)=1;
            matrix_W_ising_2D(i-1,j)=1;

         end
         
        if j==longueur & i~=longueur & i~=1
            matrix_W_ising_2D(i,j-1)=1;
            matrix_W_ising_2D(i+1,j)=1;
            matrix_W_ising_2D(i-1,j)=1;

        end
        
        if i==longueur & j~=longueur
            matrix_W_ising_2D(i,j+1)=1;
            matrix_W_ising_2D(i,j-1)=1;
            matrix_W_ising_2D(i-1,j)=1;
        end
        
         
        if i>1 & j>1 & i<longueur & j<longueur
            
            matrix_W_ising_2D(i,j+1)=1;
            matrix_W_ising_2D(i,j-1)=1;
            matrix_W_ising_2D(i+1,j)=1;
            matrix_W_ising_2D(i-1,j)=1;
            
        end
        
       
    end
end
