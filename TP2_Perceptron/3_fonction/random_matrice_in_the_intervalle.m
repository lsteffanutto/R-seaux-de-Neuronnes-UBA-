function [ matrice ] = random_matrice_in_the_intervalle( nb_sample , nb_colomn, xmin , xmax)

matrice = [];

for i = 1:nb_colomn
    
    matrice = [ matrice random_vect_in_the_intervalle( nb_sample , xmin , xmax) ];


end

end

