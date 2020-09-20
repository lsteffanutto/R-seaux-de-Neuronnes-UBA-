clear all;
close all;
clc;

%% VAR

n_input = 10
nb_neu = 16
cote=sqrt(nb_neu);
nb_epoch = 10;
nb_tours = nb_epoch*n_input;

% sigma=0.0555;
sigma=0.03;

alpha_sigma=0.9999;

intervalle_depart_wi = [0,0.1]; %Deltas w ~N(0,0.01)

eta=0.5;



%VECTEUR INPUT = ciudades
X_input = random_unit_cercle(n_input,0.5,0.5,0.5);
hold on;
plot(X_input(:,1),X_input(:,2),'.');
title('red depart / red arrive');

%INIT RED
red = random_carre_intervalle(intervalle_depart_wi,nb_neu)+0.45;
red_init=red;
plot(red_init(:,1),red_init(:,2),'g+');
drawnow
%% TRAITEMENT 

num_input_aleatoire =randperm(n_input)'; % mezclar el orden de los inputs

cpt=0;
epoch=0;
Cstock=[];
C=0;

for tour = 1:nb_tours

cpt=cpt+1;

if mod(tour,n_input)==0 %on renouvelle à chaque fois les inputs dans ordre aleatoire
%     X_input = random_unit_cercle(n_input);
    num_input_aleatoire =randperm(n_input)';  
    num_test=1;
    epoch=epoch+1;
%     C=C/n_input;
%     Cstock = [ Cstock C ];
%     C=0;
    
else
    num_test=mod(tour,n_input); % si tours>nb_input
end

input = X_input(num_input_aleatoire(num_test,1),:); %input al azar en X_input
x_input = input(1,1);
y_input = input(1,2);
% plot(x_input,y_input,'mX','MarkerSize',10,'linewidth',3);%print input

%calcul distancia euclidienne Input/Neuronas
[dist_min , pos_neu] = find_dist_min_y_pos(input,red);
x_output=red(pos_neu);
y_output=red(nb_neu+pos_neu);
% plot(x_output,y_output,'yo','MarkerSize',10,'linewidth',3);%print output qui s'active avec input

%calcul distance euclidienne Neu* / Neu
winner = [ x_output y_output];
mat_dist_win_otro = dist_winner_other(winner,red);

%Vecinidad fonction
matrice_fonction_voisin = fonction_voisin(mat_dist_win_otro,sigma);

%Calcul deltaW
delta_red = calcul_delta_w( eta,matrice_fonction_voisin,input,red );

%Actualizacion w
red = red + delta_red;
% plot(red(:,:,1),red(:,:,2),'ro');

sigma=alpha_sigma*sigma;


end

%% FIGURES
plot(red(:,1),red(:,2),'ro');

dist = squareform(pdist([red(:,1) red(:,2)]));

for i = 1:nb_neu
    dist(i,i)=1;
end

for i = 1:nb_neu
    
    [dist_ppv index_ppv] = min(dist(i,:));                  %Buscamos el mas cercado vecino
    plot( [red(i,1) red(index_ppv,1)], [red(i,2) red(index_ppv,2)]);    %Conectamos con el
    
%     if i~=1 & i~=nb_neu
        dist(i,index_ppv)=1;
        [dist_ppv index_ppv] = min(dist(i,:));                  %Buscamos el 2nd mas cercano vecino ************
        plot( [red(i,1) red(index_ppv,1)], [red(i,2) red(index_ppv,2)]);    %Conectamos con el
%     end
end



% % Conectamos todos los puntos en el orden
% for i = 1:nb_neu-1
%     plot( [red(i,1) red(i+1,1)], [red(i,2) red(i+1,2)]);
% end
% 
% % Conectamos el ultimo y el primero
% plot([red(1,1) red(cote,1)],[red(1,2) red(cote,2)]);









% plot([red(1,1) red(2,1)],[red(1,2) red(2,2)] );
% plot([red(2,1) red(3,1)],[red(2,2) red(3,2)] );
% plot([red(3,1) red(4,1)],[red(3,2) red(4,2)] );

% plot([red(1,1) red(nb_neu,1)],[red(1,2) red(nb_neu,2)] ); %derniere a la premiere

% plot(red(1,1),red(1,2),'kx')

% plot(red(:,1),red(:,2));
% plot([red(1,1) red(cote,1)],[red(1,2) red(cote,2)]);

% plot([red(1,1) red(2,1)],[red(1,2) red(2,2)]);
% plot([red(2,1) red(3,1)],[red(2,2) red(3,2)]);


