clc;clear;
load('average_DoO_LR.mat');


No_video = 10;
No_user = 50;

DoO_performance_all_LR = DoO_performance_all_LR(1:26,:,:);

train_data_set = sum(DoO_performance_all_LR(:,:,:),3)/No_user;

coefficient_a_dim = 4;

coefficient_a_all_video = zeros(No_video,coefficient_a_dim);


MSE_all = zeros(No_video,1);

duration = 3:1:28;
duration_normalize = duration/30; % seconds



NLR_model = @(alpha,x)alpha(1) + alpha(2)*x + alpha(3)*x.^2 + alpha(4)*x.^3;

for video = 1:No_video
    
    Y = train_data_set(:,video)';
    init_a = rand(coefficient_a_dim,1);
    [alpha,R,J,CovB,MSE,ErrorModelInfo] = nlinfit(duration_normalize,Y,NLR_model,init_a);
    MSE_all(video) = MSE;
    coefficient_a_all_video(video,:) = alpha;
    
end

[~,choose_video_worst] = max(MSE_all);

[~,choose_video_best] = min(MSE_all);

clear figure
plot(duration_normalize,NLR_model(coefficient_a_all_video(choose_video_worst,:),duration_normalize),'-b*','MarkerSize',8,'LineWidth',2);hold on;
plot(duration_normalize,train_data_set(:,choose_video_worst)','^b','MarkerSize',8,'LineWidth',2,'Color',[0.4 0.4 0.9 ]);hold on;
plot(duration_normalize,NLR_model(coefficient_a_all_video(choose_video_best,:),duration_normalize),'-rp','MarkerSize',8,'LineWidth',2);hold on;
plot(duration_normalize,train_data_set(:,choose_video_best)','or','MarkerSize',8,'LineWidth',2,'Color',[0.8 0.4 0.1 ]);hold on;

set(gca,'xlim',[0.1,1],'xtick',[0.1:0.2:0.9 1],'xticklabel',{'0.1','0.3','0.5','0.7','0.9','1'});hold on;
set(gca,'ylim',[0.73,0.78],'ytick',0.73:0.01:0.78,'yticklabel',{'73%','74%','75%','76%','77%','78%'});hold on;
set(gca,'FontSize',20,'Fontname', 'Times New Roman');hold on;

xlabel('xtolatex');
xtolatex = xlabel('$t_{\mathrm{obw}}$(seconds)','Fontsize',20);
xtolatex.Interpreter = 'latex';

ylabel('ytolatex');
ytolatex = ylabel('$\mathcal{D}(t_{\mathrm{obw}})$','Fontsize',20);
ytolatex.Interpreter = 'latex';

ll = legend({'Video 10 fitting curve','Video 10 real data','Video 4 fitting curve','Video 4 real data'},'FontName','Times New Roman','Fontsize',20);grid on;
set(ll,'box','off');

save('fitting_performance_LR.mat','coefficient_a_all_video') ;

