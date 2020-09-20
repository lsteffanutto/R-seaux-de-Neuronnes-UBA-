clear all;
close all;
clc;

%% VAR

n_input = 1000
nb_neu = 100

nb_epoch = 100;
nb_tours = nb_epoch*n_input;


intervalle_depart_wi = [-0.1,0.1]; %Deltas w ~N(0,0.01)
% intervalle_depart_wi = [-1,1]; %Deltas w ~N(0,0.01)
% sigma=0.1;
sigma=0.11;

alpha_sigma=0.9995;

eta=0.01;

%VECTEUR INPUT
X_input = random_unit_cercle(n_input,0,0,1);
hold on;
plot(X_input(:,1),X_input(:,2),'.');
title('red depart / red arrive');
plot_circle( 0,0,1 );

%INIT RED
red = random_carre_intervalle_final(intervalle_depart_wi,nb_neu);
red_init=red;
plot(red_init(:,:,1),red_init(:,:,2),'g+');
drawnow
%% TRAITEMENT 

num_input_aleatoire =randperm(n_input)'; % mezclar el orden de los inputs

% num_test=1;
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
    C=C/n_input;
    Cstock = [ Cstock C ];
    C=0;
    
else
    num_test=mod(tour,n_input); % si tours>nb_input
end

input = X_input(num_input_aleatoire(num_test,1),:); %input al azar en X_input
x_input = input(1,1);
y_input = input(1,2);
% plot(x_input,y_input,'mX','MarkerSize',10,'linewidth',3);%print input

%calcul distancia euclidienne Input/Neuronas
[dist_min , pos_neu] = find_dist_min_y_pos_final(input,red);
x_output=red(pos_neu);
y_output=red(nb_neu+pos_neu);
% plot(x_output,y_output,'yo','MarkerSize',10,'linewidth',3);%print output qui s'active avec input

%calcul distance euclidienne Neu* / Neu
winner = [ x_output y_output];
mat_dist_win_otro = dist_winner_other_final(winner,red);

%Vecinidad fonction
matrice_fonction_voisin = fonction_voisin(mat_dist_win_otro,sigma);

%Calcul deltaW
delta_red = calcul_delta_w_final( eta,matrice_fonction_voisin,input,red );

%Actualizacion w
red = red + delta_red;
% plot(red(:,:,1),red(:,:,2),'ro');

sigma=alpha_sigma*sigma;

C = C + mean(mean( matrice_fonction_voisin*sqrt( (x_input-red(:,:,1)).^2 + (y_input-red(:,:,2)).^2)  ));
% if cpt == nb_tours/4
% plot(red(:,:,1),red(:,:,2),'kx');
% drawnow;
% pause(0.5);
% end

% if cpt == nb_tours/2
% plot(red(:,:,1),red(:,:,2),'b*');
% % plot(red(:,:,1),red(:,:,2));
% % plot(red(:,:,1)',red(:,:,2)');
% drawnow;
% pause(0.5);
% end

end


%plot red ini
% plot(red_init(:,:,1),red_init(:,:,2),'g+');
% plot(red_init(:,:,1),red_init(:,:,2));
% plot(red_init(:,:,1)',red_init(:,:,2)');

%plot red finale
plot(red(:,:,1),red(:,:,2),'ro');
title('reds start and red finale');

% plot(red(:,:,1),red(:,:,2));
% plot(red(:,:,1)',red(:,:,2)');

% red(:,:,1)=red(:,:,1)';
% red(:,:,2)=red(:,:,2)';

% plot(red(1:nb_neu)',red(nb_neu+1:nb_neu*2)');




figure,plot(1:nb_epoch,Cstock)
title('C');
xlabel('iterations');
ylabel('C');