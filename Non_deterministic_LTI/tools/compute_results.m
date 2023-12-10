load('results_100exp.mat')
numExp = 100;
costAll = zeros(7, numExp);
timeAll = zeros(5, numExp);
for i = 1:numExp
    costAll(:, i) = results{i, 1};
    timeAll(:, i) = results{i, 2};
end
sum(costAll')/100
sum(timeAll')/100