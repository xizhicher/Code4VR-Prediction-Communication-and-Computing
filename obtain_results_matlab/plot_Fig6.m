clc;clear;

No_video = 10;
T_cc_max = 0.2:0.05:50;
Number_T_cc = length(T_cc_max);

QoE = zeros(Number_T_cc,No_video);
QoE_1_2 = zeros(Number_T_cc,No_video);
QoE_2_1 = zeros(Number_T_cc,No_video);
QoE_1_1 = zeros(Number_T_cc,No_video);

recp_T = 1./T_cc_max;

tau = 0.1;

T_ps_set = [1 0.5];

%% CB predictor
load fitting_performance_CB.mat coefficient_a_all_video

for T_ps_index = 1: length(T_ps_set)
    T_ps = T_ps_set(T_ps_index);
    
    t_obw = max(T_ps - T_cc_max, tau)';
    t_cc = min(T_cc_max,T_ps - tau)';

    %% 1:1 duration
    t_obw_1_1 = 1/2*T_ps*ones(Number_T_cc,1);
    t_cc_1_1 = 1/2*T_ps*ones(Number_T_cc,1);

    %% 1:2 duration
    t_obw_1_2 = 1/3*T_ps*ones(Number_T_cc,1);
    t_cc_1_2 = 2/3*T_ps*ones(Number_T_cc,1);
    
    %% 2:1 duration
    t_obw_2_1 = 2/3*T_ps*ones(Number_T_cc,1);
    t_cc_2_1 = 1/3*T_ps*ones(Number_T_cc,1);
    
    for i = 1:No_video
        a0 = coefficient_a_all_video(i,1);
        a1 = coefficient_a_all_video(i,2);
        QoE(:,i) = (a1*t_obw + a0).*t_cc./T_cc_max';
        QoE_1_1(:,i) = (a1*t_obw_1_1 + a0).*min( t_cc_1_1./T_cc_max',1);
        QoE_1_2(:,i) = (a1*t_obw_1_2 + a0).*min( t_cc_1_2./T_cc_max',1);
        QoE_2_1(:,i) = (a1*t_obw_2_1 + a0).*min( t_cc_2_1./T_cc_max',1);
    end

    QoE = sum(QoE,2)/No_video;
    QoE_1_1 = sum(QoE_1_1,2)/No_video;
    QoE_1_2 = sum(QoE_1_2,2)/No_video;
    QoE_2_1 = sum(QoE_2_1,2)/No_video;

    % boundary
    x = 1./(T_ps - tau)*ones(5,1);
    alpha = sum(coefficient_a_all_video,1)/No_video;
    point = (alpha(2)*tau + alpha(1))*(T_ps - tau)/(T_ps - tau);
    y_QoE = linspace(0,point,5);

    figure(T_ps_index)
    plot(recp_T,QoE,'-b*','MarkerSize',8,'LineWidth',2);hold on;
    plot(recp_T,QoE_1_1,'-+','MarkerSize',8,'LineWidth',1.5,'Color',[0 0.5 0.5 ]);hold on;
    plot(recp_T,QoE_1_2,'-^','MarkerSize',8,'LineWidth',1.5,'Color',[1 0.5 0 ]);hold on;
    plot(recp_T,QoE_2_1,'-V','MarkerSize',8,'LineWidth',1.5,'Color',[0.5 0.5 0.5 ]);hold on;
    plot(x,y_QoE,'--r','LineWidth',2);hold on;
    set(gca,'ylim',[0,0.9],'ytick',[0:0.2:0.8 0.9],'yticklabel',{'0','20%','40%','60%','80%','90%'});hold on;
    set(gca,'FontSize',20,'Fontname', 'Times New Roman');hold on;grid on;

    xlabel('xtolatex');
    xtolatex = xlabel('$1/{T_{\mathrm{cc}}^{\max}}$(1/seconds)','Fontsize',20);
    xtolatex.Interpreter = 'latex';
    ylabel('Average QoE','FontSize',20,'Fontname', 'Times New Roman');
    legend('legend_QoE','FontName','Times New Roman','Fontsize',20);hold on;
    legend_QoE = legend('Opt duration','1:1 duration','1:2 duration','2:1 duration','$T_{\mathrm{cc}}^{\max} = T_{\mathrm{ps}}- \tau$','FontName','Times New Roman','Fontsize',20);
    legend_QoE.Interpreter = 'latex';
    legend('boxoff');
    
end

%% LR predictor
load fitting_performance_LR.mat coefficient_a_all_video;
for T_ps_index = 1: length(T_ps_set)
    T_ps = T_ps_set(T_ps_index);
    QoE = zeros(Number_T_cc,No_video);
    QoE_1_2 = zeros(Number_T_cc,No_video);
    QoE_2_1 = zeros(Number_T_cc,No_video);
    QoE_1_1 = zeros(Number_T_cc,No_video);

    %% optimal duration
    t_obw = max(T_ps - T_cc_max, tau)';
    t_cc = min(T_cc_max,T_ps - tau)';

    %% average duration
    t_obw_1_1 = 1/2*T_ps*ones(Number_T_cc,1);
    t_cc_1_1 = 1/2*T_ps*ones(Number_T_cc,1);

    %% 1:2 duration
    t_obw_1_2 = 1/3*T_ps*ones(Number_T_cc,1);
    t_2C_less = 2/3*T_ps*ones(Number_T_cc,1);

    %% 2:1 duration
    t_obw_2_1 = 2/3*T_ps*ones(Number_T_cc,1);
    t_2C_more = 1/3*T_ps*ones(Number_T_cc,1);

    for i = 1:No_video
        a3 = coefficient_a_all_video(i,4);
        a2 = coefficient_a_all_video(i,3);
        a1 = coefficient_a_all_video(i,2);
        a0 = coefficient_a_all_video(i,1);
        QoE(:,i) = (a3*t_obw.^3 + a2*t_obw.^2 + a1*t_obw + a0).*min( t_cc./T_cc_max',1);
        QoE_1_1(:,i) = (a3*t_obw_1_1.^3 + a2*t_obw_1_1.^2 + a1*t_obw_1_1 + a0).*min( t_cc_1_1./T_cc_max',1);
        QoE_1_2(:,i) = (a3*t_obw_1_2.^3 + a2*t_obw_1_2.^2 + a1*t_obw_1_2 + a0).*min( t_2C_less./T_cc_max',1);
        QoE_2_1(:,i) = (a3*t_obw_2_1.^3 + a2*t_obw_2_1.^2 + a1*t_obw_2_1 + a0).*min(t_2C_more./T_cc_max',1);
    end

    QoE = sum(QoE,2)/No_video;
    QoE_1_1 = sum(QoE_1_1,2)/No_video;
    QoE_1_2 = sum(QoE_1_2,2)/No_video;
    QoE_2_1 = sum(QoE_2_1,2)/No_video;

    % boundary
    x = 1./(T_ps - tau)*ones(5,1);
    alpha = sum(coefficient_a_all_video,1)/No_video;
    point = (alpha(4)*tau.^3 + alpha(3)*tau.^2 + alpha(2)*tau + alpha(1))*(T_ps - tau)/(T_ps - tau);
    y_QoE = linspace(0,point,5);


    figure(T_ps_index+2)
    plot(recp_T,QoE,'-b*','MarkerSize',8,'LineWidth',2);hold on;
    plot(recp_T,QoE_1_1,'-+','MarkerSize',8,'LineWidth',1.5,'Color',[0 0.5 0.5 ]);hold on;
    plot(recp_T,QoE_1_2,'-^','MarkerSize',8,'LineWidth',1.5,'Color',[1 0.5 0 ]);hold on;
    plot(recp_T,QoE_2_1,'-V','MarkerSize',8,'LineWidth',1.5,'Color',[0.5 0.5 0.5 ]);hold on;
    plot(x,y_QoE,'--r','LineWidth',2);hold on;
    set(gca,'ylim',[0,0.8],'ytick',0:0.2:0.8,'yticklabel',{'0','20%','40%','60%','80%'});hold on;
    set(gca,'FontSize',20,'Fontname', 'Times New Roman');hold on;grid on;

    xlabel('xtolatex');
    xtolatex = xlabel('$1/{T_{\mathrm{cc}}^{\max}}$(1/seconds)','Fontsize',20);
    xtolatex.Interpreter = 'latex';
    ylabel('Average QoE','FontSize',20,'Fontname', 'Times New Roman');
    legend('legend_QoE','FontName','Times New Roman','Fontsize',20);hold on;
    legend_QoE = legend('Opt duration','1:1 duration','1:2 duration','2:1 duration','$T_{\mathrm{CC}}^{\max} = T_{\mathrm{ps}}- \tau$','FontName','Times New Roman','Fontsize',20);
    legend_QoE.Interpreter = 'latex';
    legend('boxoff');
end

