%Titus John
%Leventhal Lab, University of Michigan
%2/29/2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   close all 
   clear all
   
pawMarkingData_directory = 'C:\Users\Administrator\Documents\Paw_Point_Marking_Data'; 
sr_ratInfo = get_sr_RatList_win();    


successFileCount = 1;
failFileCount = 1;

for i_rat =[1,3,6]%:length(sr_ratInfo)

    ratID = sr_ratInfo(i_rat).ID;   
    
    %Change to the directory where the fine marking data for a given rat
    cd (strcat(pawMarkingData_directory,'\',ratID,'\FineTriangulationData'));
    
    allCentroidsFilename = strcat('allSession3dCentroidPoints_',ratID);
    load(allCentroidsFilename)
    
        x_all = [];
        y_all = [];
        z_all = [];


    for i=1:length(allSession3dCentroidPoints) 
            currentTraj = (allSession3dCentroidPoints(i,:));   
            check = 0;
            for  j = 1:5 %Number of frames
                currentFrame = currentTraj{1,j};

                 if size(currentFrame)> 0
                     TF = 0;
                 else
                     TF = 1;
                 end

                 if TF == 0 && check == 0;


                        x(j) = currentFrame(:,1);
                        y(j) = currentFrame(:,2);
                        z(j) = currentFrame(:,3);


                        x_all{i,j} = x(j);
                        y_all{i,j} = y(j);
                        z_all{i,j} = z(j);

                 elseif TF == 1
                    check =1; 
                 end
            end     
    end
    
    
    for k =[2,6] %This will loop through the individual sessions 
        
        counterSession = 1;
      for ii= 1:length(x_all)
          if cell2mat(allSession3dCentroidPoints(ii,7)) == k
             x_session(counterSession,:) =   x_all(ii,:);
             y_session(counterSession,:) =   y_all(ii,:);
             z_session(counterSession,:) =   z_all(ii,:);
             counterSession = counterSession +1; 
          end
      end
        
        

        
                    for i =1:5 %Loop through the frames
                        %Break up the xyz direction
                        x_mean(i) = nanmean(cell2mat(x_session(:,i)));
                        x_std(i) = nanstd(cell2mat(x_session(:,i)))/sqrt(length(x_session(:,i))) ;

                        y_mean(i) = nanmean(cell2mat(y_session(:,i)));
                        y_std(i) = nanstd(cell2mat(y_session(:,i)))/sqrt(length(y_session(:,i)));

                        z_mean(i) = nanmean(cell2mat(z_session(:,i)));
                        z_std(i) = nanstd(cell2mat(z_session(:,i)))/sqrt(length(z_session(:,i)));
                    end
                   
                    
                    

                    figure (k)
                    subplot(1,3,1)
                    hold on
                    shadedErrorBar(1:5,x_mean,x_std,'r')   
                    xlim([1 5])
                    ylim([-.06 .06])                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             


                    subplot(1,3,2)
                    title(num2str(k))
                    hold on
                    shadedErrorBar(1:5,y_mean,y_std,'b')    
                     xlim([1 5])
                     ylim([0 .03])
                     
                    subplot(1,3,3)
                    hold on
                    shadedErrorBar(1:5,z_mean,z_std,'g')    
                    xlim([1 5])    
                    ylim([.5 .6])
                    
                    
                    
                    
                      %Store the data for statistics 
    if k == 2
       xAllEarlyMean(i_rat,:) = x_mean; 
       xAllEarlyVar(i_rat,:) = x_std;
       
         yAllEarlyMean(i_rat,:) = y_mean; 
       yAllEarlyVar(i_rat,:) = y_std;
       
         zAllEarlyMean(i_rat,:) = z_mean; 
       zAllEarlyVar(i_rat,:) = z_std;
    elseif k == 6
       xAllLateMean(i_rat,:) = x_mean; 
       xAllLateVar(i_rat,:) = x_std;
       
          yAllLateMean(i_rat,:) = y_mean; 
       yAllLateVar(i_rat,:) = y_std;
       
         zAllLateMean(i_rat,:) = z_mean; 
       zAllLateVar(i_rat,:) = z_std;
        
    end
   
    end
    
  
    
    
end



xAllEarlyVarMean = mean(xAllEarlyVar);
yAllEarlyVarMean = mean(yAllEarlyVar);
zAllEarlyVarMean = mean(zAllEarlyVar);

xAllEarlyVarStd = std(xAllEarlyVar)/sqrt(5);
yAllEarlyVarStd = std(yAllEarlyVar)/sqrt(5);
zAllEarlyVarStd = std(zAllEarlyVar)/sqrt(5);


xAllLateVarMean = mean(xAllLateVar);
yAllLateVarMean = mean(yAllLateVar);
zAllLateVarMean = mean(zAllLateVar);



xAllLateVarStd = std(xAllLateVar)/sqrt(5);
yAllLateVarStd = std(yAllLateVar)/sqrt(5);
zAllLateVarStd = std(zAllLateVar)/sqrt(5);

figure
title('X variance early vs. late')

    hold on 
    
    
    errorbar(1:5,xAllEarlyVarMean,xAllEarlyVarStd,'r')
    errorbar(1:5,xAllLateVarMean,xAllLateVarStd,'b')
    



figure
title('Y variance early vs. late')

    hold on 
    
    
    errorbar(1:5,yAllEarlyVarMean,yAllEarlyVarStd,'r')
   errorbar(1:5,yAllLateVarMean,yAllLateVarStd,'b')



figure
title('Z variance early vs. late')

    hold on 
    
    
   errorbar(1:5,zAllEarlyVarMean,zAllEarlyVarStd,'r')
   errorbar(1:5,zAllLateVarMean,zAllLateVarStd,'b')
    
