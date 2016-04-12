clc
clear all
close all



%gridDir = '/Volumes/RecordingsLeventhal04/SkilledReaching/R0000/R0000-rawdata/R0000_20160301d';
gridDir = 'Z:\SkilledReaching\R0114\R0114-rawdata\R0114_20160323b';
gridName = 'GridCalibration_20160323_3.png';

cparamDir = 'C:\Box Sync\Box Sync\Leventhal Lab\Skilled Reaching Project\SR_box_matched_points';
cparamName = 'cameraParameters.mat';
cparamName = fullfile(cparamDir,cparamName);
load(cparamName);

HSV_limits = zeros(3,6);
HSV_limits(1,:) = [0.33,0.1,0.8,1.0,0.8,1.0];   % green
HSV_limits(2,:) = [0.0,0.1,0.8,1.0,0.4,1.0];    % red
HSV_limits(3,:) = [0.6,0.1,0.7,1.0,0.8,1.0];   % blue


gridName = fullfile(gridDir,gridName);

grid_im = imread(gridName,'png');
grid_im_ud = undistortImage(grid_im,cameraParams);
dc_img = decorrstretch(grid_im_ud,'tol',[0,1]);
hsv_img = rgb2hsv(dc_img);

%imshow(hsv_img)

h = size(grid_im,1);
w = size(grid_im,2);

viewEdges = zeros(2,4,3);
viewEdges(1,:,1) = [400,1,1200,h-1];
viewEdges(2,:,1) = [1,1,400,h-1];

viewEdges(1,:,2) = [400,320,1200,h-321];
viewEdges(2,:,2) = [400,1,1200,320];

viewEdges(1,:,3) = [400,1,1200,h-1];
viewEdges(2,:,3) = [1200,1,w-1201,h-1];

% mask based on color
col_masks = false(size(hsv_img));
for iCol = 2
    col_masks(:,:,iCol) = HSVthreshold(hsv_img,HSV_limits(iCol,:));
    SE = strel('disk',2);
    col_masks(:,:,iCol) = imopen(col_masks(:,:,iCol),SE);
    col_masks(:,:,iCol) = imclose(col_masks(:,:,iCol),SE);
    border_mask(:,:,iCol) = col_masks(:,:,iCol) ;
    
    col_masks(:,:,iCol) = imfill(col_masks(:,:,iCol),'holes');
    
    % find the boxes for each color
    s = regionprops(col_masks(:,:,iCol),'area');
    lmat = bwlabel(col_masks(:,:,iCol));
    
    % pick out the two biggest regions to keep
    [~,idx] = sort([s.Area]);
    col_masks(:,:,iCol) = (lmat == idx(end) | lmat == idx(end-1));
end

% for iCol =1:3
%    figure(iCol)
%    imshow(col_masks(:,:,iCol))
%    
% end
    

masked_im = uint8(zeros(h,w,3,2,3));   % height by width by color channel by view by target color

