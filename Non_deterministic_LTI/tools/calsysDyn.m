function [x_next, y, y_noise] = calsysDyn(x, u)
persistent flag A B C D
%==========================================================================
%Simulate the system dynamics
%==========================================================================
if isempty(flag)
    load system_True.mat sysTrue
    A = sysTrue.A;
    B = sysTrue.B;
    C = sysTrue.C;
    D = sysTrue.D;
    flag = 1;
end
xdim = size(A, 1);
ydim = size(C, 1);
x_next = zeros(xdim, 1);
x_next = A * x + B * u;
y = C * x+ D * u;
sigma = 0.01;
w_mean = zeros(ydim, 1);
w_var = sigma * eye(ydim);
w = mvnrnd(w_mean,w_var,1);
y_noise = y + w';
end