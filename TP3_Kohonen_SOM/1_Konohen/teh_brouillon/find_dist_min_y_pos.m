function [dist_min , pos_neu] = find_dist_min_y_pos(input,red);

dist_min_et_position=[];
dist_min_et_position = [ dist_min_et_position norm(red(1,:)-input) 1 ]; %dist euclidienne avec 1erer neuronne
%dist_tab = [dist_tab; dist_min_et_position(1,1)];

nb_neu = length(red);

for i = 2:nb_neu %on compare avec toutes les dist pour trouver la plus petite
    
dist_min = dist_min_et_position(1,1); %dist_min actuelle

dist = norm(red(i,:)-input);
% dist_tab = [dist_tab; dist];

if dist < dist_min
    dist_min_et_position(1,1)=dist; %si on trouve distance inferieure on la stock
    dist_min_et_position(1,2)=i; %ainsi que sa position
end

end

dist_min=dist_min_et_position(1,1);
pos_neu=dist_min_et_position(1,2);
end

