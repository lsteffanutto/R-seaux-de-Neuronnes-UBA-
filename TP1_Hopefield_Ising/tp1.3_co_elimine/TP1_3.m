clear all;
close all;
clc;


%% VAR

for pmax = 10:10:20
    
Nneu2=100; % nb neuronnes
cote=sqrt(Nneu2);
%Np=510; % nb pattern
Nb_connexion_total=Nneu2*Nneu2-Nneu2; %N*N-N = 100% connexions
Nb_connexion_suppr=0;
Percentage_Connexions = (Nb_connexion_total-Nb_connexion_suppr)/Nb_connexion_total;
Percentage_Connexions_elimine = 0;
Perror=0.01;
err = 0;
cpt = 0;
nb_pixels_change=0;
C_tab=[];
Percentage_Connexions_tab=[];
Percentage_Connexions_elimine_tab=[];
% nb_tour = 50;

err_tab = [];

%On initialise tout avant avec nb pattern max théorique


    
[ P ] = p_random_pattern( pmax, Nneu2 ); %On apprend Np pattern aleatoire
%input = p_random_pattern(1,Nneu2); % on genere un pattern aleatoire test
input = P(:,1); % on test le premier pattern aléatoire appris

W = P*P'; 
for i = 1:Nneu2
    W(i,i)=0;
end
Wstart=W;
Wstop = zeros(Nneu2,Nneu2);
W_delete=abs(W)>0;  %matrice logique par laquelle on va multiplier W pour supprimer au fur a mesure des connexions
%On va calculer plusieurs fois la capacité en fonction % connexions

while Percentage_Connexions > 0 %On supprime connexion hasta qu il n'en reste plus

cpt=cpt+1;

%update synchronica
h = W*input;                     
output = sign(h);

err = mean(mean((sign(W*output)-output)~=0)); % 
err_tab = [err_tab err];
%On choisi une connection de W a suppr au hasard

W_delete_i =randi([1 Nneu2],1,1);
W_delete_j =randi([1 Nneu2],1,1);

%if W == Wstop %Si il y a encore des connexions
    
while W(W_delete_i,W_delete_j) == 0 % Si on tombe sur une co deja nulle
    W_delete_i =randi([1 Nneu2],1,1);
    W_delete_j =randi([1 Nneu2],1,1); % On prend une autre co au hasard
    if W == Wstop
        break;
    end
end

%end
%Elimine la conexion choisie
W_delete(W_delete_i,W_delete_j) = 0;

%Puis on la supprime de W et on recommence pour voir
W=W.*W_delete;
Nb_connexion_suppr = Nb_connexion_suppr + 1;

Percentage_Connexions = (Nb_connexion_total-Nb_connexion_suppr)/Nb_connexion_total;
Percentage_Connexions_elimine = Nb_connexion_suppr/Nb_connexion_total;

%pmax=Np-1;
C = pmax/Nneu2;

C_tab=[ C_tab C];
Percentage_Connexions_tab=[ Percentage_Connexions_tab Percentage_Connexions ];
Percentage_Connexions_elimine_tab = [ Percentage_Connexions_elimine_tab Percentage_Connexions_elimine ];
end

%err = nb_pixels_change/Nneu2; %nombre d'erreur = nombre de neuronnes changé

%end

[ pareil_W Nb_connexion_diff] = similitude(Wstart,W);
percentage_connexions_restant =( (Nb_connexion_total-Nb_connexion_suppr) / Nb_connexion_total);

hold on
plot(Percentage_Connexions_elimine_tab(1,1:99:9900),err_tab(1,1:99:9900));
%plot(Percentage_Connexions_elimine_tab,err_tab);
title('err en fonction de percentage connexions');
xlabel('Percentage connexions eliminated') ;
ylabel('Err');
legend('pmax=10','pmax=20');


end
%xlim([0 1]);
%ylim([-0.1 0.6]);

% formatSpec = 'Perror = %4.2f\n\nC = %4.4f\n\npmax = %4.2f     ';
% fprintf(formatSpec,Perror,C,pmax);