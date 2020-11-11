function result = medianFilterDehazeChannel(f, patchSize, filterSize)

fi = im2uint8(f);
f = im2single(f);
M = darkChannelFilter(patchSize, f, 'single');
A = medfilt2(M, filterSize);
B = A-medfilt2(abs(A-M), filterSize);

p = 0.95;
pB = p*B;

A = estimateAtmosphericLight(fi, patchSize);
A = im2single(A);
rf = f(:,:,1);
gf = f(:,:,2);
bf = f(:,:,3);
Amask = A > 0;
sumAr = sum(sum(rf(Amask))) / sum(sum(Amask));
sumAg = sum(sum(gf(Amask))) / sum(sum(Amask));
sumAb = sum(sum(bf(Amask))) / sum(sum(Amask));
Afull = zeros(size(f));
Afull(:,:,1) = sumAr;
Afull(:,:,2) = sumAg;
Afull(:,:,3) = sumAb; 

%result = pB;

pBsmallerThenM = pB < M;
pB(pBsmallerThenM) = M(pBsmallerThenM);
pB(pB < 0) = 0;
F = pB;

result = (f - F)./(1 - F./Afull);
%result = pB;

end