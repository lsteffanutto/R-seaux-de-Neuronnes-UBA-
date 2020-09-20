clear all;
close all;
clc;

% Redes pour approximer f(x,y,z) = sin(x) + cos(y) +z

%% VAR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %PLOT F(x,y,z) souhaité
% x = 0:0.5:2*pi;
% y = 0:0.5:2*pi;
% z = -1:0.5:1;
% [X,Y,Z] = meshgrid(x,y,z);
% F = sin(X)+cos(Y)+Z;
% surf(F(:,:));


Nneu_x_capa = 16;
capa_inter = 2;
eta = 0.001;
tau=40;
N_train=200;
N_test=1000;
E_target=0.001;
nb_input=3;
nb_output=1;
alpha_activation=1;

x0=1; %biais que agregamos en cada neuronas
cpt=0;
%%%% Vecteurs entrainements et test %%%%%%%%%%%%%
biais_train = ones(N_train,x0);
vect_x_train = random_vect_in_the_intervalle( N_train , 0 , 2*pi);
vect_y_train = random_vect_in_the_intervalle( N_train , 0 , 2*pi);
vect_z_train = random_vect_in_the_intervalle( N_train , -1 , 1);

biais_test = ones(N_test,x0);
vect_x_test = random_vect_in_the_intervalle( N_test , 0 , 2*pi);
vect_y_test = random_vect_in_the_intervalle( N_test , 0 , 2*pi);
vect_z_test = random_vect_in_the_intervalle( N_test , -1 , 1);

X_input_train = [ biais_train vect_x_train vect_y_train vect_z_train ];
X_input_test = [ biais_test vect_x_test vect_y_test vect_z_test ];
Yd_test = [ sin(vect_x_test)+cos(vect_y_test)+vect_z_test ];

%%%% Poids Synaptiques wi %%%%%%%%%%%%%%%%%%%%%%%%%%%

