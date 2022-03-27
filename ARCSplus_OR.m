function [R_hat] = ARCSplus_OR(Y, X, s, noise_bound)
% Y, X: 3xL
% ||Y(:,i) - R*X(:,i)||_2 \leq noise_bound

    [~, consensus, ~] = ARCSplus_O(Y, X, s, noise_bound);
    [R_hat, ~] = ARCSplus_R(Y(:,consensus), X(:,consensus));  
end