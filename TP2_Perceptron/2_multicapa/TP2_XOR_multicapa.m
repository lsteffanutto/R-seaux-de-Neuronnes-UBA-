clear all;
close all;
clc;
%% VAR

matrice_XOR = XOR_matrix();
figure,plot_matrix_type( matrice_XOR );

eta = 0.01;
cpt_tour=0;
x0=1;

nb_layer=2; %On compte hidden layer et output

size_input=2; %nb pattern entrée
size_layer1=2; %nb neuronne layer1
size_layer2=1; %nb output

nb_co_pattern_input_to_layer1=2; %4 connexions d'un pattern input to un 
nb_co_pattern_layer1_to_output=1; %1 connexion d'un Vi to un Vi output

%stocker les h_output et output;
h_output=zeros(size_layer2,1);
output=h_output;
%stocker les h et V des hidden layers
h =zeros(size_layer1,nb_layer-1); 
V = h; %stocker les V du layer

%stocker les deltas du network
delta1=zeros(size_layer1,nb_layer-1); %delta layer
delta_output=zeros(size_layer2,1);
delta = [delta1]; 
deltaw=zeros(3,2);
deltaW=zeros(3,1);
s_deltaw=deltaw;
s_deltaW=deltaW;

%stocker les coeff wi input to layer1 de chaque patron
w = make_w_of_layer( nb_co_pattern_input_to_layer1, size_input );
w = [ random_w_colonne(size_input)' ;w ];
winit = w; %chaque colonne contient les wi du pattern concerne aux Vi suivant

%Tous les coeff W du layer1 to output de pour chaque Vi
W = make_w_of_layer( size_layer1,nb_co_pattern_layer1_to_output);
W = [ random_w_colonne(size_layer2) W'];
Winit = W;

X_entrada=[]; 
X_entrada = [ X_entrada ones(4,1) matrice_XOR(:,1:2) ]; % matrices avec les différentes entrées possibles

Yd = [ matrice_XOR(:,3)]; % les sorties désirées

abscisse = [-2:0.1:2];
droite1 = (-w(1,1)/w(3,1))-(w(2,1)/w(3,1))*abscisse;
droite2 = (-w(1,2)/w(3,2))-(w(2,2)/w(3,2))*abscisse;
% plot( abscisse,droite1 );
% plot( abscisse,droite2 );

for tour=1:10000
    
for num_patron = 1:4
random_num = randi([1 4],1,1); %nb aleatoire entre 1 et 4 pour choisir un numero de pattern aleatoire
X_input = [ X_entrada(random_num,:) ]; % input aleatoire d'un des 4 patterns

% X_input = [ X_entrada(num_patron,:) ];

%% TRAITEMENT


%On test déjà avec le premier pattern 
cpt_tour=cpt_tour+1;

% Layer computing (Vi);
for num_input = 1:size_input
    if num_input ==1    
        h(num_input,1)= X_input(1,1:2)*w(1:2,num_input); %E1,1 avec les deux premiere co w
        h(num_input,1)=h(num_input,1)+(X_input(1,3)*w(2,2)); %E2 avec la 2eme co 2eme colonne w
        V(num_input,1) = tanh(h(num_input,1));
    else
        h(num_input,1)= X_input(1,1)*w(1,num_input); %1 et E2 avec w1 et w3 de la 2eme colone
        h(num_input,1)= h(num_input,1) + (X_input(1,3)*w(3,num_input)); 
        h(num_input,1)= h(num_input,1) + (X_input(1,2)*w(3,1)); % E1 avec w3 de la 1ere colonne
        V(num_input,1) = tanh(h(num_input,1));
    end
end

% Output computing (Oi);
% for num_V = 1:size_layer1
Vsortie = [ x0 ; V];        
h_output= W*Vsortie; %On test juste avec un pattern et ses connexion pas avec les autres
output = tanh(h_output); %g(h)

% end

% delta Output computing;
delta_output= (1-(output^2))*(Yd(random_num,1)-output);%g'(h)(désiré-output)
% delta_output= (1-(output^2))*(Yd(num_patron,1)-output);%g'(h)(désiré-output)

% error back propagation Vi
delta1 = (ones(2,1)-(tanh(h).^2)).*W(1,2:3)'*delta_output; %g'(h)*W*delta
delta=[delta1];

%Calcul deltaw;
for num_input = 1:size_input
    
    %mise à jour pattern source de delta1
    if num_input ==1
        deltaw(1:2,num_input)= eta*delta(num_input,1)*X_input(1,1:2)'; %eta*delta*le pattern source,avec 1 et E1, deltaw1/2 1ere colonne
        deltaw(2,2)= eta*delta(num_input,1)*X_input(1,3); %avec E2 et 2eme w 2eme colonne deltaw2 2eme colonne
    else %mise à jour pattern source de delta2
        deltaw(3,1)= eta*delta(num_input,1)*X_input(1,2); %E1 et w3 1ere colonne pour deltaw3 1ere colonne
        deltaw(1,num_input)= eta*delta(num_input,1)*X_input(1,1); %delta1/3 2eme colonne
        deltaw(3,num_input)= eta*delta(num_input,1)*X_input(1,3); %deltaw 2eme colonne
    end
end
s_deltaw=s_deltaw+deltaw; %deltaw pour chaque patrons

%Calcul deltaW;
deltaW=eta*Vsortie'*delta_output;
s_deltaW=s_deltaW+deltaW; % on sommes les deltaW pour chaque patron

end
%Update w et W
w=w+deltaw;
W=W+deltaW;
end

droite3 = (-w(1,1)/w(3,1))-(w(2,1)/w(3,1))*abscisse;
droite4 = (-w(1,2)/w(3,2))-(w(2,2)/w(3,2))*abscisse;

% droite3 = (-w(1,1)/w(2,2))-(w(2,1)/w(2,2))*abscisse; %Toutes co vers V1/2
% droite4 = (-w(1,2)/w(3,2))-(w(2,1)/w(3,2))*abscisse;

droite5 = (-W(1,1)/W(1,3))-(W(1,1)/W(1,2))*abscisse;
plot( abscisse,droite3 );
plot( abscisse,droite4 );


