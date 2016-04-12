
for i=1:length(allRatallCentroids(1,:))
    currentFrame = allRatallCentroids(:,i);
    meanCurrentFrame = nanmean(cell2mat(currentFrame));
    
    for j = 1:length(currentFrame)
        if isempty(cell2mat(currentFrame(j)))
            i
            j
            normCurrentFrame(j) = {[]}; 
        else
            normCurrentFrame(j) = {cell2mat(currentFrame(j))./meanCurrentFrame};
        end
         
    end
        
    normAllRatallCentroids(:,i) = normCurrentFrame; 
end


plotCentroidTrajectories( normAllRatallCentroids,1,1)