function [idx_y, idx_x] = ARCSplus_N(Q, P, noise_bound)  
    y = vecnorm(Q);    x = vecnorm(P);
    
    [~,m] = size(y); [~,n] = size(x);
    
    [y_sorted, sidx_y] = sort(y); [x_sorted, sidx_x] = sort(x);

    
    i = 1; j = 1;
    idx_y = [];
    idx_x = [];
    errors = [];
    
    while i <= m && j <= n
        d = y(sidx_y(i)) - x(sidx_x(j));
        if d > noise_bound
            j = j + 1;
        elseif d < -noise_bound
            i = i + 1;
        else % |x(j)-y(i)| < threshold               
            if d < 0 % y(i) < x(j)                
                z = x(sidx_x(j)) + noise_bound;
                i0 = i;
                while i0 <= m && y(sidx_y(i0)) < z                   
                        idx_y(end+1) = sidx_y(i0);
                        idx_x(end+1) = sidx_x(j);
                        errors(end+1) = abs(y(sidx_y(i0))-x(sidx_x(j)));
                    i0 = i0 + 1;
                end
                j = j + 1;
            else % y(i) > x(j)                
                z = y(sidx_y(i)) + noise_bound;
                j0 = j;
                while j0 <= n && x(sidx_x(j0)) < z
                        idx_y(end+1) = sidx_y(i);
                        idx_x(end+1) = sidx_x(j0);
                    j0 = j0 + 1;
                end
                i = i + 1;
            end
        end       
    end
end


