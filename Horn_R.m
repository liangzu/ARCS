function [R_hat, cost] = Horn_R(Q, P)
% "Closed-form solution of absolute orientation using orthonormal matrices"

% Q = R*P
% P: 3xL 
% Q: 3xL
M = Q*P';

[U, S, V] = svd(M);

D = diag([1,1, det(U)*det(V)]);

R_hat = U*D*V';
residual = vecnorm(Q-R_hat*P);
cost = sum(residual);

end