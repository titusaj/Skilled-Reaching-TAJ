%Point correspoindance for inlier images in checkerboard. 
%Input
%Inline 12 points from a center image
%inline 12 points from a side image


%Output
%Will give the image corepondance betwen two images



function [borderCornersX,borderCornersY,cb_pts_x ,cb_pts_y] = correspondCheckboardPoints(cb_pts,xCorners,yCorners)

%Do a a boundary analysis
[k_side,v_side] =  boundary(cb_pts(:,1),cb_pts(:,2));


cb_pts= cb_pts(k_side,:);



cb_pts_x = cb_pts(:,1);
cb_pts_y = cb_pts(:,2);




%The correpsondance of the corner poiunt is left rigt

%Take the points found in the center and find the closest ones that exist
%in the border points 
for i =1:4%length(xCorners) %Circulate thorugh all the corner points first
    for j =1:length(cb_pts) %then match this agaist the border points
        %Use a distance forumula to find the close point to tpo each of the corner points found 
        distancePointsToCorner(i,j) = sqrt((cb_pts_x(j)-xCorners(i))^2+(cb_pts_y(j)-yCorners(i))^2); 
                         
    end
        [K(i),I(i)] = min(distancePointsToCorner(i,:)); 
end




for i = 1:4
    borderCornersX(i) = cb_pts_x(I(i)); 
    borderCornersY(i) = cb_pts_y(I(i));
end




% figure(2)
% hold on
% scatter(cb_pts(:,1),cb_pts(:,2))
% plot(side_x(k_side),side_y(k_side));
% 

% 
% if length(cb_pts_center) == 12  %Make sure the length of the cb points is 12
%     if length(cb_pts_side) == 12
% 
%         
%             [Y_side,IY_side] = sort(cb_pts_side(:,2)); % First find the top most point 
%             [X_side,IX_side] = sort(cb_pts_side(:,1),'descend'); % then the left most point
%             
%             
%             [Y_center,IY_center] = sort(cb_pts_center(:,2)); % First find the top most point 
%             [X_center,IX_center] = sort(cb_pts_center(:,1)); % then the left most point
%         
%        
%             %search through the top 3 point to see whats on top and
%             %rightmost on the checkboar
%             for j =1:3
%               for i = 1:12
%                   if IY_center(i) == IX_center(j)
%                     top_search(j) = i;
%                   end
%               end 
%             end
%            
%             [M, I] = max(top_search);
%             rightOrginCenter = [X_center((M)),Y_center(IY_center(I))]; 
%             
%             
%             
%             
%             for j = 1:3
%               for i = 1:12
%                   if IX_side(j) == IY_side(i)
%                     top_search(j) = i;
%                   end
%               end 
%             end
%            
%             rightOrginSide = [X_side(1),Y_side(top_search(1))];
%        
%            
%             
%         
%     end
% end

end 


