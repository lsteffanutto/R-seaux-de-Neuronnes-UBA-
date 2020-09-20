clear all;
close all;
clc;

oui=0;
%% VAR
n_input = 1000
nb_epoch = 500
% nb_neu = 100
nb_neu = 100
nb_tours = nb_epoch*n_input;
% nb_tours = 10000;

cote=sqrt(nb_neu);
intervalle_depart_wi = [-0.1,0.1]; %Deltas w ~N(0,0.01)
x=[];
y=x;
Nneu_x_capa = 9;
capa_inter = 1;
eta = 0.01;
E_target=0.01;
nb_input=2;
nb_output=1;
cpt=0;
sigma=0.1
alpha_sigma=0.9995;
% alpha_sigma=1;
% alpha_sigma=0.9995*(1+((1/1000)*(1/nb_epoch)))

%VECTEUR INPUT
X_input = random_unit_cercle(n_input);
hold on;
plot(X_input(:,1),X_input(:,2),'.');
title('Input vecteur cercle unite');

%INIT RED
red = random_carre_intervalle(intervalle_depart_wi,nb_neu);
red_init=red;
test=[];
% plot_neu_relies_voisins( red, cote );

% 
% test=[];
% test_x(:,:)=reshape(red(:,1),[10 10])';
% test_y(:,:)=reshape(red(:,2),[10 10])';
% 
% test(:,:,1)=test_x(:,:);
% test(:,:,2)=test_y(:,:);

% hold on;
%scatter(red(:,1),red(:,2),'g+'); %plot points
plot(red(:,1),red(:,2),'g+');


% plot_neu_relies_voisins(red,cote); %plot les lignes qui relient les voisins entre eux, cote=cote carre;


if oui==0
%INIT Wi
% w = random_matrice_in_the_intervalle( nb_input , Nneu_x_capa, 0 , 0.1); % wi_1 aleatoire entre 0 et 0.5 pour init
% w';
%% TRAITEMENT 

num_input_aleatoire =randperm(n_input)'; % pour melanger les inputs


Cstock = [];
C=0;

for num_input=1:nb_tours

% for num_input=1:100

cpt=cpt+1;

if mod(num_input,n_input)==0 %on renouvelle à chaque fois les inputs dans ordre aleatoire
%     X_input = random_unit_cercle(n_input);
    num_input_aleatoire =randperm(n_input)';  
    num_test=1;
    
%     Cstock = [ Cstock norm(C) ];
    %C=0;
    
else
    num_test=mod(num_input,n_input); % dans le cas où nb_tours>nb_input
end

%Choisi patron input aleatoire
input = X_input(num_input_aleatoire(num_test,1),:); %On en prend un au hasard dans X_input
x_input = input(1,1);
y_input = input(1,2);
% plot(x_input,y_input,'mX','MarkerSize',10,'linewidth',3);%print input
% pause(0.1)

%calcul distance euclidienne Input/Neuronnes
[dist_min , pos_neu] = find_dist_min_y_pos(input,red);
x_output=red(pos_neu,1);
y_output=red(pos_neu,2);

% plot(x_output,y_output,'yo','MarkerSize',10,'linewidth',3);%print output qui s'active avec input
% pause(0.1)
% hold off;


%calcul distance euclidienne Neu* / Neu
winner = [ x_output y_output];
mat_dist_win_otro = dist_winner_other(winner,red);

%Vecinidad fonction
matrice_fonction_voisin = fonction_voisin(mat_dist_win_otro,sigma);


%Calcul deltaW
delta_red = calcul_delta_w( eta,matrice_fonction_voisin,input,red );

%Actualizacion w
red = red + delta_red;

sigma=alpha_sigma*sigma;

%C = C + norm(matrice_fonction_voisin.*dist_winner_other(input,red));
% C = C + matrice_fonction_voisin*norm(input - red);
    
% plot(red(:,1),red(:,2),'ro');
% pause(0.1)

end

% plot_neu_relies_voisins(red,cote);
plot(red(:,1),red(:,2),'rO');

plot_circle( 0,0,1 );

legend('inputs','Red-start', 'Red-fin')
title('reds depart et arrive');

% figure,plot(1:1:10,Cstock);
% title('C en fonction iteraciones');

end




% scatter(red(:,1),red(:,2),'--gs');







% [dist_tab_min num_neu]= min(dist_tab);

% pos = gridtop([ test_x test_y]); 
% plotsom(pos)

% s = test_x';
% t = test_y';
% weights = [10 10 10 10 10 1 1 1 1 ];
% G = graph(s,t,weights);
% plot(G,'EdgeLabel',G.Edges.Weight)

% axis([-1 1 -1 1])

% s = [1 1 1 2 2 6 6 7 7 3 3 9 9 4 4 11 11 8];
% t = [2 3 4 5 6 7 8 5 8 9 10 5 10 11 12 10 12 12];
% weights = [10 10 10 10 10 1 1 1 1 1 1 1 1 1 1 1 1 1];
% G = graph(s,t,weights);
% plot(G,'EdgeLabel',G.Edges.Weight)

% for i=1:9
% neighbour{i}=[neighbour{i} j]
% end


% délire pour print un bail style a la fin
                     %the code%
%   N = 3; M = 3;                  %# grid size
%   CONNECTED = 4;                 %# 4-/8- connected points
% %# which distance function
% if CONNECTED == 4,     distFunc = 'cityblock';
% elseif CONNECTED == 8, distFunc = 'chebychev'; end
% %# compute adjacency matrix
% [X Y] = meshgrid(1:N,1:M);
% X = X(:); Y = Y(:);
% adj = squareform( pdist([X Y], distFunc) == 1 );
% display(adj);
% %# plot connected points on grid
% [xx yy] = gplot(adj, [X Y]);
% plot(xx, yy, 'ks-', 'MarkerFaceColor','r')
% axis([0 N+1 0 M+1])
% [X Y] = meshgrid(1:N,1:M);
% X = reshape(X',[],1) + 0.1; Y = reshape(Y',[],1) + 0.1;
% text(X, Y(end:-1:1), cellstr(num2str((1:N*M)')) )
% linked_node=cell(N,1);   
%     % the most important step
%   for X=1:N
%       for Y=1:M
%           if ((X~=Y) &&(squareform( pdist([X Y], distFunc) == 1)))
%                linked_node{X}= [linked_node{X} Y];
%           end
%       end
%   end

