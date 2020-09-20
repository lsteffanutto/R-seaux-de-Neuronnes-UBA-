clear all;
close all;
clc;

%% VAR
im_train_dataset=importdata('datosTrain.mat'); %chaque ligne = une image

im_test_dataset=importdata('datosTest.mat'); %chaque ligne = une image

% image_test = im_train_dataset(41,:);
% image_test_print = reshape(image_test,[28,28])'; %%%%% print 2
% imshow(image_test_print);

% nb_epoch = 10;
nb_epoch = 20;
N_train=200;
N_test=N_train;
eta = 0.001;
sigma=1;

nb_image=200;
nb_input=length(im_train_dataset);
nb_output=200;
Nneu_x_capa=nb_output;

x0=1; %biais que agregamos en cada neuronas
cpt=0;
%%%% Vecteurs entrainements et test %%%%%%%%%%%%%
biais_train = ones(N_train,x0);

vi_stock_data=zeros(1,nb_input);
vi_stock_recon=vi_stock_data;
hj_stock_data=zeros(1,Nneu_x_capa);
hj_stock_recon=hj_stock_data;
vi_x_hj_data = zeros(nb_input,nb_output);
vi_x_hj_recon = zeros(nb_input,nb_output);

bi = ones(1,nb_input);
bj = ones(1,nb_output);

%%%% Poids Synaptiques wi %%%%%%%%%%%%%%%%%%%%%%%%%%%

% Full connexions Input to Layer 1: [(w0,wx,wy,wz)=>V1_1 ,..., (w0,wx,wy,wz=> V16_1]
w1 = random_matrice_in_the_intervalle( nb_input , Nneu_x_capa, 0 , 0.0001); % wi_1 aleatoire entre 0 et 0.5 pour init
% w1 = [ random_vect_in_the_intervalle( Nneu_x_capa , 0 , 0.5)' ; w1 ]; % add biais en cada neuronas => w1 = [4x16}
w1_init=w1;

%% ENTRAITEMENT


for epoch = 1:nb_epoch
    
num_input_aleatoire =randperm(nb_image)'; % mezclar el orden de los imagenes de inputs

%on mets les delta à 0 
delta_w1=zeros(nb_input,Nneu_x_capa); 
delta_bi=zeros(1,nb_input); 
delta_bj=zeros(nb_input,nb_output); 

for i =1:nb_output  %puis on présente tous les patrons orden aleatorio
cpt = cpt +1;

%%% 1)m_i
num_azar = num_input_aleatoire(i);
m_input = im_train_dataset(num_azar,:);    %prend image au hasard
% image_test_print = reshape(m_input,[28,28])'; %%%%% TEST PRINT IMAGE TRAIN INPUT
% imagesc(image_test_print);
% colormap(gray(256));
% title('entrada visible');


%%% 2)v_i
mu = m_input;
v_salida = sigma*randn(1,nb_input)+mu; %salida ~ N(mu,sigma);
vi_stock_data = vi_stock_data + v_salida; % on stock les vi sumandoles

% figure,image_test_print = reshape(v_salida,[28,28])'; %%%%% TEST SALDIA IMAGE TRAIN INPUT
% imagesc(image_test_print);
% colormap(gray(256));
% title('salida visible');

%v_salida = [x0 v_salida]; %add el biais

%%% 3)calcular cada neuronna de capa oculta + activation segun la probabilidad
%calcul bj+sum(viwij)
hj_entrada = bj + v_salida*w1;
% hj_entrada = hj_entrada /10000;
prob_hj = sigmoid(hj_entrada);

for i = 1:nb_output
   
num_azar = rand(1);                       % un numero al azar en [0 ; 1] 
    if num_azar < prob_hj(i)
        hj(i) = 1;
    else
        hj(i) = 0;
    end

end
hj_stock_data = hj_stock_data +hj;

%%% 4)stock el (v_ihj)data
vi_x_hj_data = vi_x_hj_data + (hj.*v_salida');

% figure,image_stock = reshape(vi_x_hj_data(:,1),[28,28])'; %%%%% TEST SALDIA IMAGE TRAIN INPUT
% imagesc(image_stock);
% colormap(gray(256));

%%% 5)m_i

m_i = bi + hj * w1';

%%% 6)v_i_bis
mu = m_i;
v_i_bis = sigma*randn(1,nb_input)+mu;
vi_stock_recon = vi_stock_recon + v_i_bis;

%%% 7)
hj_ent_bis = bj + v_i_bis * w1;
% hj_ent_bis = hj_ent_bis / 10000;
prob_hj_bis = sigmoid(hj_ent_bis);

for i = 1:nb_output
   
