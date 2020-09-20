function [ X ] = vect_X( matrix_type, ligne )

x1 = matrix_type(ligne, 1);
x2 = matrix_type(ligne, 2);

X = [x1 , x2];
end

