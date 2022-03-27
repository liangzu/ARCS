clear; clear all; format longG

%% parameters
m = 10000;
n = 8000;

k = 2000;


sigma = 0.01; % noise
noise_bound = 5.54*sigma;

%% generate data 
 
angle = 2 * pi * rand;
axis = randn(3, 1);
axis = axis / norm(axis);
R_gt = rotation_from_axis_angle(axis, angle);

% k inliers
noise = sigma*randn(3, k);
P_inliers = randn(3, k);
Q_inliers = R_gt*P_inliers + noise;    

% m1-k outliers for P1
P_outliers = randn(3,n-k);
% m2-k outliers for P2
Q_outliers = randn(3,m-k);

% permute P    
perm1 = randperm(n);
P = [P_inliers, P_outliers];
P = P(:,perm1);

% permute Q
perm2 = randperm(m);
Q = [Q_inliers, Q_outliers];
Q = Q(:,perm2);        


%% algorithm
tic;

[R_hat] = ARCSplus(Q, P, noise_bound);
toc;

getAngularError(R_gt, R_hat)