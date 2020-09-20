function [ vecteurs_in_cercle ] = random_unit_cercle( nb_points, xc,yc , radius )

vecteurs_in_cercle = [];
% radius = 1; %rayon
% xc = 0; %centre
% yc = 0;
% Engine
theta = rand(1,nb_points)*(2*pi);
r = sqrt(rand(1,nb_points))*radius;
x = xc + r.*cos(theta);
y = yc + r.*sin(theta);
vecteurs_in_cercle = [ x(:) y(:) ]; %on les mets en colonne
% Check
%plot(x,y,'.')
% MRC Bruno la zone en personne

end

