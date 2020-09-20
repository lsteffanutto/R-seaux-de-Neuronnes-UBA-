function [ red ] = random_carre_intervalle(intervalle_depart_wi,nb_neu)

red = [];
x = [];
y = [];

for i = 1:nb_neu
x = [ x ; rand_nb_dans_intervalle( intervalle_depart_wi )];
y = [ y ; rand_nb_dans_intervalle( intervalle_depart_wi )];
end

red = [ x y ]; %on les mets en colonne
% Check
%figure,scatter(x,y,'b.');
% MRC Bruno la zone en personne

end

