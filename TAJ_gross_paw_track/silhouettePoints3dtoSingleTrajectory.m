% Titus John
% Leventhal Lab, University of Michigan 
% 4/12/2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This will take in the 3d point produced from the Silhouette 3d
%reconstructions shot out by the track direct view mirror function and
%produce a single trajectory through averaging each centroid produced

%Input
%Points 3d of Silhouette


%Output
%Points 3d of trajectory contructred 


function [singleTrajectory] = silhouettePoints3dtoSingleTrajectory(Points3dSilhouette)
    for i =325:338
        currentSilhouette = (Points3dSilhouette{i});
        centroid = polygonCentroid3d(currentSilhouette(:,1),currentSilhouette(:,2),currentSilhouette(:,3));
        singleTrajectory{i} = centroid;
    end
end
