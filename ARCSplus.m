function [R_hat] = ARCSplus(Q, P, noise_bound)
% Q: 3xm
% P: 3xn

    [inlier_idx_y, inlier_idx_x] = ARCSplus_N(Q, P, noise_bound);

    X = P(:, inlier_idx_x);
    Y = Q(:, inlier_idx_y);

    [R_hat] = ARCSplus_OR(Y, X, 90, noise_bound);
end