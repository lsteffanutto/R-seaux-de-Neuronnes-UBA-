function [ res ] = fonction_voisin(mat_dist_win_otro,sigma)

dist = mat_dist_win_otro;

res=[];

res = exp( (-(dist).^2)/(2*(sigma^2)) );

end

