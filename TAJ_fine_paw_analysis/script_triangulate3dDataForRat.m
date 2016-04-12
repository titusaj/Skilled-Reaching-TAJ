%Titus John
%Leventhal Lab, University of Michigan
%2/1/2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
clc


pawMarkingData_directory = 'C:\Users\Administrator\Documents\Paw_Point_Marking_Data'; 

computeCamParams = false;
camParamFile = 'C:\Users\Administrator\Desktop\SkilledReaching-master\tattoo_track_testing\intrinsics calibration images\cameraParameters.mat';
cb_path = 'C:\Users\Administrator\Desktop\SkilledReaching-master\tattoo_track_testing\intrinsics calibration images';

kinematics_rootDir = 'C:\Box Sync\Box Sync\Leventhal Lab\Skilled Reaching Project\Matlab Kinematics\PlotGrossTrajectory';
pdfDir  = 'Desktop\SR_plots';

xl_directory = 'C:\Box Sync\Box Sync\Leventhal Lab\Skilled Reaching Project\SR_box_matched_points';
xlName = 'R27';



if computeCamParams
    [cameraParams, ~, ~] = cb_calibration(...
                           'cb_path', cb_path, ...
                           'num_rad_coeff', num_rad_coeff, ...
                           'est_tan_distortion', est_tan_distortion, ...
                           'estimateskew', estimateSkew);
else
    load(camParamFile);    % contains a cameraParameters object named cameraParams
end
K = cameraParams.IntrinsicMatrix;   % camera intrinsic matrix (matlab format, meaning lower triangular
                                    %       version - Hartley and Zisserman and the rest of the world seem to
                                    %       use the transpose of matlab K)
                                    
                                    
sr_ratInfo = get_sr_RatList_win();    
ratDir = cell(1,length(sr_ratInfo));
triDir = cell(1,length(sr_ratInfo));
scoreDir = cell(1,length(sr_ratInfo));

  allSession3dPoints = []; %Hpld all the normalized 3d points

