%Titus John
%Leventhal Lab, University of Michgan
%5/13/16
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%inputs


%outputs
%Bounding lines that go down to intersect the epipoles


%Get bounds of the image



function [boundingLines] =trackTopView(image_ud, boxRegions)

%Set the top mirror mask
x = [374 260 1715 1625];
y = [252 5 9 227];
topMirrorMask = poly2mask(x, y, 1024, 2040);



topMirrorMaskImage = image_ud.*repmat(topMirrorMask,[1,1,3]);
decorr_green_topMirror = decorrstretch(topMirrorMaskImage);
%hsv_decorr_green_topMirror = rgb2hsv(decorr_green_topMirror);

pawRGBrange = [2.5, 1.5 ,0, 0, 0,0];
rgbmaskTopMirror = RGBthreshold(decorr_green_topMirror , pawRGBrange);



%Find the edges of the paw and creating a bounding box that will intersect
%with the epipolar lines previously drawn


%Onnce the blob of intrest is found draw two lines that will corrsponds to
%vertical lines that bound paw when turned


%Have to find where the paw is most spread out when it crosses to the front
%Can run a diff profile around the 


%Find the top of the blob


%Find the bottom of the blob

%Run a diff from the top to the bottom of the blob looking for the region which is the widdest
%Find the widest are 









end