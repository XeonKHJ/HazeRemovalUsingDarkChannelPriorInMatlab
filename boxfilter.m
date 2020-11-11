%利用Ｘ方向和Ｙ方向的累加来完成
function imDst = boxfilter(imSrc,w,h)
[hei, wid] = size(imSrc);
imDst = zeros(size(imSrc));

%w,h分别为盒子滤波器的盒子半径
% w must <= (wid-1)/2
% h must <= (hei-1)/2

%Y轴方向的累加
imCum = cumsum(imSrc, 1);
%首先考虑首部的Ｈ个像素
imDst(1:h+1, :) = imCum(1+h:2*h+1, :);
%中间像素
imDst(h+2:hei-h, :) = imCum(2*h+2:hei, :) - imCum(1:hei-2*h-1, :);
%尾部h个像素
imDst(hei-h+1:hei, :) = repmat(imCum(hei, :), [h, 1]) - imCum(hei-2*h:hei-h-1, :);

%X轴方向的累加
imCum = cumsum(imDst, 2);
%首先考虑首部的Ｘ个像素
imDst(:, 1:w+1) = imCum(:, 1+w:2*w+1);
%考虑中间像素
imDst(:, w+2:wid-w) = imCum(:, 2*w+2:wid) - imCum(:, 1:wid-2*w-1);
%考虑尾部w个像素
imDst(:, wid-w+1:wid) = repmat(imCum(:, wid), [1, w]) - imCum(:, wid-2*w:wid-w-1);
end