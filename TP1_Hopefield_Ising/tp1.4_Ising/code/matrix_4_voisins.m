function  adj = matrix_4_voisins(N,M)
    % Size of adjacency matrix
    MN = M*N;
    adj = zeros(MN,MN);  

    for i=1:N
        for j=1:N
            A = M*(i-1)+j;          %Node # for (i,j) node
            if(j<N)                
                B = M*(i-1)+j+1;    %Node # for node to the right
                adj(A,B) = 1;
                adj(B,A) = 1;
            end
            if(i<M)
                B = M*i+j;          %Node # for node below
                adj(A,B) = 1;       
                adj(B,A) = 1;
            end            
        end
    end    
end