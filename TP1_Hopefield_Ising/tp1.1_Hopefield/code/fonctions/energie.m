function [ h ] = energie( W , output) %calcul l'énergie de l'itération où l'on se trouve

h=0;
output_t=output';

% crossoutput = output*output'
% h = W*crossoutput;

for i = 1:length(W)
    for j = 1:length(W)
        
        h = h + W(i,j)*output(i,1)*output_t(1,j)';
        
    end
end

h = -0.5*h;
