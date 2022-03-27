function [R_subopt, consensus, num_consensus] = ARCSplus_O(Y, X, s, noise_bound)
% Y, X: 3xL
% ||Y(:,i) - R*X(:,i)||_2 \leq noise_bound    
    Z = Y - X;  
    idx = Z(2,:) < 0;
    Z(:,idx) = -Z(:,idx);
    
    a = linspace(0, pi, s+1);
    
    phis = (a(1:s) + a(2:s+1)) / 2;
    
    consensus = 0; num_consensus = -1;    
    
    for i=1:s               
        phi = phis(i);
        
        [theta, stabbed2_idx, ~] = theta_from_phi(Z, phi, noise_bound);        
        
        s_theta = sin(theta); 
        b = [s_theta*cos(phi); s_theta*sin(phi); cos(theta)];

        [omega, stabbed3_idx, num_stabbed3] = omega_from_b(Y(:,stabbed2_idx), X(:,stabbed2_idx), b, noise_bound);  
        stabbed3_idx = stabbed2_idx(stabbed3_idx);         
        
        if num_stabbed3 > num_consensus
            num_consensus = num_stabbed3;
            consensus = stabbed3_idx;
            R_subopt = rotation_from_axis_angle(b, omega);
        end                
    end            
end