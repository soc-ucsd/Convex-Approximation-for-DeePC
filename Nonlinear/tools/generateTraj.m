%==========================================================================
%Generate the trajectory
%==========================================================================
clear all
numExp = 100;
epsilonAll = [0:10]*0.1;
for i = 1:11
    for j = 1:numExp
epsilon = epsilonAll(i);
T = 300;
N = 60;
Tini = 4;
xdim = 2;
udim = 1;
ydim = 2;
ud = zeros(udim, T);
yd = zeros(ydim, T);
yd_noi = zeros(ydim, T);
x = [-5; -5];
for k = 1: T
    v = 2*rand(1)-1;
    u = 2*(sin(k)+sin(0.1*k))^2 + v;
    ud(:, k) = u;
    [x, y] = calsysDynNonLin(x, u, epsilon);
    yd(:, k) = y;
    yd_noi(:, k) = y;
end
U = hankel_matrix(ud, Tini+N);
Up = U(1:Tini*udim, :);
Uf = U((Tini*udim+1):end, :);

Y = hankel_matrix(yd, Tini+N);
Yp = Y(1:Tini*ydim, :);
Yf = Y((Tini*ydim+1):end, :);

Y_noi = hankel_matrix(yd_noi, Tini+N);
Yp_noi = Y_noi(1:Tini*ydim, :);
Yf_noi = Y_noi((Tini*ydim+1):end, :);
% save(['trajectory.mat'], 'ud', 'yd', 'yd_noi', 'Up', 'Uf', 'Yp', 'Yf', 'Yp_noi','Yf_noi')

save(['data_100\trajectory_ep=',num2str(epsilon),'_i=',num2str(j),'.mat'], 'ud', 'yd', 'yd_noi', 'Up', 'Uf', 'Yp', 'Yf', 'Yp_noi','Yf_noi');
    end
end