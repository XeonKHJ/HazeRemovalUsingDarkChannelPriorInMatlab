function result = highPassFiltering(f, sig)
% 之前调的sig是10

[M, N] = size(f);
[f, revertclass] = tofloat(f);
F = fft2(f);
H = hpfilter('gaussian', M, N, sig);

G = H.*F;
g = ifft2(G);
g = revertclass(g);

result = g;

end