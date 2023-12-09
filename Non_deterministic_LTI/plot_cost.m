clear all
load("results_C3.mat");
x = [10^-5, 10^-4, 10^-3, 10^-2, 10^-1, 1:2:20,25,50, 100:1000:10000];
y = [10^-5, 10^-4, 10^-3, 10^-2, 10^-1, 1,10,25, 50, 100:1000:10000];
[X,Y] = meshgrid(y,x);
indi_i = 0;
for i = [1:5,6:2:25, 30, 55,61:70]
    indi_i = indi_i +1;
    indi_j = 0;
    for j = [1:5,6, 15,30, 55,61:70]
        indi_j = indi_j +1;
    V1(indi_i,indi_j) = results{i,j}(1);
    V2(indi_i,indi_j) = results{i,j}(2);
    V3(indi_i,indi_j) = results{i,j}(3);
    V4(indi_i,indi_j) = results{i,j}(4);
    V5(indi_i,indi_j) = results{i,j}(5);
    V6(indi_i,indi_j) = results{i,j}(6);
    if (V1(indi_i,indi_j)>500)
        V1(indi_i,indi_j) = 500;
    end
    if (V2(indi_i,indi_j)>500)
        V2(indi_i,indi_j) = 500;
    end
    if (V3(indi_i,indi_j)>500)
        V3(indi_i,indi_j) = 500;
    end
    if (V4(indi_i,indi_j)>500)
        V4(indi_i,indi_j) = 500;
    end
    if (V5(indi_i,indi_j)>500)
        V5(indi_i,indi_j) = 500;
    end
    if (V6(indi_i,indi_j)>500)
        V6(indi_i,indi_j) = 500;
    end
    end
end

figure
surf(X,Y,V3,'FaceColor','#FF7A48');%SVD
hold on
%We lift the following three surface a little bit for clearification of the
%visualization
surf(X,Y,V2+1,'FaceColor','#E3371E'); %Hybrid
surf(X,Y,V5+1,'FaceColor', '#0593A2');
surf(X,Y,V6+1,'FaceColor','#103778');


set(gca,'XScale','log')
set(gca,'YScale','log')

name_line = {'$\mathtt{Hybrid}$','$\mathtt{SVD}$',...
    '$\mathtt{DeePC}$-$\mathtt{Mini}$', '$\mathtt{DDSPC}$',...
    '$$\mathtt{SVD}$-$\mathtt{Iter}$', 'System ID'};
hLegend = legend({name_line{2}, name_line{1},name_line{4},name_line{5}}, ...
                 'Interpreter','latex','FontSize', 15-3);
hLegend.AutoUpdate = 'off';
hLegend.PlotChildren = hLegend.PlotChildren([2,1,3,4]);
hLegend.EdgeColor = 'none';
xlabel('$\lambda_{2}$', 'FontWeight', 'bold','Interpreter','latex', 'FontSize', 15);
ylabel('$\lambda_{1}$', 'FontWeight', 'bold','Interpreter','latex', 'FontSize', 15);
zlabel('Realized control cost', 'FontWeight', 'bold','Interpreter','latex', 'FontSize', 15);

