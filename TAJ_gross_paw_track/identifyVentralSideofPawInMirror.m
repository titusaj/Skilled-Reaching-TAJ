%Titus John
%5/5/16
%Leventhal Lab
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%When the centroid is not being found in the direct create a region of
%intrest where the paw will exisit based on the other side precptive

% Find the center in the side prespetive 
% 



%input 
%fundMat correpsonding to the paw prefrenced side and the direct
%prsepective as opposed to side prespetive

%Take


%Output
%Take the 


function [y,points, nonZeroElements,nonZeroElements2] = identifyVentralSideofPawInMirror(strImage,boxRegions,fundMatOpp,pawPref,centerProjImage)

    %Find the thresholded projected image
    sideProjImage = strImage & boxRegions.extMask;
    

    %Pick of the biggest blobs from the image
    [binaryImageBiggestBlobs,oneBlobCheck] = ExtractNLargestBlobs(sideProjImage, 3);  

    %Find the centroid of the oppoisite mirror where 
    [labeledImage, numberOfBlobs] = bwlabel(binaryImageBiggestBlobs);

    %The image labelel 1 will be the largest in this extrackted image
    mirrorImage = (labeledImage == 1);
    
    %Find the centroid of the blob that is found in the mirror, this blob
    %should correpond to the paw blob
    mirrorImageCentroid= regionprops(mirrorImage,'Centroid')
    centroidMirror = mirrorImageCentroid
    
    %Draw the epipolar line based on the center of the mirror
    lines = epipolarLine(fundMatOpp,centroidMirror.Centroid);
    points = lineToBorderPoints(lines, size(binaryImageBiggestBlobs));

    %x and y 
    x = [1:2040];
    y= (-lines(1).*x-lines(3))/lines(2);
    
%     %Check epipolar line is being plotted correctly
%             figure(8)
%             imshow(centerProjImage)
%             hold on
%             line(points(:, [1,3])', points(:, [2,4])');
%               hold on
%             scatter(centroidMirror.Centroid(1),centroidMirror.Centroid(2),'b')


            
    %Get the profile of the image using the epipolar line
    profile  = improfile(centerProjImage ,points(:, [1,3]),points(:, [2,4]));

    % Find intersection points.
	dif = diff(profile);
	
	% Find where it goes from 0 to 1, and dif == 1;
	nonZeroElements = find(dif > 0);

	% Find where it goes from 1 to 0, and dif == -1;
	nonZeroElements2 = find(dif < 0);
    
    
    
        
end