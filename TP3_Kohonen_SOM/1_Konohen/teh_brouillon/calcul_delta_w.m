function [ res ] = calcul_delta_w( eta,matrice_fonction_voisin,input,red )

nb_neu = length(red);
nb_input = length(input);
x_input = input(1,1);
y_input = input(1,2);

res=zeros(nb_neu,nb_input);
delta_x_red = zeros(nb_neu,1);
delta_y_red = zeros(nb_neu,1);

delta_x_red = eta*matrice_fonction_voisin.*(x_input-red(:,1));
delta_y_red = eta*matrice_fonction_voisin.*(y_input-red(:,2));

res = [ delta_x_red delta_y_red];

end

