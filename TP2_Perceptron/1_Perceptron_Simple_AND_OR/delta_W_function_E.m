function [ deltaw0 deltaw1 deltaw2 ] = delta_W_function_E( eta, X, yd, y) 
% Yd=Yd';
% Y=Y';
% deltaw0 = eta*X(1,1)*(yd-y);
% deltaw1 = eta*X(1,2)*(yd-y);
% deltaw2 = eta*X(1,3)*(yd-y);
diff = sum(yd-y);
deltaw0 = eta*X(1,1)*diff;
deltaw1 = eta*X(1,2)*diff;
deltaw2 = eta*X(1,3)*diff;

end

