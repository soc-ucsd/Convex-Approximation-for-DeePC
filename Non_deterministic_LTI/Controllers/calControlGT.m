function [input, cost] = calControlGT(uini, yini, Up, Yp, Uf, Yf, Q, R, ry, ru, ...
                         lambda_g1, lambda_g2, lambda_y, u_limit)

udim = size(uini, 1);
ydim = size(yini, 1);
Tini = size(uini, 2);
N = size(Uf, 1) / udim;
input = zeros(udim*N, 1);
numTraj = size(Uf, 2);
uini_col = reshape(uini,[udim*Tini,1]);
yini_col = reshape(yini,[ydim*Tini,1]);
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


Constraints = [[Up; Yp; Uf; Yf]*g == [uini_col; yini_col; u; y], -0.7<= u <= 0.7];
yr = repmat(ry, N, 1);
ur = repmat(ru, N, 1);
Objective = (y - yr)' * Q_blk * (y - yr) + (u - ur)' * R_blk * (u - ur);

sol = optimize(Constraints,Objective, ops);

% Analyze error flags
if sol.problem == 0
 % Extract and display value
 input = value(u);
 output = value(y);
 cost = value(Objective);
else
 display('Hmm, something went wrong!');
 sol.info
 yalmiperror(sol.problem)
end

end