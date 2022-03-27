function [R_hat] = ARCS(Q, P)
% Q: 3xm
% P: 3xn
    [idx_y, idx_x] = matching_noiseless_R(Q, P);    
    R_hat = Horn_R(Q(:,idx_y), P(:,idx_x));        
end