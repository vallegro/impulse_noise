block_size = 8;
im_size = size(mnim);

for i1 = 2 : block_size : im_size(1)-1,    
    disp(i1);
    for i2 = 2 : block_size : im_size(2)-1,
        disp(i2);
        
        block_b = mnim(i1-1:i1+block_size , i2-1:i2+block_size);   % block with boundary 10x10
        
        block_b_8 = double(block_b(2:end-1,2:end-1));
        
        lap = Node2Lap(block_b_8);
        
        d1 = (i1-2)/8+1;
        d2 = (i2-2)/8+1;
        lap_product(d1,d2) = block_b_8(:)'*lap*block_b_8(:);
        
        
    end    
end