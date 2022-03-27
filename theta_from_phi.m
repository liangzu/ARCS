function [theta, stabbed_idx, num_stabbed] = theta_from_phi(Z, phi, noise_bound)
    % Z: 3xL
    [~,L] = size(Z);
    tags = 1:L;
  
    cosphi = cos(phi); sinphi = sin(phi);

    % without loss of generality assume a1>0
    a1 = Z(1,:) * cosphi + Z(2,:) * sinphi;
    idx = a1 < 0;
    a1(idx) = - a1(idx); Z(3,idx) = -Z(3,idx); % Z(1:2,idx) = -Z(1:2,idx);
   
    
    denominator = sqrt(a1.^2 + Z(3,:).^2);

    cos_a2 = Z(3,:) ./ denominator;

    a2 = acos(cos_a2);    

    ci = noise_bound ./ denominator;
    ci(ci > 1) = 1;    
    
    a3 = acos(-ci);   
    a4 = acos(ci); % a3 + a4 = pi
    

    %% contruct intervals
    Intervals = [a2 + a4; a2 + a3]; % [0,2pi]        
        
    idx = Intervals(1,:) >= pi;
    Intervals(:,idx) = Intervals(:,idx) - pi;

    idx = Intervals(2,:) > pi;
    Intervals_split = [zeros(1, sum(idx)); Intervals(2, idx)-pi];
    Intervals(2,idx) = pi;
    Intervals = [Intervals Intervals_split];
    tags = [tags tags(idx)];
        
    
    %% stabbing
    [num_stabbed, theta] = interval_stabbing(Intervals);
    stabbed_idx = tags(Intervals(1,:) <= theta & Intervals(2,:) >= theta); 
end