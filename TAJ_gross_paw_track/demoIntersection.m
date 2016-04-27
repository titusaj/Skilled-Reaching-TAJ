clc;    % Clear the command window.
workspace;  % Make sure the workspace panel is showing.
format longg;
format compact;
fontSize = 20;
% Check that user has the Image Processing Toolbox installed.
hasIPT = license('test', 'image_toolbox');
if ~hasIPT
	% User does not have the toolbox installed.
	message = sprintf('Sorry, but you do not seem to have the Image Processing Toolbox.\nDo you want to try to continue anyway?');
	reply = questdlg(message, 'Toolbox missing', 'Yes', 'No', 'Yes');
	if strcmpi(reply, 'No')
		% User said No, so exit.
		return;
	end
end


grayImage = uint8(mat2gray(peaks(400)));
% Get the dimensions of the image.  
% numberOfColorBands should be = 1.
[rows columns numberOfColorBands] = size(grayImage);
% Display the original gray scale image.
subplot(2, 1, 1);
imshow(grayImage, []);
axis on;
title('Original Grayscale Image', 'FontSize', fontSize);
% Enlarge figure to full screen.
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
% Give a name to the title bar.
set(gcf,'name','Demo by ImageAnalyst','numbertitle','off') 
% Initialize
button = 1;
while button ~= 2
	% Get which action the user wants to do.
	button = menu('Choose an action', 'Find Intersection', 'Exit');
	if button == 2
		% Bail out because they clicked Exit.
		break;
	end
	% Make caption the instructions.
	subplot(2, 1, 1);
	cla reset;
	imshow(grayImage, []);
	axis on;
	title('Left-click first point.  Right click last point.', 'FontSize', fontSize);
	% Ask user to plot a line.
	[x, y, profile] = improfile();
	% Plot line.
	hold on;
	plot(x, y, 'r-', 'LineWidth', 2);
	% Restore caption.
	title('Binary Image', 'FontSize', fontSize);
	% Calculate distance
	distanceInPixels = sqrt((x(1)-x(end))^2 + (y(1)-y(end))^2);
	% Plot it.
	subplot(2,1,2);
	plot(profile, 'LineWidth', 2);
	grid on;
	
	% Initialize
	caption = sprintf('Intensity Profile Along Line\nThe distance = %f pixels', ...
		distanceInPixels);
	title(caption, 'FontSize', fontSize);
	ylabel('Gray Level', 'FontSize', fontSize);
	xlabel('Pixels Along Line', 'FontSize', fontSize);
	ylim([0 1.5]);
	
	% Find intersection points.
	dif = diff(profile);
	
	% Find where it goes from 0 to 1, and dif == 1;
	nonZeroElements = find(dif > 0);
	% Plot them
	subplot(2, 1, 1); % Go back to the image.
	hold on;
	plot(x(nonZeroElements), y(nonZeroElements),...
		'ro', 'MarkerSize', 10);
	% Find where it goes from 1 to 0, and dif == -1;
	nonZeroElements2 = find(dif < 0);
	% Plot them
	subplot(2, 1, 1); % Go back to the image.
	hold on;
	plot(x(nonZeroElements2), y(nonZeroElements2),...
		'ro', 'MarkerSize', 10);
end