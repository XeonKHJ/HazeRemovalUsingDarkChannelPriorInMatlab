function t = softMatting(f, tCon, patchSize)

%获得软抠图的拉普拉斯矩阵


height = patchSize(1);
width = patchSize(2);

halfPatchWidth = uint8((width/2)) - 1;
halfPatchHeight = uint8((height/2)) - 1;

mattingLaplacianMatrix = zeros(size(f,1),size(f,2));

%L = zeros(size(f,1)*size(f,2),size(f,1)*size(f,2), 'uint8'); 
for heiIdx =  1:size(f, 1)
    for widIdx = 1 : size(f, 2)

        %控制补丁边界

        widthEndPos = uint32(halfPatchWidth) + uint32(widIdx);

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
        
        
        for khIdx = 1:size(ff, 1)
            for kwIdx = 1:size(ff,2)

                currenthIdx = heiIdx + khIdx - 1;
                currentwIdx = widIdx + kwIdx - 1;

                kroneckerDelta = 0;
                if(currenthIdx == currentwIdx)
                    kroneckerDelta = 1;
                end

                %算拉普拉斯的鬼东西
                currentPixelValueI = reshape(f(currenthIdx, :,:), [], 3);
                currentPixelValueJ = reshape(f(:,currentwIdx, :), [], 3);

                %计算窗口中的像素数量
                numOfPixelInWindow = size(ff,1) * size(ff,2);

                %计算Ii和Ij
                Ii = f(heiIdx, :, :);
                Ij = f(:, widIdx, :);

                %当前窗口的像素均值
                miu = mean(ff(:));

                %创建单位矩阵
                U3 = eye(3,3);

                %计算协方差矩阵
                fCov = cov(single(reshape(f, [], 3)));

                epsilion = 0;

                %第二项
                secondItem = (1/numOfPixelInWindow) * (1 + (single(currentPixelValueI) - miu) * pinv((fCov + epsilion/numOfPixelInWindow) * U3) * (single(currentPixelValueJ') - miu));
                
                %总体
                currentSum = kroneckerDelta - secondItem;
            end
        end
    end
end


        



t = (lambda * tCon) ./ (L+lambda*U);