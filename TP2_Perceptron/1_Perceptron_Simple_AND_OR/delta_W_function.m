function [ deltaw0 deltaw1 deltaw2 ] = delta_W_function( eta, X, yd, y) 

deltaw0 = eta*X(1,1)*(yd-y);
deltaw1 = eta*X(1,2)*(yd-y);
deltaw2 = eta*X(1,3)*(yd-y);

end

