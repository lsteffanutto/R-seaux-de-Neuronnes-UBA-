clear all;
close all;
clc;
%%%% COMO TP2_2 pero con una differencia en la actualizacion de los w
%%% ( un poco como Ising)
%%% ! no funciona siempre correctamente !
%% VAR

matrice_XOR = XOR_matrix();
figure,plot_matrix_type( matrice_XOR );

T=0.1;
D=0.1;
B=1;
alpha=0.9999;
cpt_tour=0;
x0=1;
E_target=0.00001;
Eplot=[];
pow_D=2;
intervalle = [-(D.^pow_D),D.^pow_D]; %Deltas w ~N(0,0.01)

%% INIT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%ù

%connexion qui vont vers V1
w10_1=randn;
w11_1=randn;
w12_1=randn;

%connexion qui vont vers V2
w20_1=randn;
w21_1=randn;
w22_1=randn;

%connexion qui vont vers output
w10_2=randn;
w11_2=randn;
w12_2=randn;

%entrée et sortie desire
X_entrada=[]; 
X_entrada = [ X_entrada ones(4,1) matrice_XOR(:,1:2) ]; % matrices avec les différentes entrées possibles
Yd = [ matrice_XOR(:,3)]; % les sorties désirées

%droites initiales
abscisse = [-2:0.1:2];
droite1 = (-w10_1/w12_1)-(w11_1/w12_1)*abscisse;
droite2 = (-w20_1/w22_1)-(w21_1/w22_1)*abscisse;
% plot( abscisse,droite1 );
% plot( abscisse,droite2 );

%%%%%%%%%% compute E 1st time %%%%%%%%%%%%%%%%%
E=1;
while E>E_target
cpt_tour = cpt_tour+1;

%%%% On fait lance la red avec un patron au hasard
num_patron_rand=randi([1 4],1,1); % On prend un des 4 patrons au hasard

X_input = [ X_entrada(num_patron_rand,:) ];
E1 = X_input(1,2);
E2 = X_input(1,3);

%Layer1
h1= x0*w10_1+E1*w11_1+E2*w12_1;
h2= x0*w20_1+E1*w21_1+E2*w22_1;
V1=tanh(h1);
V2=tanh(h2);

%Output
h_output = x0*w10_2+V1*w11_2+V2*w12_2;
output = tanh(h_output);

%calcul energie et stock plot
E = 0.5*((Yd(num_patron_rand,1)-output).^2);

if cpt_tour ==1 % premier tour on stock Einit
    Einit=E;
    Eplot = [ Eplot; cpt_tour Einit];
end
%% genere w* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ùù

% %Delta_w pour obtenir le w* %%%%%%%%%%%%%%%%%%%%%%%
%un nombre aleatoire entre [-D^2 ; +D^2]

% for i = 1000000
% cpt_tour = cpt_tour+1;
% 
% num_patron_rand=randi([1 4],1,1); % On prend un des 4 patrons au hasard
% 
% X_input = [ X_entrada(num_patron_rand,:) ];
% E1 = X_input(1,2);
% E2 = X_input(1,3);
% 
% %Layer1
% h1= x0*w10_1+E1*w11_1+E2*w12_1;
% h2= x0*w20_1+E1*w21_1+E2*w22_1;
% V1=tanh(h1);
% V2=tanh(h2);
% 
% %Output
% h_output = x0*w10_2+V1*w11_2+V2*w12_2;
% output = tanh(h_output);
% 
% %calcul energie et stock plot
% E = 0.5*((Yd(num_patron_rand,1)-output).^2);


d_w10_1 = rand_nb_dans_intervalle( intervalle ); %ceux allant vers V1
d_w11_1 = rand_nb_dans_intervalle( intervalle );
d_w12_1 = rand_nb_dans_intervalle( intervalle );

d_w20_1 = rand_nb_dans_intervalle( intervalle ); %ceux allant vers V2
d_w21_1 = rand_nb_dans_intervalle( intervalle );
d_w22_1 = rand_nb_dans_intervalle( intervalle );

