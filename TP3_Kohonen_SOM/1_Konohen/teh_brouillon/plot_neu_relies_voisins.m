function [ res ] = plot_neu_relies_voisins( red, cote )

res=1;

rang=0;
for j = 1:cote-1
    oui=rang*cote;
    for i = 1:cote-1
        plot([red(i+oui,1) red(i+1+oui,1)],[red(i+oui,2) red(i+1+oui,2)])
        plot([red(i+oui,1) red(cote+i+oui,1)],[red(i+oui,2) red(cote+i+oui,2)])
    end
    rang=rang+1;
end

for k = 1:cote-1
    last =cote*cote-cote;
    plot([red(last+k,1) red(last+k+1,1)],[red(last+k,2) red(last+k+1,2)])
end

for l = 1:cote-1
    plot([red(cote*l,1) red(cote*(l+1),1)],[red(cote*l,2) red(cote*(l+1),2)])
end

% help plot relie voisins
% red = [ 1 1; 1 2; 1 3; 2 1; 2 2; 2 3; 3 1; 3 2; 3 3]; red a tester 
% pour voir si fonction plot relie voisins est pas claquos

% plot([red(1,1) red(2,1)],[red(1,2) red(2,2)]) %neuronne1 compte en colonne en remontant
% plot([red(1,1) red(4,1)],[red(1,2) red(4,2)])
% 
% plot([red(2,1) red(3,1)],[red(2,2) red(3,2)]) %neuronne2
% plot([red(2,1) red(5,1)],[red(2,2) red(5,2)])
% 
% plot([red(3,1) red(6,1)],[red(3,2) red(6,2)]) %neuronne3
% 
% plot([red(4,1) red(5,1)],[red(4,2) red(5,2)]) %neuronne4 = 1 modulo 3
% plot([red(4,1) red(7,1)],[red(4,2) red(7,2)])
% 
% plot([red(5,1) red(6,1)],[red(5,2) red(6,2)]) %neuronne5 = 2 modulo 3
% plot([red(5,1) red(8,1)],[red(5,2) red(8,2)])
% 
% plot([red(6,1) red(9,1)],[red(6,2) red(9,2)]) %neuronne6 = 0 modulo 3
% 
% plot([red(7,1) red(8,1)],[red(7,2) red(8,2)]) %neuronne7
% 
% plot([red(8,1) red(9,1)],[red(8,2) red(9,2)]) %neuronne8

end

