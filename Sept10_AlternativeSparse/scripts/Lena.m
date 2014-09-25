clear all;
im = imread('resources/lena.pgm');
noised = AddNoise(im);
gaussian = GaussianFilter(noised);
diff = VisualDiff( gaussian,noised );
%imtool(diff);

mnim = MirrorEdges(noised,1);

gmnim = GaussianFilter(mnim);

