function [idx_y, idx_x] = matching_noiseless_R(Q, P)  
% Q: 3xm
% P: 3xn    
    noise_bound = 1e-14;

    y = vecnorm(Q,2,1);    x = vecnorm(P,2,1);
    
    [~,m] = size(y); [~,n] = size(x);
    
    [~, sidx_y] = sort(y); [~, sidx_x] = sort(x);
    
    i = 1; j = 1;
    idx_y = zeros(2,1);
    idx_x = zeros(2,1);    
    k = 1;
    while i <= m && j <= n
        d = y(sidx_y(i)) - x(sidx_x(j));        
        if d > noise_bound
            j = j + 1;
        elseif d < -noise_bound
            i = i + 1;
        else % |x(j)-y(i)| < noise_bound
            if x(sidx_x(j)) < y(sidx_y(i))
                j = j + 1;
                while j <= n && x(sidx_x(j)) < y(sidx_y(i))
                    j = j + 1;
                end
                
                if j <= n
                    idx_y(k) = sidx_y(i);
                    if x(sidx_x(j)) - y(sidx_y(i)) <  y(sidx_y(i)) - x(sidx_x(j-1))
                        idx_x(k) = sidx_x(j);
                        j = j + 1;
                    else
                        idx_x(k) = sidx_x(j-1);
                    end
                    k = k + 1;
                    i = i + 1;
                else
                    break;
                end
                
            else % x(sidx_x(j)) > y(sidx_y(i))
                i = i + 1;
                while i <= m && x(sidx_x(j)) > y(sidx_y(i))
                    i = i + 1;
                end
                
                if i <= m
                    idx_x(k) = sidx_x(j);
                    if y(sidx_y(i)) - x(sidx_x(j)) < x(sidx_x(j)) - y(sidx_y(i-1))
                        idx_y(k) = sidx_y(i);
                        i = i + 1;
                    else
                        idx_y(k) = sidx_y(i-1);
                    end
                    k = k + 1;
                    j = j + 1;
                else
                    
                end
            end
            
            
%            idx_y(k) = sidx_y(i);
%            idx_x(k) = sidx_x(j);
%             
%            k = k + 1;
%            if k > 2
%                break;
%            end
%            i = i + 1;
%            j = j + 1;
        end    
    end
end


