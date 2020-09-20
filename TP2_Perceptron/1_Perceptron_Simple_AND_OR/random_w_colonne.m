function [ w ] = random_w_colonne( nb_w )

w = zeros(nb_w,1);

for i = 1:nb_w

    w(i,1)=randn;

end

