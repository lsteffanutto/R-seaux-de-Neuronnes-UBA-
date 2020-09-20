function [ rep ] = AND_matrix()

rep = [];

rep = [ rep ; AND_fonction( -1 ,-1 )];
rep = [ rep ; AND_fonction( 1 ,-1 )];
rep = [ rep ; AND_fonction( -1 ,1 )];
rep = [ rep ; AND_fonction( 1 ,1 )];


end

