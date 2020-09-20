function [ res ] = plot_circle( x,y,r ) % x et y centre, r =rayon

res=1;

th = 0:pi/50:2*pi;
xunit = r * cos(th) + x;
yunit = r * sin(th) + y;
h = plot(xunit, yunit, 'black--');

end

