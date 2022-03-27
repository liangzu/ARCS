function [num_stabbed, stabber] = interval_stabbing(Intervals)
    % Intervals: 2xL
    [~, L] = size(Intervals);
    
    Intervalss = reshape(Intervals,[2*L,1]);
    masks = repmat([0;1], L, 1);
    

    [~, sidx] = sort(Intervalss);
    length_sidx = 2*L;
    
    count = 0; num_stabbed = 0; stabber = 0;
    for i = 1:length_sidx
        if masks(sidx(i)) == 0            
            count = count + 1;
            if count > num_stabbed                
               % if masks(sidx(i+1)) == 1                    
                    num_stabbed = count;
                    stabber = Intervalss(sidx(i))+1e-12;                
                    % stabbing_point = (Intervalss(sidx(i)) + Intervalss(sidx(i+1)))/2;      
             %   end
            end
        else
            count = count - 1;
        end       
    end
%     
%     flag = 1;
%     for i=1:length_sidx
%         if masks(sidx(i)) == 0            
%             count = count + 1;
%             if count >= num_stabbed
%                 if flag == 1
%                     stabbers = Intervalss(sidx(i))+1e-12;                  
%                 else
%                     stabbers(end+1) = Intervalss(sidx(i))+1e-12;                  
%                 end
%             end
%         else
%             count = count -1;
%         end
%     end
end

