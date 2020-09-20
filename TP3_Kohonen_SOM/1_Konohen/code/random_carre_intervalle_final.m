function [ red ] = random_carre_intervalle_final(intervalle_depart_wi,nb_neu)

red = [];
x = [];
y = [];

for i = 1:sqrt(nb_neu)
    for j = 1:sqrt(nb_neu)

        x(i,j) = rand_nb_dans_intervalle( intervalle_depart_wi );
        y(i,j) = rand_nb_dans_intervalle( intervalle_depart_wi );
        
    end
end

red(:,:,1) = x(:,:); %red 2D
red(:,:,2) = y(:,:);
% Check
% figure,plot(x(:,:),y(:,:),'g+');
% MRC Bruno la zone en personne

end

