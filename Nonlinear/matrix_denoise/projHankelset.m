%Curently only it only works for m < n
function X_Han = projHankelset(X, dim)
m = size(X, 1);
n = size(X, 2);
X_Han = zeros(m, n);
for i = 1:n
    if i <= m/dim
        sum = zeros(dim, 1);
        for j = 1:i
            sum = sum + X((j-1)*dim+1:j*dim, i+1-j);
        end
        mean = sum/i;
        for j = 1:i
            X_Han((j-1)*dim+1:j*dim, i+1-j) = mean;
        end
    else
        sum = zeros(dim, 1);
        for j = 1:m/dim
            sum = sum + X((j-1)*dim+1:j*dim, i+1-j);
        end
        mean = sum/(m/dim);
        for j = 1:m/dim
            X_Han((j-1)*dim+1:j*dim, i+1-j) = mean;
        end
    end
end

for i = 1:m/dim
    sum = 0;
    for j = 1:(m/dim-i+1)
        sum = sum + X((i+j-2)*dim+1:(i+j-1)*dim, n+1-j);
    end
    mean = sum/(m/dim-i+1);
    for j = 1:(m/dim-i+1)
        X_Han((i+j-2)*dim+1:(i+j-1)*dim, n+1-j) = mean;
    end
end
end