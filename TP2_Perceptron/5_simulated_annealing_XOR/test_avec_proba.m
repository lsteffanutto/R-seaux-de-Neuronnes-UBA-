function [ res ] = test_avec_proba( loi_proba_expo )

res = 1;
change_or_no = rand(1);          %we select a number aleatoire in [0 ; 1] 
                                 % tu regard ou il se situe 
                                 % par rapport a la loi de proba souhaite
                                 % plus il est proche de 0 plus y'a de
                                 % chance pour que ça marche
if change_or_no > loi_proba_expo      % si il est pas dans la loi tu invalides le test
    res = 0;
end

end