num_azar = rand(1);                       % un numero al azar en [0 ; 1] 
    if num_azar < prob_hj_bis(i)
        hj_bis(i) = 1;
    else
        hj_bis(i) = 0;
    end

end
hj_stock_recon = hj_stock_recon + hj_bis;

%%% 8)
vi_x_hj_recon = vi_x_hj_recon + (hj_bis.*v_i_bis');

end

%promedia de todo los datas de cada patron
vi_x_hj_data = vi_x_hj_data/nb_image;
vi_x_hj_recon = vi_x_hj_recon/nb_image;

vi_stock_data = vi_stock_data/nb_image;
vi_stock_recon = vi_stock_recon/nb_image;

hj_stock_data = hj_stock_data/nb_image;
hj_stock_recon = hj_stock_recon/nb_image;

%%%% deltas
delta_w1 = eta * (vi_x_hj_data-vi_x_hj_recon);
delta_bi= eta * (vi_stock_data - vi_stock_recon);
delta_bj= eta * (hj_stock_data - hj_stock_recon);

%%% updtate red y biais
w1 = w1 + delta_w1;
bi = bi + delta_bi;
bj = bj + delta_bj;

end
mean(mean(delta_w1))

% m_input = im_train_dataset(num_input_aleatoire(200,1),:);    %prend image au hasard
% image_test_print = reshape(m_input,[28,28])'; %%%%% TEST PRINT IMAGE TRAIN INPUT
% figure,imagesc(image_test_print);
% colormap(gray(256));
% title('entrada visible');
% % figure,imshow(image_test_print);
% 
% image_test = vi_x_hj_recon(:,41);
% image_test_print = reshape(image_test,[28,28])'; %%%%% print 2
% figure,imagesc(image_test_print);
% colormap(gray(256));
% title('reconnu');
% % figure,imshow(image_test_print);
% 
% image_test = vi_x_hj_data(:,41);
% image_test_print = reshape(image_test,[28,28])'; %%%%% print 2
% figure,imagesc(image_test_print);
% colormap(gray(256));
% title('data');
% % figure,imshow(image_test_print);

%% TEST

% image_test = im_test_dataset(41,:);
% image_test_print = reshape(image_test,[28,28])'; %%%%% print 2
% imshow(image_test_print);

m_input_test = im_test_dataset(num_input_aleatoire(1),:);    %prend image au hasard
image_test_print_test = reshape(m_input_test,[28,28])'; %%%%% TEST PRINT IMAGE TRAIN INPUT
figure,imagesc(image_test_print_test);
colormap(gray(256));
title('entrada visible test');

%%% 2)v_i
v_salida_test = m_input_test; %ahora no hay parte estocastica

%%% 3)calcular cada neuronna de capa oculta + activation segun la probabilidad
%calcul bj+sum(viwij)
hj_entrada_test = bj + v_salida_test * w1;
% hj_entrada_test = hj_entrada_test / 10000;
prob_hj_test = sigmoid(hj_entrada_test);

for i = 1:nb_output
   
num_azar = rand(1);                       % un numero al azar en [0 ; 1] 
    if num_azar < prob_hj_test(i)
        hjtest(i) = 1;
    else
        hjtest(i) = 0;
    end

end

%%% 4)stock el (v_ihj)data
vi_x_hj_data_test = hjtest.*v_salida_test';

% figure,image_stock = reshape(vi_x_hj_data(:,1),[28,28])'; %%%%% TEST SALDIA IMAGE TRAIN INPUT
% imagesc(image_stock);
% colormap(gray(256));

%%% 5)m_i

m_i_test = bi + hjtest * w1';

%%% 6)v_i_bis
v_i_bis_test = m_i_test;

%%% 7)
hj_ent_bis_test = bj + v_i_bis_test * w1;
prob_hj_bis_test = sigmoid(hj_ent_bis_test);

for i = 1:nb_output
   
num_azar = rand(1);                       % un numero al azar en [0 ; 1] 
    if num_azar < prob_hj_bis_test(i)
        hj_bis_test(i) = 1;
    else
        hj_bis_test(i) = 0;
    end

end

%%% 8)
vi_x_hj_recon_test = (hj_bis_test.*v_i_bis_test');

image_test_print_test = reshape(vi_x_hj_data_test(:,1),[28,28])'; %%%%% TEST PRINT IMAGE TRAIN INPUT
figure,
subplot(1,2,1);
imagesc(image_test_print_test);
%colormap(gray(256));
title('data');

image_test_print_test = reshape(vi_x_hj_recon_test(:,1),[28,28])'; %%%%% TEST PRINT IMAGE TRAIN INPUT
subplot(1,2,2);
imagesc(image_test_print_test);
%colormap(gray(256));
title('reconnu');
