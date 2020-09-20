function [ rep ] = OR_matrix()

rep = [];

rep = [ rep ; OR_fonction( -1 ,-1 )];
rep = [ rep ; OR_fonction( 1 ,-1 )];
rep = [ rep ; OR_fonction( -1 ,1 )];
rep = [ rep ; OR_fonction( 1 ,1 )];


end

