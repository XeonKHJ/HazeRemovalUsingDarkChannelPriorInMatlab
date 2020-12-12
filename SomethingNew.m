function result = SomethingNew(fr, fg, fb, sig)
%SOMETHINGNEW �˴���ʾ�йش˺�����ժҪ
%   fr��ԭͼ��Rͨ��
%   fg��ԭͼ��Gͨ��
%   fb��ԭͼ��Bͨ����
Fr = highPassFiltering(fr, sig);
Fg = highPassFiltering(fg, sig);
Fb = highPassFiltering(fb, sig);

A = zeros(size(fr,1),size(fr,2),3);
A(:,:,1) = Fr;
A(:,:,2) = Fg;
A(:,:,3) = Fb;

result = A;

end

