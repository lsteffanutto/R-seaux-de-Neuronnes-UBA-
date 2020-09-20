function [ matrix_type ] = plot_matrix_type( matrix_type )

[l, c] = size(matrix_type);
test = 1;
if matrix_type(2,3) == -1 & matrix_type(3,3) == -1
for i = 1:l-1
    
    hold on;
    plot(matrix_type(i,1),matrix_type(i,2),'bo');

end

hold on; plot(matrix_type(l,1),matrix_type(l,2),'ro');
xlim([-2 2]);
ylim([-2 2]);
set(gca, 'YAxisLocation', 'origin')
set(gca, 'XAxisLocation', 'origin')

else
test
for i = 1:l-1
    
    hold on;
    plot(matrix_type(i+1,1),matrix_type(i+1,2),'bo');

end

hold on; plot(matrix_type(1,1),matrix_type(1,2),'ro');

if matrix_type(2,3) == 1 & matrix_type(3,3) == 1
    plot(matrix_type(4,1),matrix_type(4,2),'ro');
end

xlim([-2 2]);
ylim([-2 2]);
set(gca, 'YAxisLocation', 'origin')
set(gca, 'XAxisLocation', 'origin')

end

end

