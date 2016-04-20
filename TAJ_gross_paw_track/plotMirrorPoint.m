function plotMirrorPoint(mirrorCentroid)


for j =1:length(mirrorCentroid)
    
    currentFrame = mirrorCentroid{j};
    if isempty(currentFrame) ~= 1
       x = currentFrame.Centroid(1);
       y = currentFrame.Centroid(2);  
       
       figure(1)
       hold on
       scatter(x,y,'r')
       
    end
end


end