function result = hazeRemoveUsingDarkChannel(f)

w = 0.95;
patchSize = [3 3];

rf = single(f(:,:,1));
gf = single(f(:,:,2));
bf = single(f(:,:,3));

A = estimateAtmosphericLight(f, patchSize);

Amask = A > 0;
sumAr = sum(sum(rf(Amask))) / sum(sum(Amask));
sumAg = sum(sum(gf(Amask))) / sum(sum(Amask));
sumAb = sum(sum(bf(Amask))) / sum(sum(Amask));

fcopy = single(f(:,:,:));
fcopy(:, :, 1) = rf / sumAr;
fcopy(:,:,2) = gf / sumAg;
fcopy(:,:,3) = bf / sumAb;

%估计t
IADarkChannel = darkChannelFilter(patchSize, fcopy, 'single');
t = 1-w* single(IADarkChannel);
tMask = t < 0.1;
t(tMask) = 0.1;

Afull = zeros(size(f));
Afull(:,:,1) = sumAr;
Afull(:,:,2) = sumAg;
Afull(:,:,3) = sumAb; 

%还原图像
J = (single(f) - single(Afull))./t + Afull;

result = uint8(J);