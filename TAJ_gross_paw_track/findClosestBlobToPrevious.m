%Titus John
%Leventhal Lab, University of Michigan
% 5/18/2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Input
%Previous Mask Dilation
%Thresholded mirror green image


%Output
%The newly labeled paw which is closest to the previous paw


function closestBlobToPrev = findClosestBlobToPrevious(prevMask, mirror_greenHSVthresh)


% Take the temp object and then find the biggest blob with the assumption
% this will be the dorsal surface of the paw. 
[biggestBlobs, oneBlobCheck]  = ExtractNLargestBlobs(mirror_greenHSVthresh,6);

%Label the hsv thresholded imagew
[labeledBlobs,NumBlobs] = bwlabel(biggestBlobs);

%find the centroid of the ;previosuly labeled image
%Centroid 
prevCentroid = regionprops(prevMask, 'centroid');
prevCentroid = prevCentroid.Centroid;

        %Go through the labeled blobs and see which one is the closes
        for i = 1:NumBlobs
           %Find the centroid of the blobs that are identified
           currentBlobCentroid = regionprops(labeledBlobs==i,'centroid');
           %Store these centroids in an array 
           blobCentroids(i,:) = currentBlobCentroid.Centroid;
        end


        for i =1:NumBlobs
            distancesBlobs(i) = sqrt((prevCentroid(1)-blobCentroids(i,1))^2+(prevCentroid(2)-blobCentroids(i,2))^2);

        end

 [sortedBlobs, N] =sort(distancesBlobs);
 
 
     
 closestBlobToPrev = (labeledBlobs == N(1));%Where the first distance found on the labeled list is the closest to the paw centroid
  


end