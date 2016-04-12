
     fine3dDataFiles = dir('AllD*.mat'); %Looking for index
for i=1:length(fine3dDataFiles)/2
    
    allMergedPoints = [];
    
    oppView = load(fine3dDataFiles(i).name);
    actualView = load(fine3dDataFiles(i+6).name);
    
    for j = 1:length(actualView.all3dPoints(:,1))
     for k =1:5%length(actualView.all3dPoints(1,:))
        currentFrameActual = cell2mat(actualView.all3dPoints(j,k));
        currentFrameOpp = cell2mat(oppView.all3dPoints(j,k));
        
        
        
        if size(currentFrameActual) == [4,3]
            mergedPoints = currentFrameActual; 
            
        elseif isempty(currentFrameActual)  
            mergedPoints = currentFrameOpp; 
        else
            mergedPoints = vertcat(currentFrameActual,currentFrameOpp); 
        end
        
            allMergedPoints{j,k} = mergedPoints;
        end
    end
    
    %save as all 3d points
    all3dPoints = [];
    all3dPoints = allMergedPoints;
    
    
    filename = strcat('Merged',fine3dDataFiles(i+6).name);
    save(filename,'all3dPoints')
     
end