for i_rat =1%:length(sr_ratInfo)
    
    %This part of the script works to get the fundemental matricies  as
    %seen with the
    ratID = sr_ratInfo(i_rat).ID;
    ratDir{i_rat} = fullfile(kinematics_rootDir,ratID);
    
    
    rawData_parentDir = sr_ratInfo(i_rat).directory.rawdata;
    
    triDir{i_rat} = fullfile(ratDir{i_rat},'triData');
    scoreDir{i_rat} = fullfile(ratDir{i_rat},'scoreData');
    
    matchedPoints = read_xl_matchedPoints_rubik_win( ratID, ...
                                                 'xldir', xl_directory, ...
                                                 'xlname', xlName);


    matchedPointsNames = fieldnames(matchedPoints);
    numSessions = length(matchedPointsNames);                
                                             
    [x1_left,x2_left,x1_right,x2_right,mp_metadata,excludePoints,mpLeftFloorIndex ,mpRightFloorIndex,shelfTopLeftLeftIndex,shelfTopLeftRightIndex,shelfTopRightLeftIndex,shelfTopRightRightIndex,rubiksALeftIndex,rubiksARightIndex]= generateMatchedPointVectors(matchedPoints);
    srCal = sr_calibration_win(x1_left,x2_left,x1_right,x2_right);
    
    
    %This section is used to match the dates for the srCal with the Paw
    %marking data
    cd(strcat(pawMarkingData_directory,'\',ratID)); %change to the directory with the 3d fine marking data
    PawPointsFiles = dir; 
    counter =1;
    for iSession = 1: numSessions 
        for j= 1:length(PawPointsFiles)
            if strcmp(mp_metadata.sessionNames{iSession}(7:end), PawPointsFiles(j).name)
                iSessionMatch(counter) = iSession; 
                counter = counter +1; 
            end
        end
    end
    
    
    %Get the mirror side in which the animal will be reachingt
    if strcmp(sr_ratInfo(i_rat).pawPref, 'right')   
        mirrorSide = 1; %where 1 is the left mirror 
    else
        mirrorSide = 2; %where 2 is the right mirror 
    end
    
    
    
%        %Load the data from the pixel callibration file
 %       RubiksCalibrationsFile = strcat('C:\Users\Administrator\Documents\Paw_Point_Marking_Data','\',ratID,'\RubiksScalesFactors_',ratID)
%        load(RubiksCalibrationsFile)
    
 
    
    %loop through the sessios where the pawMarkingData exist
      for iSession = 1   : length(iSessionMatch)
          for scoreCount = 1:2
              if scoreCount == 1
                  score = 1;
              elseif scoreCount == 2
                  score =7; 
              end
                  
        sessionDate = mp_metadata.sessionNames{iSessionMatch(iSession)}(7:end)
        
        %Get the P1 and P2 from the Sr.Cal array
        P1 = eye(4,3);% P1 stays constants 4x3 matrix
        P2 = srCal.P(:,:,mirrorSide,iSessionMatch(iSession))
        F  = srCal.F(:,:,mirrorSide,iSessionMatch(iSession)) 
        
        %Load the Rat Data structure from the paw points file 
        RatSessionDataFile = strcat('C:\Users\Administrator\Documents\Paw_Point_Marking_Data','\',ratID,'\',sessionDate,'\',ratID,'Session',sessionDate,'PawPointFiles.mat')
        load(RatSessionDataFile); 
        
      
        %Get the data from the rat dat paw marked files and then shoot it
        %into the triangualtion function
       [X1,X2,  indexDigitPresent,middleDigitPresent,ringDigitPresent,pinkyDigitPresent]  = RatDataToMPMatrcies(RatData,score,mirrorSide)
        
        
        
        
        
        %Multiply the 3d points by the scale factor to caluclate the
        %trajectories in mm 
        
%        if isempty(AllRubiksScaleFactorLeft) ~= 1 %If the rubiks calibration does not exist switch to the shelf calibration scale
%             if mirrorSide == 1
%                 scaleFactor = AllRubiksScaleFactorLeft(iSession);
% 
%                     if isempty(cell2mat(scaleFactor)) 
%                         scaleFactor = {mean(cell2mat(AllRubiksScaleFactorLeft))};
%                     end
% 
%             elseif mirrorSide == 2
%                 scaleFactor = AllRubiksScaleFactorRight(iSession);
% 
%                     if isempty(cell2mat(scaleFactor)) 
%                         scaleFactor = {mean(cell2mat(AllRubiksScaleFactorRight))};
%                     end
% 
%             end
%         else %Switching to the shelf callibration method 
%              if mirrorSide == 1
%                 scaleFactor = allScaleFactorsLeftShelf(iSession);
% 
%                     if allScaleFactorsLeftShelf(iSession) == 0 
%                         scaleFactor = {mean((allScaleFactorsLeftShelf))};
%                     end
% 
%             elseif mirrorSide == 2
%                 scaleFactor = allScaleFactorsRightShelf(iSession);
% 
%                     if allScaleFactorsRightShelf(iSession) == 0
%                         scaleFactor = {mean((allScaleFactorsRightShelf(allScaleFactorsRightShelf~=0)))};
%                     end
%              end   
%         end
%         
%         
%         
        
        %Get the 3d points for the pellet and the front of the box
%        [wallPoints3d] = frontPannelPointFinder(matchedPoints,ratID,  mirrorSide, sessionDate,srCal, iSessionMatch,iSession) 
   %     [shelfPoints3d] = frontPannelPointFinder(
%        [pelletPoints3d] = findPelletCoordsandTriangulate(ratID, mirrorSide, srCal, sessionDate,iSessionMatch,iSession)
        
%         %Multiply the found 3d points by the scale factor
%         if iscell(scaleFactor)
%             wallPoints3d = cell2mat(wallPoints3d).*cell2mat(scaleFactor);
%             pelletPoints3d = pelletPoints3d.*cell2mat(scaleFactor);
%         else
%             wallPoints3d = cell2mat(wallPoints3d).*(scaleFactor);
%             pelletPoints3d = pelletPoints3d.*(scaleFactor);
%         end
%             
         all3dPoints = [];% reset all 3d points

        for i=1:length(X1(:,1))
            for j= 1:length(X1(1,:))
            
              
                x1 = X1{i,j};
                x2 = X2{i,j};

                x1= vertcat(x1);
                x2= vertcat(x2);

              if sum(size(x1)) > 1
                    
                %Triangulate the fine marked points 
               [points3d,reprojectedPoints,errors] = ConvertMarkedPointsToRealWorld(x1,x2,F,P1,P2)
               
%                     if iscell(scaleFactor) == 0  %Convert to a cell if not already a cell 
%                         scaleFactor = {scaleFactor};
%                     end
%                         
                    
                    all3dPoints{i,j} = points3d;%.*cell2mat(scaleFactor); %multiply by scale factor  %%%%%
                    allreprojectedPoints{i,j} = reprojectedPoints; 
              else
                    all3dPoints{i,j} = [];
              end

            end          
        end

        
        %  filename = strcat('C:\Users\Administrator\Documents\Paw_Point_Marking_Data\',ratID,'\FineTriangulationData\AllDistalFinger3DData_',sessionDate,'_',num2str(score)) 
          
            filename = strcat('C:\Users\Administrator\Documents\Paw_Point_Marking_Data\',ratID,'\FineTriangulationData\AllDistalFinger3DDataOpp_',sessionDate,'_',num2str(score)) 
         
            save(filename,'all3dPoints')
%             
%             
%             filename = strcat('Wall3DData_',sessionDate,'_',num2str(score)) 
%             save(filename,'wallPoints3d')
%             
%             filename = strcat('Pellet3DData_',sessionDate,'_',num2str(score)) 
%             save(filename,'pelletPoints3d')
            
            
            
            
          end
          
        
         
      end     
end