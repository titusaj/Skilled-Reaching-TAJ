%Titus John
%Leventhal Lab, University of Michigan
%5/2/16
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%treating the centroid of the sillohetes as matched points and finding the
%centroid 

%inputs
%fullMask
%P2
%image_ud

%outputs
%points 3d 

function [points3d] = fullMasktoPoints3d(fullMask,P2,image_ud) 

%Find centroid of the direct view
centroid_direct = regionprops(fullMask{1}, 'centroid');

%Find centroid of the side view
centroid_side = regionprops(fullMask{2}, 'centroid');



%Set the centorid based on first one found by region prop if multiple
%centroids from multiple blobs

centroid_direct = centroid_direct.Centroid;
centroid_side = centroid_side.Centroid;

% figure(8)
% hold on
% imshow(fullMask{1})
% hold on
% scatter(centroid_direct(1),centroid_direct(2),'r')

figure(3)
hold on
imshow(image_ud)
hold on
scatter(centroid_direct(:,1),centroid_direct(:,2),'r')
hold on
scatter(centroid_side(:,1),centroid_side(:,2),'b')

points3d =  triangulate_DL(centroid_direct,centroid_side,eye(4,3),P2);
end