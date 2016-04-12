

results = ['R27'];

for j =1:length(results(:,1)) %Represesnts rat number 
   %currentRat = results(j,:)
    

   %Break up the 
   
   
    
    for i = 1:length(allAveragedEuclidDistSuccess)
        i
        if i == 1
            Day3Success(j,:) = cell2mat(allAveragedEuclidDistSuccess(1));
            Day3SuccessStd(j,:) = cell2mat(allAveragedEuclidDistSuccessStd(1));
            
            Day3Fail(j,:) = cell2mat(allAveragedEuclidDistFail(1));
            Day3FailStd(j,:) = cell2mat(allAveragedEuclidDistFailStd(1));
            
            
        elseif i == 2
            Day5Success(j,:) = cell2mat(allAveragedEuclidDistSuccess(2));
            Day5SuccessStd(j,:) = cell2mat(allAveragedEuclidDistSuccessStd(2));
            
            Day5Fail(j,:) = cell2mat(allAveragedEuclidDistFail(2));
            Day5FailStd(j,:) = cell2mat(allAveragedEuclidDistFailStd(2));
            
        elseif i == 3
            Day7Success(j,:) = cell2mat(allAveragedEuclidDistSuccess(3));
            Day7SuccessStd(j,:) = cell2mat(allAveragedEuclidDistSuccessStd(3));
            
            Day7Fail(j,:) = cell2mat(allAveragedEuclidDistFail(3));
            Day7FailStd(j,:) = cell2mat(allAveragedEuclidDistFailStd(3));
        end
    end
    
end
% 
% Day3Success = mean(Day3Success);
% Day3SuccessStd = mean(Day3SuccessStd);
% 
% Day3Fail = mean(Day3Fail);
% Day3FailStd = mean(Day3FailStd);
% 
% 
% Day5Success = mean(Day5Success);
% Day5SuccessStd = mean(Day5SuccessStd);
% 
% Day5Fail = mean(Day5Fail);
% Day5FailStd = mean(Day5FailStd);
% 
% 
% Day7Success = mean(Day7Success);
% Day7SuccessStd = mean(Day7SuccessStd);
% 
% Day7Fail = mean(Day7Fail);
% Day7FailStd = mean(Day7FailStd);
% 
% 
% frames=1:5;
% 
% figure(1)
% hold on
% title('Day 3')
% errorbar(frames, Day3Fail, Day3FailStd,'b')
% errorbar(frames, Day3Success, Day3SuccessStd,'r')
% xlabel('Frames')
% ylabel('mm')
% ylim([0 12])
% 
% figure(2)
% hold on
% title('Day 5')
% errorbar(frames, Day5Fail, Day5FailStd,'b')
% errorbar(frames, Day5Success, Day5SuccessStd,'r')
% xlabel('Frames')
% ylabel('mm')
% ylim([0 12])
% 
% 
% figure(3)
% hold on
% title('Day 7')
% errorbar(frames, Day7Fail, Day7FailStd,'b')
% errorbar(frames, Day7Success, Day7SuccessStd,'r')
% xlabel('Frames')
% ylabel('mm')
% ylim([0 12])
% 
% figure(4)
% hold on
% title('Successful Reaching')
% errorbar(frames, Day3Success, Day3SuccessStd,'r')
% errorbar(frames, Day5Success, Day5SuccessStd,'b')
% errorbar(frames, Day7Success, Day7SuccessStd,'g')
% 
% figure(5)
% hold on
% title('Failed Reaching')
% errorbar(frames, Day3Fail, Day3FailStd,'r')
% errorbar(frames, Day5Fail, Day5FailStd,'b')
% errorbar(frames, Day7Fail, Day7FailStd,'g')
% ylim([1.5 6])

