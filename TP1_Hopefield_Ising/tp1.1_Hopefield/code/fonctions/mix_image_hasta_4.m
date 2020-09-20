function [ mix ] = mix_image_hasta_4( A,B,C,D )

[l,h] = size(A);
mix = zeros(l,h);

mix(1:l/2,1:h/2)=A(1:l/2,1:h/2);
mix(1:l/2,h/2:h)=B(1:l/2,h/2:h);
mix(l/2:l,1:h/2)=C(l/2:l,1:h/2);
mix(l/2:l,h/2:h)=D(l/2:l,h/2:h);


end

