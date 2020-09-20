function [ w ] = make_w_of_layer( nb_co_pattern_to_next_layer, size_layer )

w = [];

for i = 1:size_layer

    w = [ w random_w_colonne( nb_co_pattern_to_next_layer ) ];

end



