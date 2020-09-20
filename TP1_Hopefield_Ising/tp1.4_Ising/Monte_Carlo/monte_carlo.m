clear all;
close all;
clc;

clear all;
close all;
clc;


%% VAR

A=double(imread('paloma.bmp'));
%A_noise = imnoise(A,'gaussian',0.1); %bruiter l'image
%A_noise = im2bw(A_noise,map,0.5);
B=double(imread('panda.bmp'));
C=double(imread('perro.bmp'));
D=double(imread('torero.bmp'));
E=double(imread('quijote.bmp'));
F=double(imread('v.bmp'));

%resize tout en 50x50
E=resize_image(E,50,50);
D=resize_image(D,50,50);
A=resize_image(A,50,50);

%image full bruit%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
image_nique = full_bruit(50,50);
image_nique_vect=image_nique(:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%image mix %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%img mix de 4 au choix comme les glaces
img_mix=mix_image_hasta_4(B,C,F,image_nique);

%panda/chien
mix_B_C = B;
mix_B_C(25:50,1:50) = C(25:50,1:50);
mix_B_C = mix_B_C.*2-1;
%chien/anonymous
mix_C_F = C;
mix_C_F(1:50,25:50) = F(1:50,25:50);
mix_C_F = mix_C_F.*2-1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Np = 3; %Nombre de patterns connus
Nneu = length(B)*length(B); %Nombre de neurones = nombre de pixels ed l'image
H=[];
nb_pixels_change = 0;
cpt_tour=0;
T=0.5;
kb = 1.38064852*10^(-23);
kb1 = 1;
%On met les images en vecteurs 1/-1
Avect = A(:);
Avect = Avect.*2-1;
Bvect = B(:); 
Bvect = Bvect.*2-1;
Cvect = C(:);
Cvect = Cvect.*2-1;
Dvect = D(:);
Dvect = Dvect.*2-1;
Evect = E(:);
Evect = Evect.*2-1;
Fvect = F(:);
Fvect = Fvect.*2-1;

P = [ Bvect Cvect Fvect ]; %Matrice contenant chaque patterns en colonne

%% TRAITEMENT

%ENTRAINEMENT %%%%%%%%%%%%%%%%%%%%%

%MATRICE POIDS SYNAPTIQUE W = P*P' => méga-autocorrelation entre les 3 iamges
%images
W = P*P'; % matrice de poids synaptique = mega-autocorr entre les patterns
% On s'en balek du 1/Neu de normalisation
W = P*P' - Np*eye(Nneu); % Wii=0 car pas de retroaction sur chaque neuronne (eye = Id)

%EXECUCION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

input = mix_C_F;
%input=addnoise(input,0.175); %0.5 = pas de bruit

image_test = input; %qu'on sauvegarde pour afficher 
input = input(:); %on met l'image test en colonne
image_test_vect = input; % vecteur test qu'on sauvegarde pour comparer au debut

%%% var du réseau

asynchron_rand = 1; %Si on veut une mise à jour async dans un ordre aleatoire
iterations=10000;
nb_points_H = 10;
div=iterations/nb_points_H;
Hsystm=[];

for Nb_tour = 1:iterations

Hstart = (-1/2)*(input'*W*input); %Start Energie of the systm, before update
Hsystm = [ Hsystm Hstart ];

%Choose a neurone, randomly or not
if asynchron_rand ==0            
        position_neuronne = Nb_tour;
else
        position_neuronne = randi([1 Nneu],1,1); 
end
    
input(position_neuronne,1) = - (input(position_neuronne,1)); %change this neurone;
nb_pixels_change = nb_pixels_change+1;
Htest = (-1/2)*(input'*W*input); %Calcul the new energie;

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
    h = W*input;                      % le h est l'image modifie * matrice poids synaptique
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

end

nb_pixels_change

%figure,plot(1:div:div*nb_points_H,H);%plot(1:div:cpt*div,H);
figure,plot(Hsystm);%plot(1:div:cpt*div,H);

title('fonction energie Monte Carlo methode');

%Nombre de difference entre l'image reconstruit et le pattern detecte
[ pareil_final, nb_diff_final_avec_pattern_reconnu ] = similitude(input,output_inter_1)

%On reforme les images%%%%%%%%%%%%%%%%%%%%%%%%
input = reshape(input,50,50);
output_inter_1 = reshape(output_inter_1,50,50);
output_1_4 = reshape(output_1_4,50,50);
output_2_4 = reshape(output_2_4,50,50);
output_3_4 = reshape(output_3_4,50,50);
%%%%%%%%%%%%%%%%%%%%%%%%

[ longueur_vecteur nombre_pattern_apprit] = size(P);
nombre_pattern_apprit

%% FIGURES
figure,
subplot(1,2,1)
imshow(output_inter_1);
title('pattern reconnu Hopefield');
drawnow;
subplot(1,2,2)
imshow(input);
title('pattern reconstruit Monte Carlo');
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

figure, 
subplot(2,3,2);
imshow(B);
title('image B');
drawnow;
subplot(2,3,1);
imshow(C);
title('image C');
drawnow;
subplot(2,3,3);
imshow(F);
title('image F');
drawnow;
subplot(2,3,4);
imshow(D);
title('image D');
drawnow;
subplot(2,3,5);
imshow(A);
title('image A');
drawnow;
subplot(2,3,6);
imshow(reshape(image_test,50,50));
title('image test');
drawnow;