% Full connexions Input to Layer 1: [(w0,wx,wy,wz)=>V1_1 ,..., (w0,wx,wy,wz=> V16_1]
w1 = random_matrice_in_the_intervalle( nb_input , Nneu_x_capa, 0 , 0.5); % wi_1 aleatoire entre 0 et 0.5 pour init
w1 = [ random_vect_in_the_intervalle( Nneu_x_capa , 0 , 0.5)' ; w1 ]; % add biais en cada neuronas => w1 = [4x16}
w1_sans_biais=[];
% Full connexions Layer 1 to Layer 2: [(w1.0_2,...,w1.16_2)=>V1_2 ,..., (w16.0_2,...,w16.16_2)=>V16_2]
w2 = random_matrice_in_the_intervalle( Nneu_x_capa , Nneu_x_capa, 0 , 0.5); % wi_2 aleatoire en 0 et 0.5 pour init
w2 = [ random_vect_in_the_intervalle( Nneu_x_capa , 0 , 0.5)' ; w2 ]; % add biais en cada neuronas => w2 = [17x16}
w2_sans_biais=[];

% Full connexions Layer 2 to Output: [(w1.0_3,...,w1.16_3)=>V1_3] => W=[17x1]
W = random_matrice_in_the_intervalle( Nneu_x_capa , nb_output, 0 , 0.5); % wi_2 aleatoire en 0 et 0.5 pour init
W = [ random_vect_in_the_intervalle( nb_output , 0 , 0.5)' ; W ]; % add biais en cada neuronas
W_sans_biais=[];

%%%%%%% h et V et deltas du reseau init a 0 %%%%%%%%%%%%%%%%%%%%%%%%%%%
hi_1 = zeros(1,Nneu_x_capa);
Vi_1 = hi_1;
delta_Vi_1 = Vi_1;
hi_2 = zeros(1,Nneu_x_capa);
Vi_2 = hi_2;
delta_Vi_2=Vi_2;
h_output = 0;
output = 0;
delta_output=output;

E=1;
E_decision=E;
Estock=[];
Eplot=[];
intervalle_plot_E=1000;
abscisse=[];
%% ENTRAINEMENT DE LA RED %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

while E_decision>E_target
% for i = 1:12
    
cpt=cpt+1;   
%TOUS les delta_wi a init a 0 pour chaque tour
delta_w1=zeros(nb_input+1,Nneu_x_capa); 
delta_w2=zeros(Nneu_x_capa+1,Nneu_x_capa);
delta_W=zeros(Nneu_x_capa+1,nb_output);

%input train vecteur al azar
rand_num_train = randi([1 N_train],1,1);
rand_X_input = X_input_train(rand_num_train,:); 
x_input = rand_X_input(1,2);
y_input = rand_X_input(1,3);
z_input = rand_X_input(1,4);

% sortie desire avec l'input choisi: f(x,y,z) = sin(x) + cos(y) + z
yd = [ sin(x_input)+cos(y_input)+z_input ]; 

%%%%%% INPUT to OUPUT %%%%%%%%%%%%%%%%%%%

hi_1 = rand_X_input * w1; % hi du layer 1 [1x16]
Vi_1 = tanh(hi_1); % Vi du layer 1 après fonction activation tanh
Vi_1 = [x0 Vi_1]; % on ajoute le biais avant layer 2 [1x17]

hi_2 = Vi_1 * w2; % hi du layer 2 [1x16]
Vi_2 = tanh(hi_2); % Vi du layer 2 après fonction activation tanh
Vi_2 = [x0 Vi_2]; % on ajoute le biais avant output [1x17]

h_output = Vi_2 * W; % h_output [1x1]
% output fonction activation (PReLU) car tanh que => [-1;1]
% or f(x,y,z) => [-3;3], DONC on applique (PReLU) => [-inf; +inf]
% PReLU = f(input,alpha)  =>  ! devient rampe/identité si alpha=1 !
output = PReLU(h_output,alpha_activation); %identité
% Vi antérieur on peut laisser tanh activation 

%%%%%% DELTAS BACK PROPAGATION %%%%%%%%%%%%%%%%%%%

% g'(h)_output =(PReLU)' ( si alpha = 1 => (PReLU)' = cte = 1 )
delta_output=PReLU_derive(h_output,alpha_activation)*(yd-output);%g'(h)(désiré-output)

w1_sans_biais = w1(2:end,:);
w2_sans_biais = w2(2:end,:);
W_sans_biais = W(2:end,:);

% delta_Vi_2 => g'(h)=(tanh)'=1-tanh(h)²
g_derive_hi_2 = (ones(1,Nneu_x_capa)-(tanh(hi_2).^2)); %[1x16]
g_derive_hi_2 = g_derive_hi_2'; % [16x1] pour faire multiplication term à term X.*Y

delta_Vi_2 = g_derive_hi_2.*W_sans_biais*delta_output;

% delta_Vi_2 => g'(h)=(tanh)'=1-tanh(h)²
g_derive_hi_1 = (ones(1,Nneu_x_capa)-(tanh(hi_1).^2)); %[1x16]
g_derive_hi_1 = g_derive_hi_1'; % [16x1] pour faire multiplication term à term X.*Y

sommes_deltas_ponderes = w2_sans_biais*delta_Vi_2; %Pour chaque Vi_1
delta_Vi_1 = g_derive_hi_1.*sommes_deltas_ponderes;

%%%%%% DELTAS W %%%%%%%%%%%%%%%%%%% delta_w = eta*source*delta_dest
% Vi_1_sans_biais = Vi_1
delta_w1 = eta*rand_X_input'*delta_Vi_1'; %[4x16]=dim(w1)
delta_w2 = eta*Vi_1'*delta_Vi_2'; %[17x16]=dim(w2)
delta_W = eta*Vi_2'*delta_output; %[17x1]=dim(W)

%%%%%% UPDATE W %%%%%%%%%%%%%%%%%%%
w1 = w1 + delta_w1;
w2 = w2 + delta_w2;
W = W + delta_W;

E = 0.5*((yd-output).^2);

if cpt<=tau
    Estock = [ E Estock]; %On stock en + tant que ça depasse pas 40   
else %FIFO quand ça dépasse tau
    Estock(2:end)=Estock(1:end-1);
    Estock(1) = E;
    E_decision = mean(Estock);
end

if mod(cpt,intervalle_plot_E) == 0
    Eplot = [Eplot E_decision];
    abscisse = [ abscisse cpt ];
end

end

%% TEST DE LA RED %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
yd_test=0;
output_test=0;
plot_reel_x_desire=[];

for i = 1:N_test

%input test
X_input_vect_test = X_input_test(i,:); 
x_input_test = X_input_vect_test(1,2);
y_input_test = X_input_vect_test(1,3);
z_input_test = X_input_vect_test(1,4);

% sortie test desire avec l'input test: f(x,y,z) = sin(x) + cos(y) + z
yd_test = [ sin(x_input_test)+cos(y_input_test)+z_input_test ]; 

%%%%%% INPUT to OUPUT avec RED TRAINED (w1,w2,W) OK %%%%%%%%%%%%%%%%%%%

hi_1 = X_input_vect_test * w1; % hi du layer 1 [1x16]
Vi_1 = tanh(hi_1); % Vi du layer 1 après fonction activation tanh
Vi_1 = [x0 Vi_1]; % on ajoute le biais avant layer 2 [1x17]

hi_2 = Vi_1 * w2; % hi du layer 2 [1x16]
Vi_2 = tanh(hi_2); % Vi du layer 2 après fonction activation tanh
Vi_2 = [x0 Vi_2]; % on ajoute le biais avant output [1x17]

h_output = Vi_2 * W; % h_output [1x1]
% output fonction activation (PReLU) car tanh que => [-1;1]
% or f(x,y,z) => [-3;3], DONC on applique (PReLU) => [-inf; +inf]
% PReLU = f(input,alpha)  =>  ! devient rampe/identité si alpha=1 !
output_test = PReLU(h_output,alpha_activation); %identité
% Vi antérieur on peut laisser tanh activation 

plot_reel_x_desire = [ plot_reel_x_desire ; yd_test output_test];

end

X=plot_reel_x_desire(:,1); %output desire
Y=plot_reel_x_desire(:,2); %outputs_reel

%% FIGURE %%%%%%%%%%%%%%%%%%%%%%%%%%%

figure,plot(abscisse,Eplot);
title('Energie moyenne en fonction des itérations entrainement');
xlabel('nb iterations');
ylabel('Energie moyenne');

figure,plot(X,Y,'o');
title('Expectation vs Reality avec le vecteur test');
xlabel('Expectation');
ylabel('Reality');
