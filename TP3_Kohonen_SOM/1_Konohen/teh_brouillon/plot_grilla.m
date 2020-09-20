function [ res ] = plot_grilla( red, cote )

res=1;
taille_red = length(red);
red_res=zeros(cote,cote,2)

red


[red_res(1,1,:), index] = min(red);

red_res

red = red([1:index-1, index+1:end])
% [red_res(cote,cote,:), index] = max(red);

% for j=1:cote
        
    
    
%         value = min(red(:,2)) %min des y => ligne du haut
%                 
%         index = find(red(:,2)==value)     % on choppe abscisse ordonnée concerné
%         plot = [plot ; red(index,1) red(index,2) ];   %ajoute à la matrice
%         red = red([1:index-1, index+1:end]);      % on supprime la valeur qu'on a ajouté
        
% end


