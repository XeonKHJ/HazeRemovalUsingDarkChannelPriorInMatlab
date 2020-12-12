function dehaze(imgPath)
I=im2double(imread(imgPath));
w0 = 0.95 ;%ȥ��ϵ��ѡ0.95
[h,w,c]=size(I) ;
for i= 1 : h
    for j= 1 : w
        dark_channel(i,j)=min(I(i,j,:)) ;
    end
end
%�󵽰�ͨ����������������Сֵ�˲�
dark_channel=ordfilt2(dark_channel,1,ones(9,9),'symmetric');
%���������ֵ
A = max(max(dark_channel));
[a,b]=find(dark_channel == A);
a=a(1);
b=b(1);
A=mean(I(a,b,:));
%���ʼ͸����
transmission=1 - w0 * dark_channel ./ A;
guided_image=I(:,:,1);
%�����˲�Matlab R2014a��ֱ�ӵ����ˣ��Գ�ʼ͸���ʽ��������˲�
transmission2=imguidedfilter(transmission,guided_image,'NeighborhoodSize',[3,3]);
t0=0.1;
t=max(transmission2,t0);
for l = 1:c
    dehaze(:,:,l)=(I(:,:,l)-A)./t + A;
end
imshow([I,dehaze]);
end