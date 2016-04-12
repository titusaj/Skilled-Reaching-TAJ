%Titus John
%Leventhal Lab, University of Michigan
%2/8/2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This script will shoot out the plots for a given rat and produce
%comparison for the fine reaching analysis after the trajectory analys
%ihaws been completed

%Will compoare the trajectories in term of the average 



clear all
close all
clc


pawMarkingData_directory = 'C:\Users\Administrator\Documents\Paw_Point_Marking_Data'; 
sr_ratInfo = get_sr_RatList_win();    
                                   
  
successFileCount = 1;
failFileCount = 1;

allRatallCentroidCounter = 1; 

for i_rat = [1,2,3,4,6]%:length(sr_ratInfo)                                    

    ratID = sr_ratInfo(i_rat).ID;   
    
    %Change to the directory where the fine marking data for a given rat
    cd (strcat(pawMarkingData_directory,'\',ratID,'\FineTriangulationData'));  % change this back to normal 
    fine3dDataFiles = dir('MergedAllD*.mat'); %Looking for index

    for i =1:length(fine3dDataFiles) 
         currentSession = strsplit(fine3dDataFiles(i).name,'_')   
         sessionDates{i} = currentSession{2} 
         
         score = 0;
         if findstr(currentSession{3},'1')
            score = 1;
         elseif findstr(currentSession{3},'7')
            score = 7;  
         end
         
         sessionDate = sessionDates{i};
         
         if  mod(i,2) == 1
            fig_num_all = i;
            fig_num_avg = i+1;
         end
         
         load(fine3dDataFiles(i).name) %This will load each of the 3d points one at a time        
         [allCentroids,averagedCentroids, euclidianDistDiff,  euclidianDistDiffMean, euclidianDistDiffStd,averagedCentroidsDisp] = TrajectoryCalculationFineMarking(all3dPoints,score,ratID,sessionDate,fig_num_all,fig_num_avg);
         
         
         for iii = 1:length(allCentroids(:,1))
             allRatallCentroids(allRatallCentroidCounter,:) =  allCentroids(iii,:)
             allRatallCentroidCounter  = allRatallCentroidCounter  +1;
         end
         
         
         allAveragedCentroids{i} = averagedCentroids;
         allAveragedCentroidsDisp{i} = averagedCentroidsDisp;
         
         scoreCat = [];
         sessionCat =[];
         if i ==1  
             for ii = 1:length(allCentroids(:,1))
                 scoreCat{ii} = score; 
             end
             
             for ii = 1:length(allCentroids(:,1))
                 sessionCat{ii} = i; 
             end
             
             allCentroids = horzcat(allCentroids, scoreCat', sessionCat');
             allSession3dCentroidPoints= allCentroids;
             
         else
             for ii = 1:length(allCentroids(:,1))
                 scoreCat{ii} = score; 
             end
             
             for ii = 1:length(allCentroids(:,1))
                 sessionCat{ii} = i; 
             end
             
             
       
                 
             
             allCentroids = horzcat(allCentroids, scoreCat', sessionCat');
             
             allSession3dCentroidPoints = vertcat(allSession3dCentroidPoints, allCentroids);
             
        end
         
         hold on
         
         
         if score == 1
          allAveragedEuclidDistSuccessMean{successFileCount} = euclidianDistDiffMean; 
          allAveragedEuclidDistSuccessStd{successFileCount} = euclidianDistDiffStd;
          successFileCount =   successFileCount +1;
         else
          allAveragedEuclidDistFailMean{failFileCount} = euclidianDistDiffMean; 
          allAveragedEuclidDistFailStd{failFileCount} = euclidianDistDiffStd;
          failFileCount = failFileCount +1; 
         end
         
         
         
         
    end
    
          filename = strcat('allSession3dCentroidPoints_',ratID) 
         save(filename,'allSession3dCentroidPoints')
          
          filename = strcat('allAveragedCentroids_',ratID) 
          save(filename,'allAveragedCentroids')
          
          filename = strcat('allAveragedCentroidsDisp_',ratID) 
          save(filename,'allAveragedCentroidsDisp')
    
%     
%     for i =1:6 %loop through the fiugres 
%         
%          currentSession = strsplit(fine3dDataFiles(i).name,'_')   
%          sessionDates{i} = currentSession{2} 
%          
%          score = 0;
%          if findstr(currentSession{3},'1')
%             score = 1;
%          elseif findstr(currentSession{3},'7')
%             score = 7;  
%          end
%          
%          sessionDate = sessionDates{i};
%                  
%          
%          figure(i)
%             %Plot the appropiate wall and pellet in the figure
%           filename_Pellet = strcat('Pellet3DData_',sessionDate,'_',num2str(score)) 
%           filename_Wall = strcat('Wall3DData_',sessionDate,'_',num2str(score))
%           
%           load(filename_Pellet)
%           load(filename_Wall)
%          
%          for ii = 1:length(wallPoints3d)
%             if ii == 3
%               [x,z] =meshgrid(-20:20, -20:20);
%                 y=wallPoints3d(ii)*(ones(41));
%                 surf(x,y,z)
%             end
%          end
% 
%         scatter3(pelletPoints3d(1),pelletPoints3d(3),pelletPoints3d(2))
%     end
%     


end