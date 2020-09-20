clear all;
close all;
clc;

%% VAR

Np = 3; %Nombre de patterns connus
Nneu1 = 100; %Nombre de neurones = nombre de pixels ed l'image
H=[];
nb_pixels_change = 0;
cpt_tour=0;
hext=0;
T=5;
beta=1/T;
kb = 1.38064852*10^(-23);
kb1 = 1;
%On met les images en vecteurs 1/-1

D1_1 = full_bruit(1,Nneu1);
% figure,imshow(D1_1);
D1_1=D1_1(:);
D1_2 = full_bruit(1,Nneu1);
D1_2=D1_2(:);
D1_3 = full_bruit(1,Nneu1);
D1_3=D1_3(:);
D1_4 = full_bruit(1,Nneu1);
D1_4=D1_4(:);

P = [ D1_1 D1_2 D1_3 ]; %Matrice contenant chaque patterns en colonne

%% TRAITEMENT

%ENTRAINEMENT %%%%%%%%%%%%%%%%%%%%%

%MATRICE POIDS SYNAPTIQUE W = P*P' => méga-autocorrelation entre les 3 iamges
%images
W = P*P'; % matrice de poids synaptique = mega-autocorr entre les patterns
% On s'en balek du 1/Neu de normalisation
W = P*P' - Np*eye(Nneu1); % Wii=0 car pas de retroaction sur chaque neuronne (eye = Id)
matrix_W_ising_1D = W_to_W_ising_1D( W );
%EXECUCION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

input = D1_4; % on rentre un pattern aleatoire

image_test = input; %qu'on sauvegarde pour afficher 
input = input(:); %on met l'image test en colonne
image_test_vect = input; % vecteur test qu'on sauvegarde pour comparer au debut

%%% var du réseau

asynchron_rand = 1; %Si on veut une mise à jour async dans un ordre aleatoire
iterations=5000;
nb_points_H = 10;
div=iterations/nb_points_H;
Hsystm=[];
Tsystm = [];
Ssystm= [];

for Nb_tour = 1:iterations

%<S>
s=matrix_W_ising_1D*input;
s=sum(s)+hext;
s=tanh(beta*s);
Ssystm = [Ssystm s];

if s < -0.99 %Threshold Tc
    Tc=T;
end

%<H>
Hstart = (-1/2)*(input'*matrix_W_ising_1D*input); %Start Energie of the systm, before update
Hsystm = [ Hsystm Hstart ];

%<T>
Tsystm = [ Tsystm T ];

%Choose a neurone, randomly or not
if asynchron_rand ==0            
        position_neuronne = Nb_tour;
else
        position_neuronne = randi([1 Nneu1],1,1); 
end
    
input(position_neuronne,1) = - (input(position_neuronne,1)); %change this neurone;
nb_pixels_change = nb_pixels_change+1;
Htest = (-1/2)*(input'*matrix_W_ising_1D*input); %Calcul the new energie;

deltaH = Htest - Hstart; %Calcul if energie increase or decrease after the changement;
% if decrease, we accept the changement
% if increase, we accept with a certain probability
if deltaH > 0                                    
    change_or_no = rand(1);                       %we select a number in [0 ; 1] 
    if change_or_no > exp(-(deltaH/(kb1*T)))       % in this case we don't accept the changement (Metropolis)
        input(position_neuronne,1) = - input(position_neuronne,1); %return to his old position
        nb_pixels_change = nb_pixels_change-1;
    end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if Nb_tour ==1                    %pattern detecte
    h = matrix_W_ising_1D*input;                      % le h est l'image modifie * matrice poids synaptique
    output = sign(h);  
    output_inter_1 = output;
    [ pareil_depart, nb_diff_depart_avec_pattern_reconnu] = similitude(image_test_vect,output_inter_1) %nombre de pixel different entre input et pattern detecte

end

%On regarde la tete de la reconstruction au cours des iterations
if Nb_tour == floor(iterations/4)
    output_1_4=input;
end

if Nb_tour == floor(iterations/2)
    output_2_4=input;
end

if Nb_tour == floor(3*iterations/4)
    output_3_4=input;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T=0.99*T;
end

nb_pixels_change

%Nombre de difference entre l'image reconstruit et le pattern detecte
[ pareil_final, nb_diff_final_avec_pattern_reconnu ] = similitude(input,output_inter_1)

%On reforme les images%%%%%%%%%%%%%%%%%%%%%%%%
input = reshape(input,1,Nneu1);
output_inter_1 = reshape(output_inter_1,1,Nneu1);
output_1_4 = reshape(output_1_4,1,Nneu1);
output_2_4 = reshape(output_2_4,1,Nneu1);
output_3_4 = reshape(output_3_4,1,Nneu1);
%%%%%%%%%%%%%%%%%%%%%%%%

[ longueur_vecteur nombre_pattern_apprit] = size(P);
nombre_pattern_apprit

%% FIGURES
figure,
subplot(1,2,1)
imshow(output_inter_1);
title('pattern reconnu asynch');
drawnow;
subplot(1,2,2)
imshow(input);
title('pattern reconstruit Ising');
drawnow;


figure,
subplot(1,3,1)
imshow(output_1_4);
title('1/4 iterations totales');
drawnow;
subplot(1,3,2)
imshow(output_2_4);
title('1/2 iterations totales');
drawnow;
subplot(1,3,3)
imshow(output_3_4);
title('3/4 iterations totales');
drawnow;

figure,plot(Hsystm);
title('fonction energie modele Ising');
figure,plot(Tsystm,Ssystm);
title('<S> en fonction de T');

