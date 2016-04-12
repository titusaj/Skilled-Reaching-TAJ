%Output is going to be the 3D coordinates of the pellet based on the mirro
%prespective



function [pelletPoints3d] = findPelletCoordsandTriangulate(ratID, mirrorSide, srCal, sessionDate,iSessionMatch,iSession) 

    pelletFile = strcat('Z:\SkilledReaching\',ratID,'\',ratID,'-rawdata\',ratID,'_',sessionDate,'a','\pelletCoords_',sessionDate,'.mat');
    load(pelletFile); 



     %Get the P1 and P2 from the Sr.Cal array
       P1 = eye(4,3);% P1 stays constants 4x3 matrix
       P2 = srCal.P(:,:,mirrorSide,iSessionMatch(iSession))
       F  = srCal.F(:,:,mirrorSide,iSessionMatch(iSession)) 
        
    %Pick of the mirror side and then create the side matched point
     if mirrorSide == 1

             x2 = cell2mat(allPelletCenterLeft); 
       
     else 
  
            x2 = cell2mat(allPelletCenterRight); 
      
     end
     
     %Pick of the mirror side and then create the direct matched point
     
     if size(allPelletCentersDirect) == [2,1]
          x1 = cell2mat(allPelletCentersDirect{1,1}); 
     else
         x1 = cell2mat(allPelletCentersDirect); 
     end
    [pelletPoints3d,reprojectedPoints,errors] = ConvertMarkedPointsToRealWorldUP(x1,x2,F,P1,P2)
   
    
    

end