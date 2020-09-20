clear all;
close all;
clc;

%% VAR

matrice_XOR = XOR_matrix();
figure,plot_matrix_type( matrice_XOR );

Nneu_x_capa = 3; %(+biais)
capa_inter = 1;
eta = 0.01;
nb_indiv=100;
nb_input=3; %(+biais)
nb_output=1;
nb_connexions=Nneu_x_capa*nb_input;
proba_cross_over = 0.1;
sigma=0.1;
x0=1; %biais que agregamos en cada neuronas
cpt=0;
F_target=0.99

%%%% Poids Synaptiques wi %%%%%%%%%%%%%%%%%%%%%%%%%%%
% W = zeros(nb_indiv,nb_connexions); %todos los pesos de todos los individuos
W = zeros(Nneu_x_capa,Nneu_x_capa,nb_indiv); 
W2 = W;
%W(:,1,i) vers V1
%W(:,2,i) vers V2
%W(:,3,i) Vi vers output


% Full connexions Input to Layer 1 pour chaque individu
for i =1:100
    w1 = random_matrice_in_the_intervalle( nb_input , Nneu_x_capa, 0 , 0.5); % wi_1 aleatoire entre 0 et 0.5 pour init
    W(:,:,i) = w1;
end

%entrada y salida deseada
X_entrada=[]; 
X_entrada = [ X_entrada ones(4,1) matrice_XOR(:,1:2) ]; % matrices avec les différentes entrées possibles
Yd = [ matrice_XOR(:,3)]; % les sorties désirées

Estock=[];
Fstock=[];
Welite=0;
%% TRAITEMENT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% calcular error E  y F para cada red
F_max=0;
F_max_init=0;
F_max_stock=[];
while F_max<F_target
cpt = cpt+1;
Estock=[];
Fstock=[];

for red_test=1:nb_indiv %on prend chaque individu et on va tester la red
    
E=0;
F=0;

rand_num_patron=randperm(4); % on va permuter aleatoirement ordre 4 vecteurs

for num_patron = 1:4

% num_patron=1;
patron_test = rand_num_patron(1,num_patron); %on test chaque vecteur dans ordre aleatoire
X_input = [ X_entrada(patron_test,:) ];
E1 = X_input(1,2);
E2 = X_input(1,3);

%Inputs to V
h1= x0*W(1,1,red_test)+E1*W(2,1,red_test)+E2*W(3,1,red_test);  %W(:,1,1) => W(:,1,i)
h2= x0*W(1,2,red_test)+E1*W(2,2,red_test)+E2*W(3,2,red_test);
V1=tanh(h1);
V2=tanh(h2);

%Output
h_output = x0*W(1,3,red_test)+V1*W(2,3,red_test)+V2*W(3,3,red_test);
output = tanh(h_output);

E = E + ((Yd(patron_test,1)-output).^2);

if num_patron ==4
    E = E/num_patron;
    F = 1 - (E/4);
end

end
%%%%% Fin del calculo para una red

%Stock del E y del F de la red calculada
Estock = [ Estock ; E];
Fstock = [ Fstock ; F];

%%%Et on recommenc epour chaque red

end

%Encontramos F_max y el Welite
[ F_max , index_elite] = max(Fstock);
Welite = W(:,:,index_elite);
F_max_stock = [F_max_stock F_max];     
if cpt ==1
   F_max_init=F_max;
end

if F_max<F_target                %Si on a atteint objectif on refait pas tout ça et c'est fini
%% Reproducion    %%%%%%%%%%%%%%

%stock proba de cada individuos
sum_Fstock = sum(Fstock);
Proba_individus = Fstock./sum_Fstock;

%Proba max y proba min
mean_prob = mean(Proba_individus);
min_prob = min(Proba_individus);
max_prob = max(Proba_individus);

%Tomamos un numero al azard entre las probabilidades
a = min_prob;
b = max_prob;

Proba_y_index = [];
for i =1:nb_indiv
Proba_y_index = [Proba_y_index; Proba_individus(i,1) i];
end
Proba_croissant = [];
Proba_croissant = sortrows(Proba_y_index,1) ;


