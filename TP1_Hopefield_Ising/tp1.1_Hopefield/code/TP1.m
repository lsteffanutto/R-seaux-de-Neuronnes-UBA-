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


for Nb_tour = 1:iterations
  
cpt_tour=cpt_tour+1;

%ITERATION
h = W*input;                      % le h est l'image modifie * matrice poids synaptique
output = sign(h);                 % qu'on threshold pour donner l'output, puis on recommence

%ENERGIE
if mod(Nb_tour,div)==0            % on calcul que quelques valeur de H sur toutes les iterations
    energie = (-1/2)*(input'*W*input);
    H = [H energie];
end

if Nb_tour ==1                    %pattern detecte
    output_inter_1 = output;
    [ pareil_depart, nb_diff_depart_avec_pattern_reconnu] = similitude(image_test_vect,output_inter_1) %nombre de pixel different entre input et pattern detecte

end


if similitude(input,output)==0;   %si input est different du pattern detecte on met a jour un pixel
    
    if asynchron_rand ==0            %maj asynchrone PAS aleatoire on fait dans l'ordre des pixels
        position_neuronne = Nb_tour;
    else
        position_neuronne = randi([1 Nneu],1,1); % quand maj asynch d un pixel aléatoire
    end
    
    if(input(position_neuronne,1)~=output(position_neuronne,1)); %si le neuronne choisis et n'est pas le meme dans input que dans output on le change
        input(position_neuronne,1)=output(position_neuronne,1);
        nb_pixels_change = nb_pixels_change+1;
    end
    
else %quand etat stable on arrête
    break
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


end

nb_pixels_change

%figure,plot(1:div:div*nb_points_H,H);%plot(1:div:cpt*div,H);
figure,plot(H);%plot(1:div:cpt*div,H);

title('fonction energie');

%Nombre de difference entre l'image reconstruit et le pattern detecte
[ pareil_final, nb_diff_final_avec_pattern_reconnu ] = similitude(input,output_inter_1)

%On reforme les images%%%%%%%%%%%%%%%%%%%%%%%%
input = reshape(input,50,50);
output_inter_1 = reshape(output_inter_1,50,50);
output_1_4 = reshape(output_1_4,50,50);
output_2_4 = reshape(output_2_4,50,50);
output_3_4 = reshape(output_3_4,50,50);
%%%%%%%%%%%%%%%%%%%%%%%%

figure,
subplot(1,2,1)
imshow(output_inter_1);
title('pattern reconnu');
drawnow;
subplot(1,2,2)
imshow(input);
title('pattern reconstruit');
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

[ longueur_vecteur nombre_pattern_apprit] = size(P);
nombre_pattern_apprit
%% FIGURES

% IMAGES
% figure,
% imshow(A_noise);
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

% MATRIX
% figure,imshow(W);
% title('W');

%%%%%%%%%%%%

%Wij=(1/Nneu)*sum(1toNp)(EiEj)
Wnew = W;
s=0;

%Si on développe la formule du dessus = j'suis un bouffon
% for i = 1:Nneu
%     
%     for j = 1:Nneu
%         
%         s=0 ;
%         
%         for mu = 1:Np
%            
%             s = s + P(i,mu)*P(j,mu);
%             
%         end  
%         
%         Wnew(i,j) = s;
%         
%         
%     end
%     
% end
% 
% Wnew = Wnew - Np*eye(Nneu);
% figure,imshow(Wnew);
% title('Wnew');



%%%%%%%%%%%%%





% subplot(2,2,3);
% imshow(C);
% subplot(2,2,4);
% imshow(D);

%%%%
%newhop fabrique un reseau de neuronne de Hopefield
%patternnet
%nprtool
%sim
%satlins
%net= newhop(A);
%%%%

%ON FABRIQUE LES RESEAU DE HOPEFIELD A PARTIR DE LA MATRICE DE POIDS
%SYNAPTIQUE ou de la matrice contenant les pattern

% net = newhop(P);
% [Y,Pf,Af] = sim(net,3,[],P);
% view(net);

%%% ON  LE FABRIQUE NOUS MEME


% Ai = {[-0.9; -0.8; 0.7]};
% [Y,Pf,Af] = sim(net,{1 5},{},Ai);
% Y{1}
%MATRICE AUTOCORR CHAQUE IMAGE
% %matrice xcorrB
% W_Bvect = Bvect*Bvect';
% 
% figure,imshow(W_Bvect);
% title('W_Bvect');
% 
% %matrice xcorrB 
% W_Cvect = Cvect*Cvect';
% 
% figure,imshow(W_Cvect);
% title('W_Cvect');
% 
% %matrice xcorrF
% W_Fvect = Fvect*Fvect';
% 
% figure,imshow(W_Fvect);
% title('W_Fvect');