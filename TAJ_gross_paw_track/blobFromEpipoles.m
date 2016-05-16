%Titus John
%Leventhal Lab, University of Michigan
%5/12/16
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%inputs


%outputs




function pawDirectMask = blobFromEpipoles(points,points_opp,y,y_opp,binaryImage,image_ud)

            x= 1:2040;
           %image befor it gets filterd
           %Get the profile of the image using the epipolar line
           profile  = improfile(binaryImage,points(:, [1,3]),points(:, [2,4]));
           %Find intersection points
           dif = diff(profile);
           % Find where it goes from 0 to 1, and dif == 1;
           nonZeroElements = find(dif > 0);
           % Find where it goes from 1 to 0, and dif == -1;
           nonZeroElements2 = find(dif < 0);
      
           
           
           
           %image befor it gets filterd
           profile_opp  = improfile(binaryImage,points_opp(:, [1,3]),points_opp(:, [2,4]));
           %Find intersection points
           dif_opp = diff(profile_opp);
           % Find where it goes from 0 to 1, and dif == 1;
            nonZeroElements_opp = find(dif_opp > 0);
            % Find where it goes from 1 to 0, and dif == -1;
            nonZeroElements2_opp = find(dif_opp < 0);
            
%             
%             
%              figure(7)
%              imshow(binaryImage)
%              hold on
%              plot(x,y,'r')
%              hold on
%              plot(x,y_opp,'b')
%              
             
             %Top tracking pulls of the 
             [boundingPoints] =trackTopView(image_ud)

             



             maskPoints = [];
             maskPointsCounter = 1;
             
             
             
             boundingPointDiffrence = abs(boundingPoints(2)- boundingPoints(1))
             
             
             if boundingPointDiffrence> 25
             
                     boundingX1Line = repmat(boundingPoints(1),1,2040);
                     boundingX2Line = repmat(boundingPoints(2),1,2040);

                     %Vertical Line
                     yBoundingLine = [1:2040];

                     %For points showing restriction area of the blob
                     P1 = InterX([boundingX1Line;yBoundingLine], [x;y] ); 
                     P2 = InterX([boundingX1Line;yBoundingLine], [x;y_opp]);
                     P3 = InterX([boundingX2Line;yBoundingLine], [x;y]);
                     P4 = InterX([boundingX2Line;yBoundingLine], [x;y_opp]);


                     maskPoints(:,1) = [P1(1),P2(1),P3(1),P4(1)];
                     maskPoints(:,2) = [P1(2),P2(2),P3(2),P4(2)];
             
             else
                     for i = 1:length(nonZeroElements)
                      hold on;
                      %scatter(x(nonZeroElements(i)),y(nonZeroElements2(i)),'r')
                      maskPoints(maskPointsCounter,1) = x(nonZeroElements(i)); 
                      maskPoints(maskPointsCounter,2) = y(nonZeroElements2(i));
                      maskPointsCounter = maskPointsCounter +1 ;
                     end

                     hold on 

                     for i = 1:length(nonZeroElements_opp)
                      hold on;
                      %scatter(x(nonZeroElements_opp(i)),y_opp(nonZeroElements2_opp(i)),'b')
                      maskPoints(maskPointsCounter,1) = x(nonZeroElements_opp(i)); 
                      maskPoints(maskPointsCounter,2) = y_opp(nonZeroElements2_opp(i));
                      maskPointsCounter = maskPointsCounter +1;
                     end
             end
             k = convhull(maskPoints(:,1),maskPoints(:,2));
             x = maskPoints(:,1);
             y = maskPoints(:,2);
             %This represent the new full mask
             pawDirectMask = poly2mask(x(k),y(k),1024,2040);
%            imshow(pawDirectMask)
%            hold on
%            scatter(maskPoints(:,1),maskPoints(:,2),'r')
            
          


end