function dehaze(imgPath)
I=im2double(imread(imgPath));
w0 = 0.95 ;%去雾系数选0.95
[h,w,c]=size(I) ;
for i= 1 : h
    for j= 1 : w
        dark_channel(i,j)=min(I(i,j,:)) ;
    end
end
%求到暗通道，并对它进行最小值滤波
dark_channel=ordfilt2(dark_channel,1,ones(9,9),'symmetric');
%求大气亮度值
A = max(max(dark_channel));
[a,b]=find(dark_channel == A);
a=a(1);
b=b(1);
A=mean(I(a,b,:));
%求初始透射率
transmission=1 - w0 * dark_channel ./ A;
guided_image=I(:,:,1);
%引导滤波Matlab R2014a能直接调用了，对初始透射率进行引导滤波
transmission2=imguidedfilter(transmission,guided_image,'NeighborhoodSize',[3,3]);
t0=0.1;
t=max(transmission2,t0);
for l = 1:c
    dehaze(:,:,l)=(I(:,:,l)-A)./t + A;
end
imshow([I,dehaze]);
end