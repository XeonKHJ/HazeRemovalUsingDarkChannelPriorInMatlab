function result = hazeRemoveUsingDarkChannel(f, patchSize)

% patchsize在第一次时用的是15×15
% 改成3×3可以试看看though
tic;
fi = imresize(f, 0.5);
f = im2single(f);
fs = imresize(f,0.5); %用来取代以下要重新调整大小的f
w = 0.95;
%patchSize = [15 15];

rf = fs(:,:,1);
gf = fs(:,:,2);
bf = fs(:,:,3);


[A, darkChannel] = estimateAtmosphericLight(fi, patchSize);
A = im2single(A);


Amask = A > 0;
sumAr = sum(sum(rf(Amask))) / sum(sum(Amask));
sumAg = sum(sum(gf(Amask))) / sum(sum(Amask));
sumAb = sum(sum(bf(Amask))) / sum(sum(Amask));

fcopy = fs(:,:,:);
fcopy(:, :, 1) = rf / sumAr;
fcopy(:,:,2) = gf / sumAg;
fcopy(:,:,3) = bf / sumAb;

%imresize(fcopy, 0.5);
%估计t
IADarkChannel = darkChannelFilter(patchSize, fcopy, 'single');
IADarkChannel = imresize(IADarkChannel, [size(f, 1) size(f,2)]);
%figure;imshow(IADarkChannel);

t = 1-w* single(IADarkChannel);

t=imguidedfilter(t,im2gray(f),'NeighborhoodSize',[301 301]);

tMask = t < 0.1;
t(tMask) = 0.1;

Afull = zeros(size(f));
Afull(:,:,1) = sumAr;
Afull(:,:,2) = sumAg;
Afull(:,:,3) = sumAb; 

%transmission2=imguidedfilter(transmission,guided_image,'NeighborhoodSize',[30,30]);

%还原图像
J = (single(f) - single(Afull))./t + Afull;
% %figure;
% %imshow(J);
% lightBorders = SomethingNew(J(:, :, 1), J(:, :, 2), J(:, :, 3), 10);
% lightBorders = IADarkChannel .* lightBorders;
% %figure;
% %imshow(J - lightBorders);
% originalLightBorders = SomethingNew(f(:, :, 1), f(:, :, 2), f(:, :, 3), 10);
% %figure;
% %imshow(originalLightBorders);
toc

result = im2uint8(J);