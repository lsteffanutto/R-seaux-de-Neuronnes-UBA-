function [ output ] = PReLU( input , alpha )

output = input;

if input < 0
    output=alpha*input;
end

end

