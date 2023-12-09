%==========================================================================
%Generate the trajectory
%==========================================================================
clear all
% for i = 1:100
T = 200;
N = 40;
Tini = 4;
xdim = 8;
udim = 2;
ydim = 3;
ud = zeros(udim, T);
yd = zeros(ydim, T);
yd_noi = zeros(ydim, T);
x = zeros(xdim, 1);
for k = 1: T
    u = 1.4 * rand(udim, 1) -0.7;
    ud(:, k) = u;
    [x, y, y_noi] = calsysDyn(x, u);
    yd(:, k) = y;
    yd_noi(:, k) = y_noi;
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

save(['trajectory'], 'ud', 'yd', 'yd_noi', 'Up', 'Uf', 'Yp', 'Yf', 'Yp_noi','Yf_noi');
% save(['data_100\trajectory_i=',num2str(i)], 'ud', 'yd', 'yd_noi', 'Up', 'Uf', 'Yp', 'Yf', 'Yp_noi','Yf_noi');
% end