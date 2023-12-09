function [input, output, timecpu] = calHybrid(uini, yini_noi, Up, Yp_noi, Uf, Yf_noi, Q, R, ry, ru, ...
                        lambda_1, lambda_2, lambda_y, u_limit)

udim = size(uini, 1);
umin = u_limit(1);
umax = u_limit(2);
ydim = size(yini_noi, 1);
Tini = size(uini, 2);
N = size(Uf, 1) / udim;
input = zeros(udim*N, 1);
numTraj = size(Uf, 2);
uini_col = reshape(uini,[udim*Tini,1]);
yini_col_noi = reshape(yini_noi,[ydim*Tini,1]);
Q_blk    = zeros(ydim*N);
R_blk    = zeros(udim*N); 
for i = 1:N
    Q_blk((i-1)*ydim+1:i*ydim,(i-1)*ydim+1:i*ydim) = Q; 
    R_blk((i-1)*udim+1:i*udim,(i-1)*udim+1:i*udim) = R; 
end

yalmip('clear')
ops = sdpsettings('solver','mosek','verbose',0,'debug',0);
g = sdpvar(numTraj, 1);
u = sdpvar(udim*N, 1);
y = sdpvar(ydim*N, 1);
sigma_y = sdpvar(ydim*Tini, 1);


Constraints = [[Up; Yp_noi; Uf; Yf_noi]*g == [uini_col; yini_col_noi+sigma_y; u; y], umin<= u <= umax];
yr = repmat(ry, N, 1);
ur = repmat(ru, N, 1);

H = [Up; Yp_noi;Uf];
proj = pinv(H)*H;
I_g = eye(size(proj, 1));
Objective = (y - yr)' * Q_blk * (y - yr) + (u - ur)' * R_blk * (u - ur)+...
             lambda_1 * norm(g, 1) + lambda_2 * norm((I_g-proj)*g, 2) + lambda_y * sigma_y' * sigma_y;

timestart = tic; 
sol = optimize(Constraints,Objective, ops);
timecpu = toc(timestart); 
% Analyze error flags
if sol.problem == 0
 % Extract and display value
 input = value(u);
 output = value(y);
else
 display('Hmm, something went wrong!');
 sol.info
 yalmiperror(sol.problem)
end

end