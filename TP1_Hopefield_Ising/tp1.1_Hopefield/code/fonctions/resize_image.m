function [ img_resized ] = resize_image( img, l , h )

[ l_img , h_img ] = size(img);

img_resized = zeros(l,h);

for i = 1:l
    for j = 1:h

        if i<l_img & j<h_img
            img_resized(i,j)=img(i,j);       
        end

    end
end



end

