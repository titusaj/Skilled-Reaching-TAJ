%Titus John
%4/6/2016
%Leventhal Lab, University of Michigan
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%script_tattorPawTrack20160405
%Testing to track the overall tatto paw

%Algorithim outline
%1.) Identify the paw in the direct prespective

%2.) Input the sr_calibration created from using the grid callibration
%methodlogy

% criteria we can use to identify the paw:
%   1 - the paw is moving
%   2 - dorsum of the paw is (mostly) green
%   3 - palmar aspect is (mostly) pink
%   4 - it's different from the background image  

% REACHING SCORES:
% 0 - no pellet presented or other mechanical failure
% 1 - first trial success (obtained pellet on initial limb advance)
% 2 - success (obtained pellet, but not on first attempt)
% 3 - forelimb advanced, pellet was grasped then dropped in the box
% 4 - forelimb advanced, but the pellet was knocked off the shelf
% 5 - pellet was obtained with its tongue
% 6 - the rat approached the slot but retreated without advancing its forelimb
% 7 - the rat reached, but the pellet remained on the shelf
% 8 - the rat used its contralateral paw.


validScores = [1,2,3,4,7];    % scores for which there was a reach
%% Threshold limits
numBGframes = 20;
gray_paw_limits = [60 125] / 255;
foregroundThresh = 25/255;

pawHSVrange = [1 .1 .5 1.5 .98 1.5];
           
 %% Load inherent paramaters of the box and the rat being analyzed
 
 %% Get the trigger time, find initial paw mask and the triangulate the points of intrest
 
                    triggerTime = identifyTriggerTime_greenPaw(video, BGimg_ud, sr_ratInfo(i_rat), session_mp, cameraParams,...
                                                       'pawgraylevels',gray_paw_limits,...
                                                       'hsvlimits',pawHSVrange);
                    track_metadata.triggerTime = triggerTime;
                    track_metadata.boxCalibration = boxCalibration;
                    initPawMask = find_initPawMask_tattooPaw( video, BGimg_ud, sr_ratInfo, session_mp, boxCalibration, boxRegions,triggerTime,'hsvlimits', pawHSVrange,'foregroundthresh',foregroundThresh);
                    
                    [mirror_points2d,~,isPawVisible_mirror] = trackMirrorView(video, triggerTime, initPawMask, BGimg_ud, sr_ratInfo, boxRegions,boxCalibration,...
                        'hsvlimits', pawHSVrange,...
                        'foregroundthresh',foregroundThresh);
 
                     [points3d,points2d,timeList,isPawVisible] = trackDirectView(video, triggerTime, initPawMask, mirror_points2d, BGimg_ud, sr_ratInfo, boxRegions,boxCalibration,...
                    'hsvlimits', pawHSVrange,...
                    'foregroundthresh',foregroundThresh);
 