function result = hazeRemoveUsingDarkMedian(f)

fi = f;
f = im2single(f);
w = 0.95;
patchSize = [7 7];

rf = f(:,:,1);
gf = f(:,:,2);
bf = f(:,:,3);

A = estimateAtmosphericLight(fi, patchSize);
A = im2single(A);

Amask = A > 0;
sumAr = sum(sum(rf(Amask))) / sum(sum(Amask));
sumAg = sum(sum(gf(Amask))) / sum(sum(Amask));
sumAb = sum(sum(bf(Amask))) / sum(sum(Amask));

fcopy = f(:,:,:);
fcopy(:, :, 1) = rf / sumAr;
fcopy(:,:,2) = gf / sumAg;
fcopy(:,:,3) = bf / sumAb;

%估计t
IADarkChannel = medianFilterDehazeChannel(fcopy, patchSize, [7 7]);
t = 1-w* single(IADarkChannel);
tMask = t < 0.1;
t(tMask) = 0.1;

Afull = zeros(size(f));
Afull(:,:,1) = sumAr;
Afull(:,:,2) = sumAg;
Afull(:,:,3) = sumAb; 

%还原图像
J = (single(f) - single(Afull))./t + Afull;

result = im2uint8(J);