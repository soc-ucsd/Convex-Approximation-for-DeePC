% load('result_eq_Hy_SVD_SPC.mat')
% load('result_eq_Hy_SVD.mat')
% load('result_eq_all.mat')
load("trajectory_Exp.mat")
N = 40;
ydim = 3;
udim = 2;
t = [1:40]*0.1;
yGT = y{1};
yGT = reshape(yGT, ydim, N);
uGT = u{1};
uGT = reshape(uGT, udim, N);
color_blue = [7, 72, 91]/255;
color_Orange = [244, 80, 31]/255;
label_size  = 21;%18
total_size  = 17;%14
line_width  = 2;
name_line = {'$\mathtt{DeePC}$-$\mathtt{Hybrid}$','$\mathtt{DeePC}$-$\mathtt{SVD}$',...
    '$\mathtt{DeePC}$-$\mathtt{Mini}$', '$\mathtt{Data}$-$\mathtt{Driven}$-$\mathtt{SPC}$',...
    '$\mathtt{DeePC}$-$\mathtt{SVD}$-$\mathtt{Iter}$', 'System ID'};

% Different Methods
for i = 1:6
    figure(i)
    ytraj = y{i+1};
    ytraj = reshape(ytraj, ydim, N);
    plot(t, ytraj(2,:),'Color',color_Orange,'linewidth',line_width-0.5)
    hold on
    plot(t, yGT(2,:),'Color',color_blue,'linewidth',line_width-0.5) 
    grid on;
    set(gca,'TickLabelInterpreter','latex','fontsize',total_size);
    set(gca,'XLim',[0,4]);
    set(gca,'YLim',[-3,6]);
    xl = xlabel('$t$ [$\mathrm{s}$]','fontsize',label_size,'Interpreter','latex','Color','k');
    if (i==1)
    yl = ylabel('disc 2 angle [$\mathrm{rad}$]','fontsize',label_size,'Interpreter','latex','Color','k');

    end
    hLegend = legend({name_line{i}, 'Ground Truth'}, ...
                 'Interpreter','latex','FontSize', label_size-3);
    hLegend.Position = [0.33,0.69,0.56,0.21];
    hLegend.EdgeColor = 'none';
    set(gcf,'Position',[100 100 420 350]);
end

% %Eq_All
% figure(1)
% utraj1 = u{5};
% utraj2 = u{6};
% utraj1 = reshape(utraj1, udim, N);
% utraj2 = reshape(utraj2, udim, N);
% plot(t, utraj1(1,:),'Color',[1,0,0, 0.6],'linewidth',6)
% hold on
% plot(t, utraj2(1,:),'Color',[0,0,1, 1],'linewidth',2)
% grid on;
% set(gca,'TickLabelInterpreter','latex','fontsize',total_size);
% set(gca,'XLim',[0.1,4]);
% set(gca,'YLim',[-2,2]);
% xl = xlabel('$t$ [$\mathrm{s}$]','fontsize',label_size,'Interpreter','latex','Color','k');
% yl = ylabel('Motor 1 angle [$\mathrm{rad}$]','fontsize',label_size,'Interpreter','latex','Color','k');
% 
% hLegend = legend({'$\mathtt{Hybrid}$,$\mathtt{SVD}$',...  
%                   '$\mathtt{DDSPC}$,$\mathtt{SVD}$-$\mathtt{Iter}$'}, ...
%                   'Interpreter','latex','FontSize', label_size-3);
% % hLegend.Position = [0.40 0.23 0.48 0.22];
% hLegend.EdgeColor = 'none';
% set(gcf,'Position',[250 550 600 400]);

%Eq_Hybrid_SVD
% figure(1)
% utraj1 = u{2};
% utraj2 = u{3};
% utraj1 = reshape(utraj1, udim, N);
% utraj2 = reshape(utraj2, udim, N);
% plot(t, utraj1(1,:),'Color',[1,0,0, 0.6],'linewidth',6)
% hold on
% plot(t, utraj2(1,:),'Color',[0,0,1, 1],'linewidth',2)
% grid on;
%     set(gca,'TickLabelInterpreter','latex','fontsize',total_size);
%     set(gca,'XLim',[0.1,4]);
%     set(gca,'YLim',[-2,2]);
%     xl = xlabel('$t$ [$\mathrm{s}$]','fontsize',label_size,'Interpreter','latex','Color','k');
%     yl = ylabel('Motor 1 angle [$\mathrm{rad}$]','fontsize',label_size,'Interpreter','latex','Color','k');
% 
%     hLegend = legend({'$\mathtt{Hybrid}$',...  
%                        '$\mathtt{SVD}$'}, ...
%                  'Interpreter','latex','FontSize', label_size-3);
%     % hLegend.Position = [0.40 0.23 0.48 0.22];
%     hLegend.EdgeColor = 'none';
% set(gcf,'Position',[250 550 600 400]);

% %Eq_SVD_SPC_Hybrid
% utraj1 = u{2};
% utraj2 = u{5};
% utraj1 = reshape(utraj1, udim, N);
% utraj2 = reshape(utraj2, udim, N);
% plot(t, utraj1(1,:),'Color',[1,0,0, 0.6],'linewidth',6)
% hold on
% plot(t, utraj2(1,:),'Color',[0,0,1, 1],'linewidth',2)
% grid on;
%     set(gca,'TickLabelInterpreter','latex','fontsize',total_size);
%     set(gca,'XLim',[0.1,4]);
%     set(gca,'YLim',[-2,2]);
%     xl = xlabel('$t$ [$\mathrm{s}$]','fontsize',label_size,'Interpreter','latex','Color','k');
%     yl = ylabel('Motor 1 angle [$\mathrm{rad}$]','fontsize',label_size,'Interpreter','latex','Color','k');
% 
%     hLegend = legend({'$\mathtt{Hybrid}$,$\mathtt{SVD}$',...  
%                        '$\mathtt{DDSPC}$'}, ...
%                  'Interpreter','latex','FontSize', label_size-3);
%     % hLegend.Position = [0.40 0.23 0.48 0.22];
%     hLegend.EdgeColor = 'none';
% set(gcf,'Position',[250 550 600 400]);