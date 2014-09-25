function [ diff ] = VisualDiff( im_a,im_b )
%VISUALDIFF Summary of this function goes here
%   Detailed explanation goes here
    diff = uint8((double(im_a)-double(im_b))/2 + 128);
end

