%Overall function is to find the front box and the side points and then
%take the fundemental matrix form the cr calibration matrix and then create
%the traignulate points corresponding the front plane of the box also the
%bootom floor of the box



%Input 
% This will put in the calibration image
% Fudemental matrix found in the SR calibration matrix
% Take in the points corresponding to the planes
% Take in the 2 ppoints found in the side mirror corresponding to the lines



%Output
% Spit out the 3d plot of the points plotted in 3d
% 




%This will take the sr cal and triangulate the points given 



for iSession = 1
    for mirrorSide = 1:2

            x1 = [];
            x2 = [];
        
            if mirrorSide == 1
                x1 = cell2mat(x1_left);
                x2 = cell2mat(x2_left);
            elseif mirrorSide == 2
%                 x1 = cell2mat(x1_right);
%                 x2 = cell2mat(x2_right);
%             elseif mirrorSide == 3
                x1 = cell2mat(x1_top);
                x2 = cell2mat(x2_top);
            end
                
                
                
                
            %Get the P1 and P2 from the Sr.Cal array
            P1 = eye(4,3);% P1 stays constants 4x3 matrix
            P2 = srCal.P(:,:,mirrorSide,iSession)
            F  = srCal.F(:,:,mirrorSide,iSession) 
            
            
            if mirrorSide == 1
                [leftPoints3d,reprojectedPoints,errors] = ConvertMarkedPointsToRealWorld(x1,x2,F,P1,P2)
%             elseif mirrorSide == 3
%                 [rightPoints3d,reprojectedPoints,errors] = ConvertMarkedPointsToRealWorld(x1,x2,F,P1,P2)
            elseif mirrorSide == 2
                [topPoints3d,reprojectedPoints,errors] = ConvertMarkedPointsToRealWorld(x1,x2,F,P1,P2)
            end
    end
  
end



    figure
    hold on
    
    scatter3(leftPoints3d(:,1),leftPoints3d(:,2),leftPoints3d(:,3),'r')
   % scatter3(rightPoints3d(:,1),rightPoints3d(:,2),rightPoints3d(:,3),'b')
    scatter3(topPoints3d(:,1),topPoints3d(:,2),topPoints3d(:,3),'b')