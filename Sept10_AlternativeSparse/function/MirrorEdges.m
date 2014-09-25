function [ mirrored ] = mirror_edges( img , radius )
%MIRROR_EDGE Summary of this function goes here
%   Detailed explanation goes here

mirrored = cat(2, img(:, radius+1:-1:2), img, img(: ,end-1:-1:end-radius));
mirrored = cat(1, mirrored(radius+1:-1:2, :), mirrored, mirrored(end-1:-1:end-radius, :));

end

