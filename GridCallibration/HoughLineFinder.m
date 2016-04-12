%Detect the longest lines utilzing a hough transform 

%Input the binary image

%Output is the two longest line segments

function [xCorners, yCorners] = HoughLineFinder(BW) 

 [H,theta,rho] = hough(BW);
 P = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
 lines = houghlines(BW,theta,rho,P,'FillGap',5,'MinLength',7);
 
 
    for k = 1:length(lines)
        % Determine the endpoints of the longest line segment 
        len(k) = norm(lines(k).point1 - lines(k).point2);
    end

    [K,I] = sort(len,'descend');
    
    point11 = lines(I(1)).point1;
    point12 = lines(I(1)).point2;
    point21 = lines(I(2)).point1;
    point22 = lines(I(2)).point2;
    
    corners =  vertcat(point11, point12, point21, point22); 
    
    xCorners = corners(:,1);
    yCorners = corners(:,2); 

end
