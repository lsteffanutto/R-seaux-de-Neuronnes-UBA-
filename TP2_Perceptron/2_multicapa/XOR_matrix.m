function [ rep ] = XOR_matrix()

rep = [];

rep = [ rep ; XOR_fonction( -1 ,-1 )];
rep = [ rep ; XOR_fonction( 1 ,-1 )];
rep = [ rep ; XOR_fonction( -1 ,1 )];
rep = [ rep ; XOR_fonction( 1 ,1 )];


end