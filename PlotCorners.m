function [ ] = PlotCorners( im, corners )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
imshow(im);
axis equal
hold on

    plot(corners(:,1), corners(:,2),'r.','MarkerSize',20)

% for i=1:size(corners,1)
%     plot(corners(i,:),'r.','MarkerSize',20)
% end

end