for iCol = 2 %1 is green , 2 is red , 3 is blue
    for iView = 1:2 %1 is front view, 2 is side view
        
        regionMask = false(h,w);
        regionMask(viewEdges(iView,2,iCol):viewEdges(iView,2,iCol)+viewEdges(iView,4,iCol),...
                   viewEdges(iView,1,iCol):viewEdges(iView,1,iCol)+viewEdges(iView,3,iCol)) = true;
               
        tempMask = col_masks(:,:,iCol) & regionMask;
        masked_im(:,:,:,iView,iCol) = grid_im_ud .* uint8(repmat(tempMask(:,:,1),1,1,3));%.*uint8(repmat(imcomplement(border_mask(:,:,iCol)),1,1,3));
        masked_imBorder = grid_im_ud .* uint8(repmat(tempMask(:,:,1),1,1,3)).*uint8(repmat(imcomplement(border_mask(:,:,iCol)),1,1,3));
        imshow(masked_imBorder(:,:,iCol))
        %This function will take the border mask and subtract the border to
        %find internal points
        %masked_imGreen = grid_im_ud .* uint8(repmat(tempMask(:,:,1),1,1,3)).*unit8(repmat(imcomplement(border_mask(:,:,1)),1,1,3));
        
        %tempMask = col_masks(:,:,iCol) & regionMask; %apply mask for red
        %masked_imR = grid_im_ud .* uint8(repmat(tempMask,1,1,3));
        
        %tempMask = col_masks(:,:,3) & regionMask; %apply mask for blue
        %masked_imB = grid_im_ud .* uint8(repmat(tempMask(:,:,1),1,1,3)).*uint8(repmat(imcomplement(border_mask(:,:,iCol)),1,1,3));
      
        %find the checkerboard points
        currentMask = squeeze(masked_im(:,:,:,iView,iCol));
        currentMaskBorder = (masked_imBorder);
        
        [cb_pts,cb_size] = detectCheckerboardPoints(currentMask)
        [cb_pts_border,cb_size_border] = detectCheckerboardPoints(currentMaskBorder)
        
        %[cb_pts2,cb_size2] = detectCheckerboardPoints(masked_imGreen_2);
        
        %[cb_pts1,cb_size1] = detectCheckerboardPoints(masked_imR)
        %[cb_pts2,cb_size2] = detectCheckerboardPoints(masked_imR_2);
        
        %[cb_pts1,cb_size1] = detectCheckerboardPoints(masked_imB)
        %[cb_pts2,cb_size2] = detectCheckerboardPoints(masked_imB_2);
        
        
        %Clear cb_filtered points
        cb_pts_filtered = [];
        
        
        %Find the closest match points between the two checkborad mask 
        %take the checkerboard calibration that finds the most that find the most points

            if length(cb_pts) > length(cb_pts_border) || length(cb_pts) == length(cb_pts_border)
               k = dsearchn(cb_pts,cb_pts_border); 
               
               for ik = 1:length(k)
                    cb_pts_filtered(ik,:) = cb_pts(k(ik),:);
               end
               
            else
               k = dsearchn(cb_pts_border,cb_pts);
               for ik = 1:length(k)
                    cb_pts_filtered(ik,:) = cb_pts_border(k(ik),:);
               end
            end

            if iView == 1
               cb_pts_center = cb_pts_filtered;
            elseif iView == 2
               cb_pts_side = cb_pts_filtered;
            end

        
        %Sequence to find the corners of the box 
        binaryImage = im2bw(rgb2gray(masked_imBorder),.01);
        binaryImage = edge(binaryImage,'Roberts');
  %      corners = detectHarrisFeatures(binaryImage); 
   if iView ==2
        [xCorners, yCorners] = findCornerofMask(binaryImage);
    end
        
    if iView  == 1
        [xCorners, yCorners] = HoughLineFinder(binaryImage); 
   end
%         imshow(binaryImage)
%         hold on
%         scatter(xCorners,yCorners)
%         
        [borderCornersX,borderCornersY,cb_pts_x ,cb_pts_y] = correspondCheckboardPoints(cb_pts_filtered,xCorners,yCorners)
%         
        figure(iView) 
        imshow(binaryImage)
           hold on
        scatter(borderCornersX,borderCornersY,'r')
%         keyboard
%         scatter(cb_pts_x,cb_pts_y,'b')
%         keyboard
%         scatter(cb_pts_filtered(:,1),cb_pts_filtered(:,2),'g')
%         keyboard

        %overlay checkerboard points onto image
%         figure(iView)
%         imshow(currentMask);
%         hold on
%         plot(cb_pts_filtered(:,1),cb_pts_filtered(:,2),'marker','*','linestyle','none')
%         hold off
% %         
%         figure(iView+3)
%         imshow(currentMaskBorder);
%         hold on
%         plot(cb_pts_border(:,1),cb_pts_border(:,2),'marker','*','linestyle','none')
%         hold off
%         
        
        %plot(cb_pts(:,1),cb_pts(:,2),'marker','*','linestyle','none')
        
        %display combined grid and image  
        %imshow(masked_imR);
        %imshow(masked_imB);   
    end
end


%This function will take the checkerboard points found and the corrspond
%the pints 








