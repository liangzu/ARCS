function [omega, stabbed_idx, num_stabbed] = omega_from_b(Y, X, b, noise_bound)
    [~, L] = size(Y);
    tags = 1:L;
    
    pi2 = 2*pi;

    %% compute quantities
    a9 = (b'*Y).*(b'*X);    
    a10 = sum(Y.*(skew(b)*X));
    a11 = sum(Y.*X)-a9; 
    
    denominator = sqrt(a10.^2 + a11.^2);
    
    a13 = acos(a11./denominator);
    idx = a10 < 0;
    a13(idx) = pi2 - a13(idx);
    
    % compute a14 and remove those points whose values of a14 is larger than 1
    a14 = max(((sum(Y.^2)+sum(X.^2) - noise_bound^2)/2 - a9) ./ denominator, -1);        
    idx = a14 <= 1;
    a15 = acos(a14(idx)); a13 = a13(idx); tags = tags(idx);

    %% construct intervals
    Intervals = [a13 - a15; a13 + a15]; % each interval is in [-pi, 3pi]
                                        % the length of each interval < 2pi
                             
    
    idx = Intervals(1,:) < 0;
    Intervals2 = [Intervals(1, idx)+pi2; pi2*ones(1, sum(idx))]; tags2 = tags(idx);
    Intervals(1,idx) = 0;

    idx = Intervals(2,:) > pi2;
    Intervals3 = [zeros(1, sum(idx)); Intervals(2, idx)-pi2]; tags3 = tags(idx);
    Intervals(2,idx) = pi2;
    
    Intervals = [Intervals Intervals2 Intervals3];
    tags = [tags tags2 tags3];
            

    %% stabbing
    [num_stabbed, omega] = interval_stabbing(Intervals);

    idx = (Intervals(1,:) <= omega & Intervals(2,:) >= omega);
    stabbed_idx = tags(idx);
end

