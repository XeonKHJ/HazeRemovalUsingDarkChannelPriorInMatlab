[M, N] = size(f);
[f, revertclass] = tofloat(f);
F = fft2(f);
sig = 0.5;
H = hpfilter('gaussian', M, N, sig);

G = H.*F;
g = ifft2(G);
g = revertclass(g);
imshow(g);