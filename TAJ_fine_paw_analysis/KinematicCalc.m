
%% Calculate the Jerk (aka the 4th derivative of the position vector
function [Velocity, Acceleration, Jerk] = KinematicCalc (averagedCentroidsDisp,i_rat)

if i_rat == 1
    ts = 1/150;
else
    ts = 1/300;  
end
    frames = 0:8:40;
    time = frames*ts;

    Velocity = [];
    Acceleration = [];
    Jerk = [];
    

        for j = 1:length(averagedCentroidsDisp(1,:))
            Velocity(1,j) = averagedCentroidsDisp(1,j)/ts ;%4 frames x by number of reaches 
        end

    for j = 1:length(Velocity(:,1))
        for i = 1:length(Velocity(1,:))-1%Number of colums remains constant
                Acceleration (j,i) = (Velocity(j,i+1)-Velocity(j,i))/ts  ;  
        end
    end
    
    TF = sum(size(Acceleration))
    
  if TF ==4 
     for j = 1:length(Acceleration(:,1))
        for i = 1:length(Acceleration(1,:))-1%Number of colums remains constant
                Jerk(j,i) = (Acceleration(j,i+1)-Acceleration(j,i))/ts;   
        end
     end
  end

end
