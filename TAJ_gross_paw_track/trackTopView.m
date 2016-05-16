%Titus John
%Leventhal Lab, University of Michgan
%5/13/16
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%inputs


%outputs
%Bounding lines that go down to intersect the epipoles


%Get bounds of the image



function [boundingPoints] =trackTopView(image_ud)

%Set the top mirror mask
x = [848 869 1100 1109];
y = [236 6 2 236];
topMirrorMask = poly2mask(x, y, 1024, 2040);



topMirrorMaskImage = image_ud.*repmat(topMirrorMask,[1,1,3]);
decorr_green_topMirror = decorrstretch(topMirrorMaskImage);
%hsv_decorr_green_topMirror = rgb2hsv(decorr_green_topMirror);

pawRGBrange = [2.5, 1.5 ,0, 0, 0,0];
rgbmaskTopMirror = RGBthreshold(decorr_green_topMirror , pawRGBrange);


%Identify the blob of intrest
[largestBlob] = ExtractNLargestBlobs(rgbmaskTopMirror,1);

%Find the extrema
stats = regionprops(largestBlob,'Extrema');
      
%Have to find where the paw is most spread out when it crosses to the front
%Can run a diff profile around the
sortedExterma = sort(stats.Extrema);

%Find the top of the blob
leftMost  = sortedExterma (1,:);
rightMost = sortedExterma(end,:);


%Find the bottom of the blob
 x1 = leftMost(1);
 x2 = rightMost(1);
 
 boundingPoints(1) = x1;
 boundingPoints(2) = x2;

 

end