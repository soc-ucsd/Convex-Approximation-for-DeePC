function Ynew = denoiseHankel(Y, U, r, ep, ydim)
m = size(U, 1);
n = size(U, 2);
W1 = Y;
W2 = 0;
proj = eye(n) - U'*inv(U*U')*U;
indicator = 0;
while (norm(W1-W2, 2) >= ep*norm(W1, 2) && indicator <= 1000)
    [U, S, V] = svd(W1*proj, "econ");
    W2 = U(:, 1:r) * S(1:r, 1:r) * V(:, 1:r)' + W1 * (eye(n)-proj);
    W1 = projHankelset(W2, ydim);
    indicator = indicator+1;
end
Ynew = W2;
end