function [ opt ] = BlockOptimize( mnim   )
%BLOCKOPTIMZIE Summary of this function goes here
%   Detailed explanation goes here

im_size = size(mnim);
block_size = 8;

opt = zeros(im_size(1)-2);                     % the denoised image
opt_temp = mnim;
for i1 = 2 : block_size : im_size(1)-1,    
    disp(i1);
    for i2 = 2 : block_size : im_size(2)-1,
        disp(i2);
        block_eo = mod((i1-2)/block_size+(i2-2)/block_size , 2);   % chessboard sequencing
        block_b = mnim(i1-1:i1+block_size , i2-1:i2+block_size);   % block with boundary 10x10
        %if ~block_eo,
            opt(i1-1:i1+block_size-2 , i2-1:i2+block_size-2) = NoBoundary(block_b);
            opt_temp(i1:i1+block_size-1 , i2:i2+block_size-1) = opt(i1-1:i1+block_size-2 , i2-1:i2+block_size-2);
        %end
    end    
end
% 
% for i1 = 2 : block_size : im_size(1)-1,
%     fprintf('*%d\n',i1);
%     for i2 = 2 : block_size : im_size(2)-1,
%         fprintf('*%d\n',i2);
%         block_eo = mod((i1-2)/block_size+(i2-2)/block_size , 2);   % chessboard sequencing
%         block_b = opt_temp(i1-1:i1+block_size , i2-1:i2+block_size);   % block with boundary 10x10
%         if block_eo,
%             opt(i1-1:i1+block_size-2 , i2-1:i2+block_size-2) = Boundary(block_b);
%         end
%     end
% end

end