d_w10_2 = rand_nb_dans_intervalle( intervalle ); %ceux allant vers output
d_w11_2 = rand_nb_dans_intervalle( intervalle );
d_w12_2 = rand_nb_dans_intervalle( intervalle );

%On calcul w* pour voir si energie descend ou non
w10_1_new = w10_1 + d_w10_1; %ceux allant vers V1
w11_1_new = w11_1 + d_w11_1;
w12_1_new = w12_1 + d_w12_1;

w20_1_new = w20_1 + d_w20_1; %ceux allant vers V2
w21_1_new = w21_1 + d_w21_1;
w22_1_new = w22_1 + d_w22_1;

w10_2_new = w10_2 + d_w10_2; %ceux allant vers output
w11_2_new = w11_2 + d_w11_2;
w12_2_new = w12_2 + d_w12_2;

% on calcul l'output avec les w* %%%%%%%%%%%%

%Layer1
h1= x0*w10_1_new+E1*w11_1_new+E2*w12_1_new;
h2= x0*w20_1_new+E1*w21_1_new+E2*w22_1_new;
V1=tanh(h1);
V2=tanh(h2);

%Output
h_output = x0*w10_2_new+V1*w11_2_new+V2*w12_2_new;
output_new = tanh(h_output);

%%%% On calcul E* pour prendre une décision 
E_new = 0.5*((Yd(num_patron_rand,1)-output_new).^2);

%%% On remplace les w par les w* si E*<E, sinon on les laisse
if E_new<E %Dans ce cas on remplace les w par w* direct
    E=E_new; % si tu changes w par w* alors E=E_new, sinon E stay
    %connexion qui vont vers V1
    w10_1=w10_1_new;
    w11_1=w11_1_new;
    w12_1=w12_1_new;
    %connexion qui vont vers V2
    w20_1=w20_1_new;
    w21_1=w21_1_new;
    w22_1=w22_1_new;
    %connexion qui vont vers output
    w10_2=w10_2_new;
    w11_2=w11_2_new;
    w12_2=w12_2_new;
    
else % sinon on le fait avec une certaine proba
    delta_E = E_new - E;
    loi_proba_expo = exp(-(delta_E)/(B*T));
    changement = test_avec_proba( loi_proba_expo );  % 1 on remplace, 0 on remplace pas et laisse les w
    
    if changement == 1 % si test valide alors on change les w par les w*, sinon on fait 
        
        E=E_new;
        %connexion qui vont vers V1
        w10_1=w10_1_new;
        w11_1=w11_1_new;
        w12_1=w12_1_new;
        %connexion qui vont vers V2
        w20_1=w20_1_new;
        w21_1=w21_1_new;
        w22_1=w22_1_new;
        %connexion qui vont vers output
        w10_2=w10_2_new;
        w11_2=w11_2_new;
        w12_2=w12_2_new;
        
    end
    %si proba pas validé on touche rien
end

T = T*alpha;
Eplot = [ Eplot; cpt_tour E];
% % PLOT pour voir loi de proba de remplacement exp(-(E_new - E)/(B*T));
% x = 0.0001:0.1:10;
% y = (exp(-(x)/(B*T)));
% figure,plot(x,y);
% title('loi proba remplacement');

%Puis on recommence hasta que l'energie baja
end

%% FIGURE

%le bon
droite3 = (-w10_1/w12_1)-(w11_1/w12_1)*abscisse; %toutes les co vers V1/2
droite4 = (-w20_1/w22_1)-(w21_1/w22_1)*abscisse;


plot( abscisse,droite3 );
plot( abscisse,droite4 );
title('perceptron XOR');

X_energie=Eplot(:,1);
Y_energie=Eplot(:,2);
figure,plot( X_energie,Y_energie );
title('Energie perceptron XOR');
xlabel('iterations');
ylabel('Energie');