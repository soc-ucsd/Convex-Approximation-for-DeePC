function [x_next, y] = calsysDynNonLin(x, u, epsilon)
% ==========================================================================
% Simulate the system dynamics
% ==========================================================================

%Non-linear System
%System parameters
delta_t = 0.1;
a = 0.5;
c = 0.5;
b = 0.025;
d = 0.005;
x1eq = c/d;
x2eq = a/b;

% System Dynamics
x_next = zeros(2, 1);
xnonli1 = x(1)+delta_t*(a*(x(1)+x1eq)-b*(x(1)+x1eq)*(x(2)+x2eq));
xnonli2 = x(2)+delta_t*(d*(x(1)+x1eq)*(x(2)+x2eq)-c*(x(2)+x2eq)+u);
xlin1 = x(1)+delta_t*(-b*c/d*x(2));
xlin2 = x(2)+delta_t*(a*d/b*x(1)+u);
x_next(1) = epsilon*xlin1 + (1-epsilon)*xnonli1;
x_next(2) = epsilon*xlin2 + (1-epsilon)*xnonli2;
y = x;
end