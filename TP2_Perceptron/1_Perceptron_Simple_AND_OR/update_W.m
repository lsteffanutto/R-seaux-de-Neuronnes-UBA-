function [ W ] = update_W(W,Wdelta);

W(1,1) = W(1,1)+Wdelta(1,1);
W(1,2) = W(1,2)+Wdelta(1,2);
W(1,3) = W(1,3)+Wdelta(1,3);


end

