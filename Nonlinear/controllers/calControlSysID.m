function [input, output] = calControlSysID(uini, yini_noi, Tini, N, A, B, C, D, Q, R,...
                                 ry, ru, ulimit)

ydim = size(yini_noi, 1);
udim = size(uini, 1);
umin = ulimit(1);
umax = ulimit(2);
Q_blk    = zeros(ydim*N);
R_blk    = zeros(udim*N); 
for i = 1:N
    Q_blk((i-1)*ydim+1:i*ydim,(i-1)*ydim+1:i*ydim) = Q; 
    R_blk((i-1)*udim+1:i*udim,(i-1)*udim+1:i*udim) = R; 
end
uini_col = reshape(uini,[udim*Tini,1]);
yini_col_noi = reshape(yini_noi,[ydim*Tini,1]);
mtemp = [D];
for i = 1:Tini-1
    mtemp = [mtemp; C*A^(i-1)*B];
end
tau = mtemp;
for i = 1:Tini-1
    mtemp2 = zeros(Tini*ydim, udim);
    mtemp2(i*ydim+1:end, :) = mtemp(1:ydim*(Tini-i), :); 
    tau = [tau, mtemp2];
end
Os = C;
for i = 1:Tini-1
    Os = [Os; C*A^i];
end
x0 = pinv(Os)*(yini_col_noi-tau*uini_col);
for i = 1:Tini
    x0 = A * x0 + B * uini(:,i);
end
xdim = size(x0, 1);

yalmip('clear')
ops = sdpsettings('solver','mosek','verbose',0,'debug',0);
u = sdpvar(udim*N, 1);
x = sdpvar(xdim*(N+1), 1);
y = sdpvar(ydim*N, 1);

Constraints = [];
x(1:xdim, 1) = x0;
for i = 1:N
    Constraints = [Constraints, y((i-1)*ydim+1:i*ydim, 1)==C*x((i-1)*xdim+1:i*xdim, 1),...
                   x(i*xdim+1:(i+1)*xdim, 1)==A*x((i-1)*xdim+1:i*xdim, 1)+B*u((i-1)*udim+1:i*udim, 1)];
end
Constraints = [Constraints, umin<= u <= umax];
yr = repmat(ry, N, 1);
ur = repmat(ru, N, 1);
Objective = (y - yr)' * Q_blk * (y - yr) + (u - ur)' * R_blk * (u - ur);
sol = optimize(Constraints,Objective, ops);

% Analyze error flags
if sol.problem == 0
 % Extract and display value
 input = value(u);
 output = value(y);
else
 display('Hmm, something went wrong!');
 sol.info
 yalmiperror(sol.problem)
 input = 'infeasible';
 output = 0;
end

end