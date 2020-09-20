function [ output ] = PReLU_derive( input , alpha )

output = 1;

if input < 0
    output=alpha;
end

end