% Prend chaque W qui se reproduise avec proba
for i =1:nb_indiv-1
    azar = (b-a).*rand(1,1) + a;    %Tire un nombre au azar dans intervalle des proba
    if azar < W(:,:,i)              
        W2(:,:,i)=W(:,:,i);          %Si le nombre au hasard plus petit que la proba il se reproduit
    else
        azar_index = randi([1 100],1,1);    %Sinon tu prend un autre individu au hasard
        while azar>W(:,:,azar_index)        % et tu regarde si il valide la proba
            %azar = (b-a).*rand(1,1) + a;
            azar_index = randi([1 100],1,1);
        end
        W2(:,:,i)=W(:,:,azar_index);  %Lorsque t'en a trouvé un tu le reproduis
    end
end

W2(:,:,nb_indiv)= Welite; %On garde le Welite qu'on mets à la fin

%%%%%%%%%%%%%%

%% Cross Over (par cada uno individuo con proba de 0.1)  %%%%%%%%%%%%%%
tmp=[];
nb_cross_over=0;
for num_indiv = 1:nb_indiv
    
    cross_over_o_no = rand(1); %nombre aleatoire entre 0 et 1
    
    if cross_over_o_no <= proba_cross_over %si ce nombre <0.1 on fait le cross_over
        
        nb_cross_over=nb_cross_over+1;
        tmp=[];
        W2_indiv=[];
        W2_cross=[];

        azar_indiv_cross = randi([1 100],1,1); %elegimos un otro individuo al hasard para hacer el C-O
        azar_index_limita = randi([1 9],1,1);  %elegimos desde que index vamos a compartir los genes

        %coeff en linea
        W2_indiv = reshape(W2(:,:,num_indiv), [nb_connexions 1])';
        W2_cross = reshape(W2(:,:,azar_indiv_cross), [nb_connexions 1])';

        %intercambio
        tmp=W2_indiv(1,azar_index_limita:end);   %on mets fin indiv dans temp
        W2_indiv(1,azar_index_limita:end)= W2_cross(:,azar_index_limita:end); %on mets fin second indiv dans indiv1
        W2_cross(:,azar_index_limita:end)=tmp;

        %Volvemos en matriz
        W2(:,:,num_indiv) = reshape(W2_indiv(:,:), [nb_input Nneu_x_capa]); 
        W2(:,:,azar_indiv_cross) = reshape(W2_cross(:,:), [nb_input Nneu_x_capa]); 
        
    end

    
    
    
    
end
nb_cross_over;
%%%%%%%%%%%%%%

%% Mutacion de un pesos al azar para cada individu %%%%%%%%%%%%%%
W2_mut=[];

for indiv_mut = 1:nb_indiv
    
    W2_mut = reshape(W2(:,:,indiv_mut), [nb_connexions 1])'; %indiv en linea
      
    index_mut = randi([1 9],1,1); %index de pesos que va a mutear al asard
    r = sigma*randn(1);   %con esta mutacion
    W2_mut(1,index_mut)=W2_mut(1,index_mut)+r; %mutacion
    
    W2(:,:,indiv_mut) = reshape(W2_mut, [nb_input Nneu_x_capa]); %volvemos en matriz
    
end
%%%%%%%%%%%%%%

end
%%%% puis refait toutes manip avec new indivs
W2(:,:,nb_indiv)=Welite;
W=W2;
end 
F_max
Welite

%% FIGURES
abscisse = [-2:0.1:2];

w10_1=Welite(1,1);
w11_1=Welite(2,1);
w12_1=Welite(3,1);

w20_1=Welite(1,2);
w21_1=Welite(2,2);
w22_1=Welite(3,2);

%le bon
droite3 = (-w10_1/w12_1)-(w11_1/w12_1)*abscisse; %toutes les co vers V1/2
droite4 = (-w20_1/w22_1)-(w21_1/w22_1)*abscisse;

plot( abscisse,droite3 );
plot( abscisse,droite4 );
title('perceptron XOR');

figure,plot( 1:cpt,F_max_stock );
title('F en fonction iterations');
xlabel('iterations');
ylabel('F');
