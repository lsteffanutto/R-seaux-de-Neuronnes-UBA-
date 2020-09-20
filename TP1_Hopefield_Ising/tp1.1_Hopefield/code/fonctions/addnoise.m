function [ input_bruit ] = addnoise( input , bruit )

input_bruit = imnoise(input,'gaussian',bruit);
input_bruit = floor(input_bruit);
input_bruit = input_bruit.*2-1;

end

