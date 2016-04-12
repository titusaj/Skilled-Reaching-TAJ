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

for i_rat =[1,3]%,4,6]%length(sr_ratInfo)                                    
    
    
    ratID = sr_ratInfo(i_rat).ID; 
       cd (strcat(pawMarkingData_directory,'\',ratID,'\FineTriangulationData')); %Change this to the index directory
    
    filename = strcat('allAveragedCentroids_',ratID);
    load(filename);

    for i = 1:2

        indicies =[1,5];

        successAveragedCentroids = allAveragedCentroids{indicies(i)};
        failAveragedCentroids = allAveragedCentroids{indicies(i)+1};

        for j = 1:length(failAveragedCentroids(1,:))
            X(1,:)= cell2mat(successAveragedCentroids(j));
            X(2,:)= cell2mat(failAveragedCentroids(j));
            %Y = nancov(X)
            seperationDistances(i,j) = pdist(X); 
            
        end
        
        
                meann = mean(seperationDistances(i,:));
                stdd = std(seperationDistances(i,:));
                I = bsxfun(@gt, abs(bsxfun(@minus, seperationDistances(i,:), meann)), 1.75*stdd)
                out = find(I);
                
                if out>0
                    seperationDistances(i,out) = NaN
                end
                
            if i == 1
               Day3Distances(ratCount,:) = seperationDistances(i,:);
%             elseif i == 2
%                Day5Distances(ratCount,:) = seperationDistances(i,:);
            else
               Day7Distances(ratCount,:) = seperationDistances(i,:);
            end
            
%            remove outliers
            
                
               
         
            hold on 
            figure(i_rat)
        %    subplot(3,1,i)
            title(ratID)
            plot(1:length(seperationDistances),seperationDistances(i,:))
            ylim([0, .025])

            legend('Early','Late')


    end

    ratCount = ratCount +1; 
end


figure
hold on

  
shadedErrorBar(1:5,mean(Day3Distances),std(Day3Distances)/sqrt(length(Day3Distances)),'r');
%shadedErrorBar(1:5,mean(Day5Distances),std(Day5Distances)/sqrt(length(Day5Distances)),'g');
shadedErrorBar(1:5,mean(Day7Distances),std(Day7Distances)/sqrt(length(Day7Distances)),'b');

  