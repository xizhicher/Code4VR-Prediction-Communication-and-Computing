clc;clear

%% CB method
load fitting_performance_CB.mat coefficient_a_all_video ;

No_video = 10;

T_cc_max = 0.2:0.1:50;

Number_T_cc = length(T_cc_max);

DoO = zeros(Number_T_cc,No_video);

recp_T = 1./T_cc_max;

tau = 0.1;

T_ps = 1;


t_obw = max(T_ps - T_cc_max, tau)';

t_cc = min(T_cc_max,T_ps - tau)';



for i = 1:No_video
    a0 = coefficient_a_all_video(i,1);
    a1 = coefficient_a_all_video(i,2);
    DoO(:,i) = (a1*t_obw + a0);
end

DoO = sum(DoO,2)/No_video;

CC_Completion_rate = t_cc./T_cc_max';

QoE = DoO.*CC_Completion_rate;

% optimal boundary
x = 1./(T_ps - tau)*ones(5,1);

alpha = sum(coefficient_a_all_video,1)/No_video;

y_QoE = linspace(0,1,5);

clear figure;
plot(recp_T,DoO,'linestyle','-','marker','o','color',[0 0.74902 1],'MarkerSize',8,'LineWidth',2);hold on;
plot(recp_T,CC_Completion_rate,'linestyle','-','marker','v','color',[0.19608 0.80392 0.19608],'MarkerSize',8,'LineWidth',2);hold on;
plot(recp_T,QoE,'linestyle','-','marker','*','color',[0.62745 0.12549 0.94118],'MarkerSize',8,'LineWidth',2);hold on;
plot(x,y_QoE,'--r','LineWidth',2);hold on;
legend('DoO','CC capability','QoE','boundary line');
set(gca,'xlim',[min(recp_T),max(recp_T)],'xtick',[min(recp_T) 1:1:max(recp_T)]);hold on;
set(gca,'ylim',[0,1],'ytick',[0:0.2:1 ],'yticklabel',{'0','20%','40%','60%','80%','100%'} );hold on;
set(gca,'FontSize',20,'Fontname', 'Times New Roman');hold on;grid on;
xlabel('xtolatex');
xtolatex = xlabel('$\displaystyle 1/T_{\mathrm{cc}}^{\max}$(1/seconds)','Fontsize',20);
xtolatex.Interpreter = 'latex';
ylabel('QoE, $\mathcal{D}(t_{\mathrm{obw}}^*)$, and $S_{\mathrm{cc}}^{*}(t_{\mathrm{cc}}^*)$','interpreter','latex','FontName','Times New Roman','Fontsize',20);
legend('legend_2C_obw');hold on;
legend_2C_obw = legend('$\mathcal{D}(t_{\mathrm{obw}}^*)$','$S_{\mathrm{cc}}^{*}(t_{\mathrm{cc}}^*)$','Average QoE','$\displaystyle T_{\mathrm{cc}}^{\max} = T_{\mathrm{ps}} - \tau $','FontName','Times New Roman','Fontsize',22);
legend_2C_obw.Interpreter = 'latex';
set(legend_2C_obw,'Box','off');hold on;

text(3, 0.75,'Resource-limited region','FontName','Times New Roman','Fontsize',20,'FontWeight','bold');hold on; %
text(3,0.85,'Prediction-limited region','FontName','Times New Roman','Fontsize',20,'FontWeight','bold');hold on;

