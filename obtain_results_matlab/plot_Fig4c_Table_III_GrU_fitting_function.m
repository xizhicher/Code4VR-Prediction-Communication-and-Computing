%% This file is used to generate Fig4c and the values of Table III
%% The values of Table III can be found in the variable "coefficient_a_all_video" and "MSE_all".

clc;clear;

% The following performance of GRU predictor can be found in [1]
% [1]: C. Perfecto, et al, "Taming the Latency in Multi-User VR 360бу: A QoE-Aware Deep Learning-Aided Multicast Framework," IEEE Trans. Commun., 2020
% The results in [1] are obtained based on fixed T_obw = 1s 
% with varying prediction horizon T_p = 1/6 s, 1/3 s, 2/3 s, 1s. 

% The small prediction horizon indicates the more recent information can be
% used for prediction, which can be roughly equivalent the larger duration
% of observation window in our framework. 

% Thus, to transform the results into fixed proactive streaming time T_ps with varying
% t_obw, we set T_ps = 2 s, and t_obw = T_ps - T_p = 1 s, 1+1/3 s, 1+ 2/3 s, 1+ 5/6 s

t_obw = [1 1+1/3  1+ 2/3 1+ 25/30];
DoO = [0.63 0.64 0.70 0.74; ...
       0.61 0.64 0.65 0.68; ...
       0.36 0.44 0.48 0.53; ...
       0.58 0.63 0.71 0.76; ...
       0.65 0.68 0.71 0.71; ...
       0.58 0.63 0.65 0.69; ...
       0.66 0.67 0.73 0.83; ...
       0.53 0.56 0.65 0.69; ...
       0.57 0.65 0.66 0.68; ...
       0.50 0.63 0.69 0.70;];


No_video = 10;

train_data_set = DoO;

coefficient_a_dim = 3;

coefficient_a_all_video = zeros(No_video,coefficient_a_dim);


MSE_all = zeros(No_video,1);


GRU_model = @(alpha,x)alpha(3)*x.^2 + alpha(2)*x + alpha(1);

for video = 1:No_video
    
    Y = train_data_set(video,:);
    init_a = rand(coefficient_a_dim,1);
    [alpha,R,J,CovB,MSE,ErrorModelInfo] = nlinfit(t_obw,Y,GRU_model,init_a);
    MSE_all(video) = MSE;
    coefficient_a_all_video(video,:) = alpha;
    
end

[~,choose_video_worst] = max(MSE_all);

[~,choose_video_best] = min(MSE_all);
clear figure
plot(t_obw,GRU_model(coefficient_a_all_video(choose_video_worst,:),t_obw),'-b*','MarkerSize',8,'LineWidth',2);hold on;
plot(t_obw,train_data_set(choose_video_worst,:)','^','MarkerSize',8,'LineWidth',2);hold on;
plot(t_obw,GRU_model(coefficient_a_all_video(choose_video_best,:),t_obw),'-rp','MarkerSize',8,'LineWidth',2);hold on;
plot(t_obw,train_data_set(choose_video_best,:)','o','MarkerSize',8,'LineWidth',2);hold on;
set(gca,'xlim',[1,2],'xtick',1:0.1:2,'xticklabel',{'1','1.1','1.2','1.3','1.4','1.5','1.6','1.7','1.8','1.9','2'});hold on;
set(gca,'ylim',[0.5,0.9],'ytick',0.5:0.05:0.9,'yticklabel',{'50%','55%','60%','65%','70%','75%','80%','85%','90%'});hold on;
set(gca,'FontSize',20,'Fontname', 'Times New Roman');hold on;

xlabel('xtolatex');
xtolatex = xlabel('$t_{\mathrm{obw}}$(seconds)','Fontsize',22);
xtolatex.Interpreter = 'latex';

ylabel('ytolatex');
ytolatex = ylabel('$\mathcal{D}(t_{\mathrm{obw}})$','Fontsize',22);
ytolatex.Interpreter = 'latex';

ll = legend({'Maximal MSE fitting curve','Maximal MSE real data','Minimal MSE fitting curve','Minimal MSE real data'},'FontName','Times New Roman','Fontsize',22);grid on;
set(ll,'box','off');

save('fitting_performance_GRU.mat','coefficient_a_all_video') ;
