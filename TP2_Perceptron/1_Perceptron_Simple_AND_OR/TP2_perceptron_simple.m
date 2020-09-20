clear all;
close all;
clc;

% PARA CAMBIAR DE FUNCION A APRENDER, PONER 1 o 0 linea 12
% PLOT => LINEA AZUL = LINEA INIT ; LINEA ROJA = LINEA FINAL
%% VAR
eta = 0.1;
x0 = 1;
cpt_tour=0;

matrice_AND = AND_matrix();
matrice_OR = OR_matrix();
matrice_test = matrice_AND_sinon_OR(1); % <= !!! 1 = AND_matrix , 0 = OR_matrix !!!
Nb_mu = length(matrice_test); %Nb pattern possible

X_entrada=[]; % matrices avec les différentes entrées possibles
X_entrada = [ X_entrada ones(4,1) matrice_test(:,1:2) ]; %x0 et x1 et x2

Yd = [];
Yd = [ Yd matrice_test(:,3)]; % les sorties désirés

w0=randn;
w1=randn;
w2=randn;
W = [ w0 w1 w2]; % init avec random coeff w
Winit=W;

%% TRAITEMENT

%On calcul E = Erreur quadratique, avant de commencer les etapes 1 to 3
Y = sign( X_entrada*W'); 
E_init = 0.5*(sum((Yd-Y).^2));
E=E_init; % On calcul E avant 

%droite de séparation initiale
figure,plot_matrix_type( matrice_test );
abscisse = [-2:0.1:2];
droite = (-w0/w2)-(w1/w2)*abscisse;
plot( abscisse,droite );

while E>0  
cpt_tour=cpt_tour+1;

random_num = randi([1 4],1,1); %nb aleatoire entre 1 et 4 pour choisir un numero de pattern aleatoire
X_input = [ x0 vect_X( matrice_test, random_num ) ]; % input aleatoire d'un des 4 patterns

yd = Yd(random_num,1); %sortie désiré en fonction du numéro de pattern qu'on a choisi
y = sign( X_input*W'); %sortie obtenue avec l'input aléatoire sera 1 ou -1 

%On calcule deltaW 
[ deltaw0 deltaw1 deltaw2 ] = delta_W_function( eta, X_input, yd, y); 
Wdelta = [ deltaw0 deltaw1 deltaw2];

%pour mettre a jour la matrice W = W + deltaW
W=update_W(W,Wdelta);
w0=W(1,1);
w1=W(1,2);
w2=W(1,3);

%On calcul l'erreur quadratique pour savoir si on doit recommencer ou pas
Y = sign( X_entrada*W'); 
E = 0.5*(sum((Yd-Y).^2));

end

%% FIGURE

%On peut tracer la droite finale, corrige et obtenu avec les coeff w finaux
abscisse = [-2:0.1:2];
droite = (-w0/w2)-(w1/w2)*abscisse;
plot( abscisse,droite);
title('droite final perceptron simple');
xlabel('X1');
ylabel('X2');

%Nb d'etape pour obtenir la classification
cpt_tour 

