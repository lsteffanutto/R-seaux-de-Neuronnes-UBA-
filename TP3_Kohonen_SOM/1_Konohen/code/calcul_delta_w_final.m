function [ res ] = calcul_delta_w_final( eta,matrice_fonction_voisin,input,red )

red_x=red(:,:,1);
red_y=red(:,:,2);

nb_neu = length(red)*length(red);
nb_input = length(input);
x_input = input(1,1);
y_input = input(1,2);

res=zeros(sqrt(nb_neu),sqrt(nb_neu),2);
delta_x_red = zeros(sqrt(nb_neu),sqrt(nb_neu));
delta_y_red = zeros(sqrt(nb_neu),sqrt(nb_neu));

delta_x_red = eta*matrice_fonction_voisin.*(x_input-red_x);
delta_y_red = eta*matrice_fonction_voisin.*(y_input-red_y);

res(:,:,1)=delta_x_red;
res(:,:,2)=delta_y_red;

end

