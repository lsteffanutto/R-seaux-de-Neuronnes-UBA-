function [ res ] = sigmoid( x )
%sigmoid

res = 1 ./ ( 1 + exp( -(x) ) );

end

