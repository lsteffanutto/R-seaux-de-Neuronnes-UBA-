function [ image_nique ] = full_bruit(l,h )
%return un pattern aleatoire avec des -1 et 1
image_nique = rand(l,h);
image_nique = image_nique>0.5;
image_nique = image_nique.*2-1;

end

