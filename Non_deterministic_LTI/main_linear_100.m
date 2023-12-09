%==========================================================================
%Simulations for tesing different controllers
%==========================================================================
clear all
numExp = 100;
results = cell(numExp, 2);
for index_Exp = 1:numExp
load(['data_100\trajectory_i=',num2str(index_Exp)]);
% load(['data_100\trajectory_i=',num2str(20)]);
sysdata = iddata(yd_noi',ud',1);
sysModel = n4sid(sysdata,8);
fprintf('SystemID successful \n')
%Parameters
rng(1)
lambda_g1 = 30;
lambda_g2 = 30;
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
timecpu = zeros(5, 1);
[uGT, cost] = calControlGT(uini, yini, Up, Yp, Uf, Yf, Q, R, ry, ru, ...
                        lambda_g1, lambda_g2, lambda_y, u_limit);
[uHybrid, ~, timecpu(1)] = calHybrid(uini, yini_noi, Up, Yp_noi, Uf, Yf_noi, Q, R, ry, ru, lambda_g1,...
                lambda_g2,lambda_y, u_limit);
[uSVDAll, ~, timecpu(2)] = calSVD(uini, yini_noi, Up, Yp_noi, Uf, Yf_noi, Q, R, ry, ru, lambda_g1,...
                lambda_g2,lambda_y, u_limit);
[uMini, ~, timecpu(3)] = calMini(uini, yini_noi, Up, Yp_noi, Uf, Yf_noi, Q, R, ry, ru, lambda_g1,...
                lambda_g2,lambda_y, u_limit);
[uSVDDom, ~, timecpu(4)] = calSVDIter(uini, yini_noi, Up, Yp_noi, Uf, Yf_noi, Q, R, ry, ru, lambda_g1,...
                lambda_g2,lambda_y, u_limit);
[uDataSPC, ~, timecpu(5)] = calDataSPC(uini, yini_noi, Up, Yp_noi, Uf, Yf_noi, Q, R, ry, ru, lambda_g1,...
                lambda_g2,lambda_y, u_limit);
uSysID = calControlSysID(uini, yini_noi, Tini, N, sysModel.A, sysModel.B, sysModel.C, sysModel.D,...
                         Q, R, ry, ru, u_limit);

u = cell(7, 1);
y = cell(7, 1);

u{1} = uGT;
u{2} = uHybrid;
u{3} = uSVDAll;
u{4} = uMini;
u{5} = uDataSPC;
u{6} = uSVDDom;
u{7} = uSysID;

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
results{index_Exp, 1} = cost_OL;
results{index_Exp, 2} = timecpu;
end
