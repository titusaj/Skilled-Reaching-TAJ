%Titus John
%Leventhal Lab, University of Michigan
%2/29/2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
clc


pawMarkingData_directory = 'C:\Users\Administrator\Documents\Paw_Point_Marking_Data'; 
sr_ratInfo = get_sr_RatList_win();    
                                   
  
successFileCount = 1;
failFileCount = 1;
ratCount = 1;

for i_rat =[1,2,3,4]%length(sr_ratInfo)                                    
    
    
    ratID = sr_ratInfo(i_rat).ID; 
       cd (strcat(pawMarkingData_directory,'\',ratID,'\FineTriangulationData')); %Change this to the index directory
    
    filename = strcat('allAveragedCentroidsDisp_',ratID);
    load(filename);

    for i = 1:2

        indicies =[1,5];

        successAveragedCentroidsDisp = allAveragedCentroidsDisp{indicies(i)};
        failAveragedCentroidsDisp = allAveragedCentroidsDisp{indicies(i)+1};
        
        
        [successVelocity,successAcceleration, successJerk] = KinematicCalc (successAveragedCentroidsDisp,i_rat)
        [failVelocity, failAcceleration, failJerk] = KinematicCalc (failAveragedCentroidsDisp,i_rat)

           if i == 1
               Day3DispSuccess(ratCount,:) = successAveragedCentroidsDisp;
               Day3DispFail(ratCount,:) = failAveragedCentroidsDisp;
               
               Day3VelSuccess(ratCount,:) = successVelocity;
               Day3VelFail(ratCount,:) = failVelocity;
               
               
            else
               Day7DispSuccess(ratCount,:) = successAveragedCentroidsDisp;
               Day7DispFail(ratCount,:) = failAveragedCentroidsDisp;
               
               Day7VelSuccess(ratCount,:) = successVelocity;
               Day7VelFail(ratCount,:) = failVelocity;;
      
            end
        
       
       

    end
    

    ratCount = ratCount +1; 
    
    
   
end

    %Stats comparing the 4 rats data
    AllDispEarly = vertcat(Day3DispSuccess,Day3DispFail);
    AllDispLate = vertcat(Day7DispSuccess,Day7DispFail);
    
    
    AllDispSuccess = vertcat(Day3DispSuccess,Day7DispSuccess);
    AllDispFail = vertcat(Day3DispFail,Day7DispFail);
    
     [~,~,statsDispEarly] = anova2(AllDispEarly,4);
     [~,~,statsDispLate] = anova2(AllDispLate,4);
    
     [~,~,statsDispSuccess] = anova2(AllDispSuccess,4);
     [~,~,statsDispFail] = anova2(AllDispFail,4);
     
     
   %Cross correlation of the diffrent conditons
   [earlySuccess_earlyFail_r,earlySuccess_earlyFail_p] = corrcoef(Day3DispSuccess',Day3DispFail');
   [lateSuccess_lateFail_r,lateSuccess_lateFail_p] = corrcoef(Day7DispSuccess',Day7DispFail');
   
   
   [earlySuccess_lateSuccess_r,earlySuccess_lateSuccess_p] = corrcoef(Day3DispSuccess',Day7DispSuccess');
   [earlyFail_lateFail_r,earlyFail_lateFail_p] = corrcoef(Day3DispFail',Day7DispFail');
    
    %Plot the results of the correlations of the diffrent conditions
    figure(5)
    hold on
    plot(1:2,[earlySuccess_earlyFail_r(2),lateSuccess_lateFail_r(2)],'r')
    plot(1:2,[earlySuccess_lateSuccess_r(2), earlyFail_lateFail_r(2)],'b')
    
    figure(6)
    scatter(1:4,[earlySuccess_earlyFail_r(2),lateSuccess_lateFail_r(2),earlySuccess_lateSuccess_r(2), earlyFail_lateFail_r(2)])
   
   %Look at the variance in the displacemement
     
     Day3DispSuccessStd = var(Day3DispSuccess);
     Day3DispSuccess = mean(Day3DispSuccess);
    
     Day3DispFailStd = var(Day3DispFail);
     Day3DispFail = mean(Day3DispFail);
    
    Day7DispSuccessStd = var(Day7DispSuccess);
    Day7DispSuccess = mean(Day7DispSuccess);
    
    Day7DispFailStd = var(Day7DispFail);
    Day7DispFail = mean(Day7DispFail);
    
    
    
    
    %Stats comparing the two populations 
    [h_early,p_early] = ttest(Day3DispSuccess,Day3DispFail,'Alpha',.05)
    [h_late,p_late] = ttest(Day7DispSuccess,Day7DispFail,'Alpha',.05)
    
     [h_success,p_success] = ttest(Day3DispSuccess,Day7DispSuccess,'Alpha',.05)
    [h_fail,p_fail] = ttest(Day3DispFail,Day7DispFail,'Alpha',.05)
        
        figure(1)
        hold on
         
        errorbar(1:length(Day3DispSuccess),Day3DispSuccess,Day3DispSuccessStd,'r')
       errorbar(1:length(Day3DispFail), Day3DispFail,Day3DispFailStd,'b')
        
       errorbar(1:length(Day7DispSuccess),Day7DispSuccess,Day7DispSuccessStd,'-.r')
        errorbar(1:length(Day7DispFail), Day7DispFail,Day7DispFailStd,'-.b')
        
        legend('Success Early','Fail Early','Success Late','Fail Late')
        
        
        
     %This part is for the velocity     
     Day3VelSuccessStd = var(Day3VelSuccess);
     Day3VelSuccess = mean(Day3VelSuccess);
    
     Day3VelFailStd = var(Day3VelFail);
     Day3VelFail = mean(Day3VelFail);
    
    Day7VelSuccessStd = var(Day7VelSuccess);
    Day7VelSuccess = mean(Day7VelSuccess);
    
    Day7VelFailStd = var(Day7VelFail);
    Day7VelFail = mean(Day7VelFail);
    
        
        figure(2)
        hold on
         
       errorbar(1:length(Day3VelSuccess),Day3VelSuccess,Day3VelSuccessStd,'r')
       errorbar(1:length(Day3VelFail), Day3VelFail,Day3VelFailStd,'b')
        legend('Success Early','Fail Early')
       ylim([-30 30])
        
        
        figure(3)
        hold on
        errorbar(1:length(Day7VelSuccess),Day7VelSuccess,Day7VelSuccessStd,'-.r')
         errorbar(1:length(Day7VelFail), Day7VelFail,Day7VelFailStd,'-.b')
        legend('Success Late','Fail Late')
          ylim([-30 30])


% 
% figure(7)
% hold on
% 
%   
% shadedErrorBar(1:5,mean(Day3Distances),var(Day3Distances)/sqrt(length(Day3Distances)),'r');
% %shadedErrorBar(1:5,mean(Day5Distances),var(Day5Distances)/sqrt(length(Day5Distances)),'g');
% shadedErrorBar(1:5,mean(Day7Distances),var(Day7Distances)/sqrt(length(Day7Distances)),'b');

  