function [phi, estimated_inlier_idx] = phi_from_theta(X, theta, noise_bound)
% X: 3xL

    pi2 = 2*pi;
    
    idx = X(2,:) < 0; 
    X(:, idx) = -X(:, idx);

    cos_theta = cos(theta); sin_theta = sin(theta);

    [~ , L] = size(X);
    tags = 1:L;

    a = sqrt(X(1,:).^2 + X(2,:).^2);

    ci1 = (-noise_bound - X(3,:)*cos_theta)/sin_theta./a;
    ci2 = (noise_bound - X(3,:)*cos_theta)/sin_theta./a;
    
    idx = ci1 <= 1 & ci2 >= -1;
    
    X = X(:, idx); a = a(idx); tags = tags(idx); ci1 = ci1(idx); ci2 = ci2(idx);

    %% compute intervals
    ci1(ci1 < -1) = -1;
    ci2(ci2 > 1) = 1;

    acos_ci1 = acos(ci1); acos_ci2 = acos(ci2); 
    
    cosalpha = X(1,:) ./ a;
    alpha = acos(cosalpha);    
    
    Intervals1 = [alpha + acos_ci2; alpha + acos_ci1];
    
    Intervals2 = [alpha - acos_ci1; alpha - acos_ci2];        
    
    idx = Intervals2(2,:) < 0;
    Intervals2(:, idx) = Intervals2(:, idx) + pi2;
    
    idx = Intervals2(1,:) < 0;
    Intervals2_split = [Intervals2(1,idx) + pi2; pi2*ones(1, sum(idx))];
    tags2_split = tags(idx);
    
    Intervals2(1,idx) = 0;                             
        
    Intervals = [Intervals1 Intervals2 Intervals2_split];
    tags = [tags tags tags2_split];
            
    %% stabbing
    [num_stabbing, stabbing_point] = interval_stabbing(Intervals);

    idx = (Intervals(1,:) <= stabbing_point & Intervals(2,:) >= stabbing_point);
    estimated_inlier_idx = tags(idx);

    phi = stabbing_point;    
    
    b = [sin(theta)*cos(phi), sin(theta)*sin(phi), cos(theta)];        
    d = abs(b*X);       
    
    
    % [sum(d <= noise_bound) length(estimated_inlier_idx)]
    % estimated_inlier_idx
    assert(sum(d <= noise_bound) == length(estimated_inlier_idx));
end

function [I1, I2, tags2] = my_union(I1, I2, tags2)
    idx1 = I1(1,:) <= I2(1,:) & I2(2,:) <= I1(2,:);
    % I2 = I2(idx1); tags2 = tags2(idx1);
    
    idx2 = I1(1,:) <= I2(1,:) & I2(1,:) <= I1(2,:) & I1(2,:) < I2(2,:);                                                
    I1(2, idx2) = I2(2, idx2);
    % I2 = I2(~idx2); tags2 = tags2(~idx2);
    
    idx3 = I2(1,:) < I1(1,:) & I1(1,:) <= I2(2,:) & I2(2,:) <= I1(2,:);
    I1(1, idx3) = I2(1, idx3);
    % I2 = I2(~idx3); tags2 = tags2(~idx3);
    
    idx4 = I2(1,:) < I1(1,:) & I1(2,:) < I2(2,:);    
    I1(:, idx4) = I2(:, idx4);
    
    idx = (~idx1) & (~idx2) & (~idx3) & (~idx4);
    
    I2 = I2(:, idx); tags2 = tags2(idx);
end