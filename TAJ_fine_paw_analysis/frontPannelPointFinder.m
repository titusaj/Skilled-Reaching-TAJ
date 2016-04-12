%Titus John
%Leventhal Lab, University of Michigan
%2/8/2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This script will take the points that were makred for the front wall and
%will then spit out the coodiantes to draw a 3d wall into the figure 


%first create the epipole based on the fudmental matrix that is given


%Input
%Fundemental matrix for the epipolar triangulation
%Points that from the side points marked in order to  put into the epipole
%function

%Output 
%plot3d( [x1 x2 x3 x4 x1], [y1 y2 y3 y4 y1], [z z z z z] )


%need four points to draw the wall for
%plot3d( [x1 x2 x3 x4 x1], [y1 y2 y3 y4 y1], [z z z z z] )

function  [wallPoints3d] = frontPannelPointFinder(matchedPoints,ratID,  mirrorSide, sessionDate,srCal, iSessionMatch,iSession) 

    %look at the correct mirror view  based on the mirror side used             
    if  mirrorSide == 1
       viewMatchedPointsTempName = {strcat('matchedPoints.',ratID,'_',sessionDate,'.leftMirror')};
       viewMatchedPoints = eval(viewMatchedPointsTempName{1});
       viewMatchedPointsNames = fieldnames(viewMatchedPoints);
    elseif mirrorSide == 2
       viewMatchedPointsTempName = {strcat('matchedPoints.',ratID,'_',sessionDate,'.rightMirror')};
       viewMatchedPoints = eval(viewMatchedPointsTempName{1});
       viewMatchedPointsNames = fieldnames(viewMatchedPoints);
    end


    %These are the matched points for the center presepective
       viewMatchedPointsTempName = {strcat('matchedPoints.',ratID,'_',sessionDate,'.direct')};
       viewMatchedPointsCenter = eval(viewMatchedPointsTempName{1});
       viewMatchedPointsCenterNames = fieldnames(viewMatchedPoints);




    for ii = 1:length(viewMatchedPointsNames)
             if strcmp(viewMatchedPointsNames{ii}, 'front_panel_top_front')
                mpFront_panel_top_front_index = ii; 
             end   
    end



    %Get the floor points from the direct view
    for ii = 1:length(viewMatchedPointsCenterNames)
            if strcmp(viewMatchedPointsCenterNames{ii}, 'left_top_floor_corner')
                LeftFloorIndex = ii;  
            end

            if strcmp(viewMatchedPointsCenterNames{ii}, 'right_top_floor_corner')
                RightFloorIndex = ii; 
            end
    end
    
    if mirrorSide == 1
        floorIndex = LeftFloorIndex; 
    else 
        floorIndex = RightFloorIndex; 
    end



    
        %Get the P1 and P2 from the Sr.Cal array
       P1 = eye(4,3);% P1 stays constants 4x3 matrix
       P2 = srCal.P(:,:,mirrorSide,iSessionMatch(iSession))
       F  = srCal.F(:,:,mirrorSide,iSessionMatch(iSession)) 
        

    %Get the next four points from the top front pannel index based on the side
    %index
    for i =1:4
        wallPoints{i} = viewMatchedPoints.(viewMatchedPointsNames{mpFront_panel_top_front_index+(i-1)}); 
    end

    %Get the floor points from the direct veiw prespetive 
    if mirrorSide == 1
        floorPoints  =  viewMatchedPointsCenter.(viewMatchedPointsCenterNames{LeftFloorIndex});
        floorLine = [1,0,-floorPoints(2)];
    else
        floorPoints =  viewMatchedPointsCenter.(viewMatchedPointsCenterNames{RightFloorIndex});
        floorLine = [1,0,-floorPoints(2)]
    end
    
    
    
   
    for i =1:4   
    %next put this in the epilor calculation  
         lines{i} = epipolarLine(F',cell2mat(wallPoints(i)));
    %find the closest point the epipolar line and the top floor wall 
         wall_center_pt{i} = findIntersection(lines{i},floorLine);
    %next take the wall center points and side matched points and then shoot them in to the reiangulate function  
         [wallPoints3d{i},reprojectedPoints,errors] = ConvertMarkedPointsToRealWorldUP(wall_center_pt{i},wallPoints{i},F,P1,P2)
    end
    
    
    for i = 1:4
        x(i) = wallPoints3d{1,i}(1,1);
        y(i) = wallPoints3d{1,i}(1,2);
        z(i) = wallPoints3d{1,i}(1,3);
    end

 
    
end