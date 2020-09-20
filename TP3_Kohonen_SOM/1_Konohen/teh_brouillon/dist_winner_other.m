function [res] = dist_winner_other(winner,red)

res=[];

nb_neu = length(red);

for i = 1:nb_neu
    dist = norm(red(i,:)-winner);
    res = [ res; dist];
end

end

