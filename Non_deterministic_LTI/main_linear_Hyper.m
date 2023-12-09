%==========================================================================
%Simulations for tesing different controllers
%==========================================================================
clear all
load('trajectory.mat');
load('sysModel.mat');
load('system_True.mat');
%Parameters
results = cell(70,70);
g1_All = [10^-5, 10^-4, 10^-3, 10^-2, 10^-1, 1:1:50,51:10:100, 100:1000:10000];
g2_All = [10^-5, 10^-4, 10^-3, 10^-2, 10^-1, 1:1:50,51:10:100, 100:1000:10000];
for index_i = 1:70
    for index_j = 1:70
rng(1)
lambda_g1 = g1_All(index_i);
lambda_g2 = g2_All(index_j);
Tini = 4;
N = 40;
T = 40;
udim = 2;
xdim = 8;
ydim = 3;
Q = eye(ydim);
R = 0.1*eye(udim);
Q_blk    = zeros(ydim*N);
R_blk    = zeros(udim*N); 
for i = 1:N
    Q_blk((i-1)*ydim+1:i*ydim,(i-1)*ydim+1:i*ydim) = Q; 
    R_blk((i-1)*udim+1:i*udim,(i-1)*udim+1:i*udim) = R; 
end
ry = zeros(ydim, 1);
ru = zeros(udim, 1);
lambda_y = 100;
u_limit = [-0.7, 0.7];

Y = zeros(ydim, T);
Y_noi = zeros(ydim, T);
U = rand(udim, T);
X = zeros(xdim, T);
uini = zeros(udim, Tini);
yini = zeros(ydim, Tini);
yini_noi = zeros(ydim, Tini);
x0 = zeros(xdim, 1);
u = zeros(2,1);
for k = 1:16
    u = -3.14159 * ones(udim, 1);
    x0 = calsysDyn(x0, u);
end
X(:,1) = x0;
for k = 1:Tini
    [X(:, k+1), Y(:, k), Y_noi(:, k)] = calsysDyn(X(:, k), U(:, k));
end
yini = Y(:, 1:Tini);
yini_noi = Y_noi(:, 1:Tini);
uini = U(:, 1:Tini);
[uGT, cost] = calControlGT(uini, yini, Up, Yp, Uf, Yf, Q, R, ry, ru, ...
                        lambda_g1, lambda_g2, lambda_y, u_limit);
uHybrid = calHybrid(uini, yini_noi, Up, Yp_noi, Uf, Yf_noi, Q, R, ry, ru, lambda_g1,...
                lambda_g2,lambda_y, u_limit);
uSVD = calSVD(uini, yini_noi, Up, Yp_noi, Uf, Yf_noi, Q, R, ry, ru, lambda_g1,...
                lambda_g2,lambda_y, u_limit);
uMini = calMini(uini, yini_noi, Up, Yp_noi, Uf, Yf_noi, Q, R, ry, ru, lambda_g1,...
                lambda_g2,lambda_y, u_limit);
uSVDIter = calSVDIter(uini, yini_noi, Up, Yp_noi, Uf, Yf_noi, Q, R, ry, ru, lambda_g1,...
                lambda_g2,lambda_y, u_limit);
uDataSPC = calDataSPC(uini, yini_noi, Up, Yp_noi, Uf, Yf_noi, Q, R, ry, ru, lambda_g1,...
                lambda_g2,lambda_y, u_limit);
uSysID = calControlSysID(uini, yini_noi, Tini, N, sysModel.A, sysModel.B, sysModel.C, sysModel.D,...
                         Q, R, ry, ru, u_limit);

u = cell(7, 1);
y = cell(7, 1);

u{1} = uGT;
u{2} = uHybrid;
u{3} = uSVD;
u{4} = uMini;
u{5} = uDataSPC;
u{6} = uSVDIter;
u{7} = uSysID;
% u{6} = uSPC4;

for i = 1:7
    y{i} = zeros(N*ydim, 1);
    x_OL = X(:, Tini+1);
    for k = 1:N
        [x_OL, y{i}(ydim*(k-1)+1:ydim*k, 1),~] = calsysDyn(x_OL, u{i}(udim*(k-1)+1:udim*k, 1));
    end
end
cost_OL = zeros(7, 1);
for i = 1:7
    cost_OL(i) = u{i}' * R_blk * u{i} + y{i}' * Q_blk * y{i};
end
if norm(cost-cost_OL(1)) > 0.01
    disp("Something is Wrong")
end
results{index_i, index_j} = cost_OL;
    end
end
