clear; clear all; format longG

%% parameters
n = 8000;  % the number of points in P
m = 10000; % the number of points in Q

k = 2;

sigma = 0; % noise

%% generate data 
tic;

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

toc;

%% algorithm
tic;
R_hat= ARCS(Q,P);
toc;

getAngularError(R_gt, R_hat)


