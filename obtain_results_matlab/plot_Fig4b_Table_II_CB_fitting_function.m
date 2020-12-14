%% This file is used to generate Fig4b and the values of Table II
%% The values of Table II can be found in the variable "coefficient_a_all_video" and "MSE_all".


clc;clear;
load('average_DoO_CB.mat');

No_video = 10;
No_user = 50;

train_data_set = sum(DoO_performance_all(:,:,:),3)/No_user;

coefficient_a_dim = 2;

coefficient_a_all_video = zeros(No_video,2);


MSE_all = zeros(No_video,1);

duration = 3:1:30;
duration_normalize = duration/30; % seconds


CB_model = @(alpha,x)alpha(2)*x + alpha(1);

for video = 1:No_video
    
    Y = train_data_set(:,video)';
    init_a = rand(2,1);
    [alpha,R,J,CovB,MSE,ErrorModelInfo] = nlinfit(duration_normalize,Y,CB_model,init_a);
    MSE_all(video) = MSE;
    coefficient_a_all_video(video,:) = alpha;
end

[~,choose_video_worst] = max(MSE_all);

[~,choose_video_best] = min(MSE_all);
clear figure
plot(duration_normalize,CB_model(coefficient_a_all_video(choose_video_worst,:),duration_normalize),'-b*','MarkerSize',8,'LineWidth',2);hold on;
plot(duration_normalize,train_data_set(:,choose_video_worst)','^','MarkerSize',8,'LineWidth',2);hold on;
plot(duration_normalize,CB_model(coefficient_a_all_video(choose_video_best,:),duration_normalize),'-rp','MarkerSize',8,'LineWidth',2);hold on;
plot(duration_normalize,train_data_set(:,choose_video_best)','o','MarkerSize',8,'LineWidth',2);hold on;
set(gca,'xlim',[0.1,1],'xtick',0.1:0.1:1,'xticklabel',{'0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1'});hold on;
set(gca,'ylim',[0.65,0.9],'ytick',0.65:0.05:0.9,'yticklabel',{'65%','70%','75%','80%','85%','90%'});hold on;
set(gca,'FontSize',20,'Fontname', 'Times New Roman');hold on;

xlabel('xtolatex');
xtolatex = xlabel('$t_{\mathrm{obw}}$(seconds)','Fontsize',20);
xtolatex.Interpreter = 'latex';

ylabel('ytolatex');
ytolatex = ylabel('$\mathcal{D}(t_{\mathrm{obw}})$','Fontsize',20);
ytolatex.Interpreter = 'latex';

ll = legend({'Maximal MSE fitting curve','Maximal MSE real data','Minimal MSE fitting curve','Minimal MSE real data'},'FontName','Times New Roman','Fontsize',20);grid on;
set(ll,'box','off');

save('fitting_performance_CB.mat', 'coefficient_a_all_video');
