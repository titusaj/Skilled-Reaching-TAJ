function [points3d,points2d,timeList,isPawVisible] = trackDirectView( video, triggerTime, initPawMask, mirror_points2d, BGimg_ud, sr_ratInfo, boxRegions, boxCalibration,varargin )

video.CurrentTime = triggerTime;

targetMean = [0.5,0.2,0.5];
targetSigma = [0.2,0.2,0.2];

foregroundThresh = 25/255;

pawHSVrange = [1 .1 .5 1.5 .98 1.5];

maxDistPerFrame = 20;
whiteThresh = 0.8;

% blob parameters for mirror view
pawBlob = vision.BlobAnalysis;
pawBlob.AreaOutputPort = true;
pawBlob.CentroidOutputPort = true;
pawBlob.BoundingBoxOutputPort = true;
pawBlob.LabelMatrixOutputPort = true;
pawBlob.MinimumBlobArea = 100;
pawBlob.MaximumBlobArea = 4000;

for iarg = 1 : 2 : nargin - 8
    switch lower(varargin{iarg})
        case 'pawgraylevels',
            pawGrayLevels = varargin{iarg + 1};
        case 'pixelcountthreshold',
            pixCountThresh = varargin{iarg + 1};
        case 'foregroundthresh',
            foregroundThresh = varargin{iarg + 1};
        case 'maxdistperframe',
            maxDistPerFrame = varargin{iarg + 1};
        case 'hsvlimits',
            pawHSVrange = varargin{iarg + 1};
        case 'targetmean',
            targetMean = varargin{iarg + 1};
        case 'targetsigma',
            targetSigma = varargin{iarg + 1};
        case 'pawblob',
            pawBlob = varargin{iarg + 1};
        case 'whitethresh',
            whiteThresh = varargin{iarg + 1};
    end
end



if strcmpi(class(BGimg_ud),'uint8')
    BGimg_ud = double(BGimg_ud) / 255;
end

pawPref = lower(sr_ratInfo.pawPref);
if iscell(pawPref)
    pawPref = pawPref{1};
end

srCal = boxCalibration.srCal;

vidName = fullfile(video.Path, video.Name);
video = VideoReader(vidName);
video.CurrentTime = triggerTime;

orig_BGimg_ud = BGimg_ud;
BGimg_ud = color_adapthisteq(BGimg_ud);

greenBGmask = findGreenBG(BGimg_ud, boxRegions,targetMean(1,:),targetSigma(1,:),pawHSVrange(1,:));


% frontPanelWidth = panelWidthFromMask(boxRegions.frontPanelMask);
[fpoints2d, fpoints3d, timeList_f,isPawVisible_f] = trackPaw_direct_local( video, BGimg_ud, greenBGmask, initPawMask{1},mirror_points2d,pawBlob, boxRegions, pawPref, 'forward',boxCalibration,...
                                     'foregroundthresh',foregroundThresh,...
                                     'pawhsvrange',pawHSVrange,...
                                     'maxdistperframe',maxDistPerFrame,...
                                     'targetmean',targetMean,...
                                     'targetsigma',targetSigma,...
                                     'whitethresh',whiteThresh);
                                 
video.CurrentTime = triggerTime;

[rpoints2d, rpoints3d, timeList_b,isPawVisible_b] = trackPaw_direct_local( video, BGimg_ud, greenBGmask, initPawMask{1},mirror_points2d,pawBlob, boxRegions, pawPref, 'reverse',boxCalibration,...
                                     'foregroundthresh',foregroundThresh,...
                                     'pawhsvrange',pawHSVrange,...
                                     'maxdistperframe',maxDistPerFrame,...
                                     'targetmean',targetMean,...
                                     'targetsigma',targetSigma,...
                                     'whitethresh',whiteThresh);
                                 
   
points2d = rpoints2d;
points3d = rpoints3d;
trigFrame = round(triggerTime * video.FrameRate);
for iFrame = trigFrame : length(fpoints2d)
    points2d{iFrame} = fpoints2d{iFrame};
    points3d{iFrame} = fpoints3d{iFrame};
end

srCal = boxCalibration.srCal;
switch pawPref
    case 'left',
        fundMat = srCal.F(:,:,2);
        P2 = srCal.P(:,:,2);
    case 'right',
        fundMat = srCal.F(:,:,1);
        P2 = srCal.P(:,:,1);
end
cameraParams = boxCalibration.cameraParams;
K = cameraParams.IntrinsicMatrix;

matched_points = matchMirrorMaskPoints(initPawMask, fundMat);
points2d{trigFrame} = matched_points;
mp_norm = zeros(size(matched_points));
for iView = 1 : 2
    mp_norm(:,:,iView) = normalize_points(squeeze(matched_points(:,:,iView)), K);
end
[points3d{trigFrame},~,~] = triangulate_DL(mp_norm(:,:,1),mp_norm(:,:,2),eye(4,3),P2);
        
timeList = [timeList_b,timeList_f(2:end)];
isPawVisible = isPawVisible_b | isPawVisible_f;
end


