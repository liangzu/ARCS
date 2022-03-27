clear; clear all; format longG
%% parameters
m = 10000;


k = 100;

sigma = 0.01; % noise
noise_bound = 5.54*sigma;

%% generate data 
 
angle = 2 * pi * rand;
axis = randn(3, 1);
axis = axis / norm(axis);
R_gt = rotation_from_axis_angle(axis, angle);

% k inliers
X_inliers = randn(3, k);
Y_inliers = R_gt*X_inliers + sigma*randn(3,k);

% m-k outliers for P1
X_outliers = randn(3, m-k);
% m-k outliers for P2
Y_outliers = randn(3, m-k);

X = [X_inliers X_outliers];
Y = [Y_inliers Y_outliers];

perm = randperm(m);
X = X(:, perm);
Y = Y(:, perm);


%% algorithm
tic;

[R_hat] = ARCSplus_OR(Y, X, 90, noise_bound);
toc;

getAngularError(R_gt, R_hat)


