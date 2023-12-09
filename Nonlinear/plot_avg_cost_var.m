clear all
load('results_100Exp.mat')
label_size  = 18;
total_size  = 14;
numExp = 100;
epsilon = [0:10]*0.1;
costMethod = cell(4, 1);
for i = 1:4
    costTemp1 = zeros(numExp, 11);
    for j = 1:11
        for k = 1:numExp
            costTemp2 = results{k, j};
            costTemp1(k, j) = costTemp2(i);
        end
    end
    costMethod{i} = costTemp1;
end

data_cost = cell(11, 4);
for ii=1:size(data_cost, 1)
    Ac_solve{ii} = costMethod{1}(:, ii);%DeeP-Hybrid
    Bc_solve{ii} = costMethod{2}(:, ii);%DeePC-SVD
    Cc_solve{ii} = costMethod{4}(:, ii);%DDSPC
    Dc_solve{ii} = costMethod{3}(:, ii);%DeePC-Iter
end
data_cost=vertcat(Ac_solve,Bc_solve,Cc_solve,Dc_solve);

xlab={'0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0'};
col = [242, 80, 65,130;    
35, 24, 240,130;
51, 166, 166,130;
50, 54, 115,130]
col=col/255;
color1 = col(1,:);%DeePC-Hybrid
color2 = col(2,:);%DeePC-SVD
color3 = col(3,:);%DDSPC
color4 = col(4,:);%DeePC-Iter

figure(1)
multiple_boxplot(data_cost',xlab,{'A', 'B', 'C', 'D'},col')
hold on
scatter(1.25*(1:11), mean(costMethod{1}),100,[0, 0, 0],'Marker','+','LineWidth',0.8)
scatter(1.25*(1:11)+0.25, mean(costMethod{2}),100,[0, 0, 0],'Marker','+','LineWidth',0.8)
scatter(1.25*(1:11)+0.5, mean(costMethod{4}),100,[0, 0, 0],'Marker','+','LineWidth',0.8)
scatter(1.25*(1:11)+0.75, mean(costMethod{3}),100,[0, 0, 0],'Marker','+','LineWidth',0.8)
set(gca,'TickLabelInterpreter','latex','fontsize',total_size);
set(gcf,'Position',[250 550 800 400]);
fig = gcf;
fig.PaperPositionMode = 'auto';
xl = xlabel('$\epsilon$','fontsize',label_size,'Interpreter','latex','Color','k');
yl = ylabel('Realized control cost','fontsize',label_size,'Interpreter','latex','Color','k');
hLegend = legend({'$\mathtt{DeePC}$-$\mathtt{Iter}$', '$\mathtt{Data}$-$\mathtt{Driven}$-$\mathtt{SPC}$',...
          '$\mathtt{DeePC}$-$\mathtt{SVD}$', '$\mathtt{DeePC}$-$\mathtt{Hybrid}$',...
          'N/A','N/A','N/A','N/A','N/A','N/A','N/A','N/A','N/A','N/A',...
          'N/A','N/A','N/A','N/A','N/A','N/A','N/A','N/A','N/A','N/A',...
          'N/A','N/A','N/A','N/A','N/A','N/A','N/A','N/A','N/A','N/A',...
          'N/A','N/A','N/A','N/A','N/A','N/A','N/A','N/A','N/A','N/A','Mean'}, 'Interpreter','latex',...
          'fontSize', total_size);
hLegend.AutoUpdate = 'off';
hLegend.PlotChildren = hLegend.PlotChildren([4,3,2,1,45]);
hLegend.EdgeColor = 'none';



