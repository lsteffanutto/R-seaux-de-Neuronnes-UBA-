function [ E ] = calcul_E(Nb_mu,X,Yd,y);

E=0;

for i = 1:Nb_mu
    
    E=E+(Yd(i,1)-y)^2;

end

E = E/2;

end

