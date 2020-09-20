function [ vect ] = random_vect_in_the_intervalle( nb_sample , xmin , xmax)

vect = [];

x=xmin+rand(nb_sample,1)*(xmax-xmin);

vect = [vect x];


end

