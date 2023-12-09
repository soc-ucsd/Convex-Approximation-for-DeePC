load('results_100Exp.mat')
numExp = 100;
epsilon = [0:10]*0.1;
costep = zeros(5, 11);
for i = 1:11
    costAll = zeros(5, numExp);
    costID = 0;
    indi = 0;
    for j = 1:numExp
        costAll(:, j) = results{j, i};
        if (~isnan(costAll(5, j))&&costAll(5,j) ~= inf) %Remove the case when system ID is failed
            indi = indi+1;
            costID(indi) = costAll(5, j);
        end
    end
    costTemp = sum(costAll')/numExp;
    costTemp = costTemp';
    costep(:, i) = [costTemp(1:4); sum(costID)/indi];
end
colorcol = [50, 54, 115;51, 166, 166;35, 24, 240;242, 80, 65];
costep = costep(1:5,:);
costep([3,4],:) = costep([4,3],:);
for i = 1:4
plot(epsilon, costep(i,:), 'Color',colorcol(i,:)/255,'linewidth', 2)
hold on
end
plot(epsilon, costep(5,:),'linewidth', 2)
label_size  = 18;
total_size  = 14;
line_width  = 2;
grid on;
set(gca,'TickLabelInterpreter','latex','fontsize',total_size);
set(gca,'xTick', epsilon);
xl = xlabel('$\epsilon$','fontsize',label_size,'Interpreter','latex','Color','k');
yl = ylabel('Realized control cost','fontsize',label_size,'Interpreter','latex','Color','k');
hLegend = legend({'$\mathtt{DeePC}$-$\mathtt{Hybrid}$','$\mathtt{DeePC}$-$\mathtt{SVD}$',...
    '$\mathtt{Data}$-$\mathtt{Driven}$-$\mathtt{SPC}$','$\mathtt{DeePC}$-$\mathtt{SVD}$-$\mathtt{Dom}$','System ID'}, ...
                 'Interpreter','latex','FontSize', label_size-3);
hLegend.EdgeColor = 'none';
set(gcf,'Position',[250 550 600 500]);