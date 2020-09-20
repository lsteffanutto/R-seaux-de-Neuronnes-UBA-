function [res] = dist_winner_other_final(winner,red)

nb_neu = length(red)*length(red);

res=zeros(sqrt(nb_neu));


for i = 1:nb_neu
    neu_test = [red(i) red(nb_neu+i)];
    dist = norm(neu_test-winner);
    res(i) =  dist;
end

end

