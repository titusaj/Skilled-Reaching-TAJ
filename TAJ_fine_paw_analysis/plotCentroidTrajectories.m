function plotCentroidTrajectories(allCentroids,fig_num_all,score)%,day,fig_num_all,sucessRate,RatID,totalNumReaches)
    
    check = 0 ; %This is a check to stop plotting if NaN exisit     

    for i =1:length(allCentroids(:,1))
        
                    x = [];
                    y = [];
                    z = [];
                    
        check = 0;
        
        for j = 1:length(allCentroids(1,:))
             currentFrame = allCentroids{i,j};
              
             
             if size(currentFrame)> 0
                 TF = 0;
             else
                 TF = 1;
             end
             
             if TF == 0 && check == 0;
                   
                    
                    x(j) = currentFrame(:,1);
                    y(j) = currentFrame(:,2);
                    z(j) = currentFrame(:,3);
                    
             elseif TF == 1
                check =1; 
             end
             
             
        end
        
        hold on
        
        figure(fig_num_all)
           if score == 1 
            plot3(x,z,y,'r')
           elseif score ==7
            plot3(x,z,y,'b')
           end
           
%            xlim([-5 25]);
%            zlim([-2, 10]);
%            ylim([170, 190]);
%            
            xlabel('x');
            ylabel('z');
            zlabel('y');
%             titleString  = strcat('Rat:', num2str(RatID), ' Day:',num2str(day),' Sucess Rate:',num2str(sucessRate,2),' Total Reaches: ', num2str(totalNumReaches));
%             title(titleString)
        
        az = -160;
        el = 42;
        view(az, el);
        set(gca,'zdir','reverse');
    end
end