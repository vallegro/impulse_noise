function [ filtered ] = GaussianFilter( noised )
%GAUSSIANFILTER Summary of this function goes here
%   Detailed explanation goes here
    img_size = size(noised);
    filtered = zeros(img_size);
    
    kernel_radius = 5;
    gaussian_filter = fspecial('gaussian', kernel_radius*2+1 ,2);
    
    mirrored = MirrorEdges(noised , kernel_radius);
        
    for i1 = 1:img_size(1),
        for i2 = 1:img_size(2),
            patch = double(mirrored(i1:i1+kernel_radius*2,i2:i2+kernel_radius*2)).*gaussian_filter;
            filtered(i1,i2) = sum(sum(patch))/sum(sum(gaussian_filter));
        end
    end
    filtered = uint8(filtered);
end

