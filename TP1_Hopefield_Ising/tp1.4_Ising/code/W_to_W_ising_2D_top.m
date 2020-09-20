function [ matrix_W_ising_2D ] = W_to_W_ising_2D_top( matrix_W )

                                             % Sample matrix
[l, c] = size(matrix_W);                     % Get the matrix size
diagVec1 = repmat([ones(c-1, 1); 0], l, 1);  % Make the first diagonal vector
                                             %   (for horizontal connections)
diagVec1 = diagVec1(1:end-1);                % Remove the last value
diagVec2 = ones(c*(l-1), 1);                 % Make the second diagonal vector
                                             %   (for vertical connections)
adj = diag(diagVec1, 1)+diag(diagVec2, c);   % Add the diagonals to a zero matrix
adj = adj+adj.';                             % Add the matrix to a transposed copy of
                                             %   itself to make it symmetric

end
