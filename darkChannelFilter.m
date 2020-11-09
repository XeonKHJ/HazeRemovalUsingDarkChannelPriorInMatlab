function result = darkChannelFilter(patchSize, f, type)

height = patchSize(1);
width = patchSize(2);

result = zeros([size(f, 1), size(f, 2)], type);

%填白

for heiIdx =  1:size(f, 1)
    for widIdx = 1 : size(f, 2)
        halfPatchWidth = uint8((width/2)) - 1;
        halfPatchHeight = uint8((height/2)) - 1;
        
        %控制补丁边界
        widthStartPos = 0;
        widthEndPos = uint32(halfPatchWidth) + uint32(widIdx);
        heightStartPos = 0;
        heightEndPos = uint32(halfPatchHeight) + uint32(heiIdx);
        if(heiIdx <= halfPatchHeight)
            heightStartPos = 1;
        else
            heightStartPos = uint32(heiIdx) - uint32(halfPatchWidth);
        end 
        
        if(widIdx <= halfPatchWidth)
            widthStartPos = 1;
        else
            widthStartPos = uint32(widIdx) - uint32(halfPatchWidth);
        end 
        
        if(heightEndPos > size(f, 1))
            heightEndPos = size(f, 1);
        end
        
        if(widthEndPos > size(f, 2))
            widthEndPos = size(f, 2);
        end
        
        %提取出目前需要计算的
        ff = f(heightStartPos : heightEndPos, widthStartPos:widthEndPos, :);
        
        result(heiIdx, widIdx) = min(ff, [], 'all');
    end
end


