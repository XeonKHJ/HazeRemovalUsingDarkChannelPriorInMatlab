function A = estimateAtmosphericLight(f, filterSize)

darkChannel = darkChannelFilter(filterSize, f, 'uint8');
numOfPixels = size(f,1) * size(f,2);
numOfBrightestPixels = uint32(0.001 * numOfPixels);
for brightness = 0:255
    brightMask = (darkChannel >= brightness);
    if(sum(sum(brightMask)) < numOfBrightestPixels)
        break;
    end
end

A = darkChannel.*uint8(brightMask);

