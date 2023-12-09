%==========================================================================
%Simulations for tesing different controllers
%==========================================================================
clear all
numExp = 100;
epsilonAll = [0:10]*0.1;
results = cell(numExp, 11);
h_wait = waitbar(0,'please wait');
for index_ep = 1:11
    for index_Exp = 1:numExp
        epsilon = epsilonAll(index_ep);
load(['data_100\trajectory_ep=',num2str(epsilon),'_i=',num2str(index_Exp),'.mat']);
sysdata = iddata(yd_noi',ud');
sysModel = n4sid(sysdata,4);
lambda_g1 = 30;
lambda_g2 = 30;
Tini = 4;
N = 60;
T = 600;
udim = 1;
xdim = 2;
ydim = 2;
Q = eye(ydim);
R = 0.5*eye(udim);
Q_blk    = zeros(ydim*N);
R_blk    = zeros(udim*N); 
for i = 1:N
    Q_blk((i-1)*ydim+1:i*ydim,(i-1)*ydim+1:i*ydim) = Q; 
    R_blk((i-1)*udim+1:i*udim,(i-1)*udim+1:i*udim) = R; 
end
ry = [0; 0];
ru = zeros(udim, 1);
lambda_y = 10000;
u_limit = [-20, 20];

Y = zeros(ydim, T);
Y_noi = zeros(ydim, T);
U = zeros(udim, T);
X = zeros(xdim, T);
uini = zeros(udim, Tini);
yini = zeros(ydim, Tini);
yini_noi = zeros(ydim, Tini);
x0 = [-20; -10];
u = zeros(1,1);

X(:,1) = x0;
for k = 1:Tini
    [X(:, k+1), Y(:, k)] = calsysDynNonLin(X(:, k), U(:, k), epsilon);
    Y_noi(:, k) = Y(:, k);
end
yini = Y(:, 1:Tini);
yini_noi = Y_noi(:, 1:Tini);
uini = U(:, 1:Tini);

uHybrid = calHybrid(uini, yini_noi, Up, Yp_noi, Uf, Yf_noi, Q, R, ry, ru, lambda_g1,...
                lambda_g2,lambda_y, u_limit);
uSVDAll = calSVD(uini, yini_noi, Up, Yp_noi, Uf, Yf_noi, Q, R, ry, ru, lambda_g1,...
                lambda_g2,lambda_y, u_limit);
uSVDDom = calSVDIter(uini, yini_noi, Up, Yp_noi, Uf, Yf_noi, Q, R, ry, ru, lambda_g1,...
                lambda_g2,lambda_y, u_limit);
uSPC = calDataSPC(uini, yini_noi, Up, Yp_noi, Uf, Yf_noi, Q, R, ry, ru, lambda_g1,...
                lambda_g2,lambda_y, u_limit);
uSysID = calControlSysID(uini, yini_noi, Tini, N, sysModel.A, sysModel.B, sysModel.C, sysModel.D,...
                         Q, R, ry, ru, u_limit);
u = cell(5, 1);
y = cell(5, 1);

u{1} = uHybrid;
u{2} = uSVDAll;
u{3} = uSVDDom;
u{4} = uSPC;
u{5} = uSysID;
if (uSysID == 'infeasible')
    u{5} = 100*ones(N, 1); %We will not use this result
end


for i = 1:5
    y{i} = zeros(N*ydim, 1);
    x_OL = X(:, Tini+1);
    for k = 1:N
        [x_OL, y{i}(ydim*(k-1)+1:ydim*k, 1)] = calsysDynNonLin(x_OL, ...
                                                 u{i}(udim*(k-1)+1:udim*k, 1), epsilon);
    end
end
cost_OL = zeros(5, 1);
yr = repmat(ry, N, 1);
for i = 1:5
    cost_OL(i) = u{i}' * R_blk * u{i} + (y{i}-yr)' * Q_blk * (y{i}-yr);
end
if uSysID == 'infeasible'
    cost_OL(5) = inf; %Use inf indicate the system ID is failed
end
results{index_Exp, index_ep} = cost_OL;
end
    str=['Processing...',num2str(index_ep/11*100),'%'];
    waitbar(index_ep/11,h_wait,str);
end

