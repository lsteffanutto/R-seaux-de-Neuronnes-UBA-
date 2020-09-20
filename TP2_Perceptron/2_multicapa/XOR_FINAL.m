clear all;
close all;
clc;

%% VAR

matrice_XOR = XOR_matrix();
figure,plot_matrix_type( matrice_XOR );

eta = 0.01;
cpt_tour=0;
x0=1;

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

%droite initiales
abscisse = [-2:0.1:2];
droite1 = (-w10_1/w12_1)-(w11_1/w12_1)*abscisse;
droite2 = (-w20_1/w22_1)-(w21_1/w22_1)*abscisse;
% plot( abscisse,droite1 );
% plot( abscisse,droite2 );
%% TRAITEMENT
Eplot=[];
E=1;
while E>0.00001
    
cpt_tour=cpt_tour+1;
%Pour stocker les deltaw, qu'on remet à 0 qd fait les 4 patrons
sd_w10_1=0;
sd_w11_1=0;
sd_w12_1=0;
sd_w20_1=0;
sd_w21_1=0;
sd_w22_1=0;
sd_w10_2=0;
sd_w11_2=0;
sd_w12_2=0;   

rand_num_patron=randperm(4); % on va permuter aleatoirement ordre 4 vecteurs

for num_patron = 1:4
% num_patron=1;
patron_test = rand_num_patron(1,num_patron); %on test chaque vecteur dans ordre aleatoire
X_input = [ X_entrada(patron_test,:) ];
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
E = 0.5*((Yd(patron_test,1)-output).^2);
if mod(cpt_tour,2000)==0
    Eplot = [ Eplot; cpt_tour E];
end

%Deltas %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
delta_output=(1-(tanh(h_output)^2))*(Yd(patron_test,1)-output);%g'(h)(désiré-output)

delta1=(1-(tanh(h1)^2))*(w11_2*delta_output);
delta2=(1-(tanh(h2)^2))*(w12_2*delta_output);

%Delta w %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
d_w10_1 = eta*delta1*x0; %ceux allant vers V1
d_w11_1 = eta*delta1*E1;
d_w12_1 = eta*delta1*E2;

d_w20_1 = eta*delta2*x0; %ceux allant vers V2
d_w21_1 = eta*delta2*E1;
d_w22_1 = eta*delta2*E2;

d_w10_2 = eta*delta_output*x0; %ceux allant vers output
d_w11_2 = eta*delta_output*V1;
d_w12_2 = eta*delta_output*V2;

%Sommes des delta_w %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sd_w10_1 = sd_w10_1 + d_w10_1; %ceux allant vers V1
sd_w11_1 = sd_w11_1 + d_w11_1;
sd_w12_1 = sd_w12_1 + d_w12_1;

sd_w20_1 = sd_w20_1 + d_w20_1; %ceux allant vers V2
sd_w21_1 = sd_w21_1 + d_w21_1;
sd_w22_1 = sd_w22_1 + d_w22_1;

sd_w10_2 = sd_w10_2 + d_w10_2; %ceux allant vers output
sd_w11_2 = sd_w11_2 + d_w11_2;
sd_w12_2 = sd_w12_2 + d_w12_2;

end

%On actualise les w quand on a fait les 4 patterns
w10_1 = w10_1 + sd_w10_1; %ceux allant vers V1
w11_1 = w11_1 + sd_w11_1;
w12_1 = w12_1 + sd_w12_1;

w20_1 = w20_1 + sd_w20_1; %ceux allant vers V2
w21_1 = w21_1 + sd_w21_1;
w22_1 = w22_1 + sd_w22_1;

w10_2 = w10_2 + sd_w10_2; %ceux allant vers output
w11_2 = w11_2 + sd_w11_2;
w12_2 = w12_2 + sd_w12_2;

%Puis on recommence
end
%% FIGURE

%le bon
droite3 = (-w10_1/w12_1)-(w11_1/w12_1)*abscisse; %toutes les co vers V1/2
droite4 = (-w20_1/w22_1)-(w21_1/w22_1)*abscisse;

%test
% droite3 = (-w10_1/w21_1)-(w11_1/w21_1)*abscisse; %toutes les co partant de E1 et E2
% droite4 = (-w20_1/w12_1)-(w12_1/w22_1)*abscisse;

plot( abscisse,droite3 );
plot( abscisse,droite4 );
title('perceptron XOR');

X_energie=Eplot(:,1);
Y_energie=Eplot(:,2);
figure,plot( X_energie,Y_energie );
title('Energie perceptron XOR');
xlabel('nombre de fois tour des 4 patrons');
ylabel('Energie');