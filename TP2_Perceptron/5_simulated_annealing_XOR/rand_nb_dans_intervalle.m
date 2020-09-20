function [ rand_nb ] = rand_nb_dans_intervalle( intervalle )

rand_nb = intervalle(1)+diff(intervalle)*rand;

end

