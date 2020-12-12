function result = SomethingNew(fr, fg, fb, sig)
%SOMETHINGNEW 此处显示有关此函数的摘要
%   fr是原图的R通道
%   fg是原图的G通道
%   fb是原图的B通道。
Fr = highPassFiltering(fr, sig);
Fg = highPassFiltering(fg, sig);
Fb = highPassFiltering(fb, sig);

A = zeros(size(fr,1),size(fr,2),3);
A(:,:,1) = Fr;
A(:,:,2) = Fg;
A(:,:,3) = Fb;

result = A;

end

