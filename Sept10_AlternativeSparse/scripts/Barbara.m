clear all;
im = imread('resources/barbara.png');
noised = AddNoise(im);
gaussian = GaussianFilter(noised);
diff = VisualDiff( gaussian,noised );
%imtool(diff);
mnim = MirrorEdges(noised,1);

gmnim = GaussianFilter(mnim);