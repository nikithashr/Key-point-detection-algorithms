function Corners = HarrisCorners(img)

% parameters
% k: empirically determined constant
% percentage: quality of corners
% threshold: above which are considered to be corners
% N: minimum number of corners computed to assign a quality
% based threshold

k = 0.04; 
percentage = 0.01;
threshold = 10000;
N = 150;

im1 = rgb2gray(img);
im = double(im1);

% detect corner points because corner points make for good features, i.e.,
% any direction you move the window patch, their is a drastic change

% derivatives of gaussian applied on a 5x5 window. 
sobel_x = fspecial('sobel');

im_x = imfilter(im, sobel_x');
im_y = imfilter(im, sobel_x);

% computing the M matrix for both the images. It's a 2x2 Matrix around each
% pixel. W is the window around each pixel that we are interested in looking
% at.
M11 = im_x.*im_x; M12 = im_x.*im_y; M22 = im_y.*im_y;

% smoothen the image convolve with the window function
M11_w = imfilter(M11, fspecial('gaussian', [5,5], 5/3));
M12_w = imfilter(M12, fspecial('gaussian', [5,5], 5/3));
M22_w = imfilter(M22, fspecial('gaussian', [5,5], 5/3));


% computing R for all the pixels by resizing M for better visibility,
% where R is given by det(H) - k (trace(H)/2)^2
% detM  = lambd1 x lamba2
% traceM = lambd1 + lambda2

detH = M11_w(:).*M22_w(:) - M12_w(:).*M12_w(:);
traceH = M11_w(:) + M22_w(:);
traceH = traceH.*traceH;
R = detH - k.*traceH;
R = reshape(R, size(M11));


% finding all the local maximas and pick 
% all the points greater than a certain threshold 
localPeaks = imregionalmax(R, 8);
maxValue = max(R(:));
sortedR = sort(R(:));
numGreaterThanThreshold = size(find(sortedR > threshold),1);

if numGreaterThanThreshold > N
    threshold = maxValue * percentage;
end
thresholdPeaks = R>threshold;

finalPeaks = localPeaks & thresholdPeaks;

% removing border points out of the corners
finalPeaks(1:3,:) = 0;
finalPeaks(end-2:end,:) = 0;
finalPeaks(:,1:3) = 0;
finalPeaks(:,end-2:end) = 0;

[i,j] = find(finalPeaks == 1);
Corners = [i,j];

PlotCorners(img, [j,i]);
end
