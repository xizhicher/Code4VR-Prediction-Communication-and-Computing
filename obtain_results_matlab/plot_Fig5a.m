clc;clear;

T_cc_max = 0.2:0.05:50;
recp_T = 1./T_cc_max;
tau = 0.1;
T_seg = 1;
No_video = 10;
QoE_CB = zeros(No_video,length(recp_T));
QoE_LR = zeros(No_video,length(recp_T));
T_ps = 1; %
[t_obw,t_cc,x,y_obw] = optimal_solution(T_cc_max,tau,T_ps);

%% CB method
load fitting_performance_CB.mat coefficient_a_all_video ;
for i = 1:No_video
    a0 = coefficient_a_all_video(i,1);
    a1 = coefficient_a_all_video(i,2);
    QoE_CB(i,:) = (a1*t_obw + a0).*t_cc./T_cc_max; 
end
QoE_CB = sum(QoE_CB,1)/No_video;

%% LR method
load fitting_performance_LR.mat coefficient_a_all_video ;
for i = 1:No_video
    a3 = coefficient_a_all_video(i,4);
    a2 = coefficient_a_all_video(i,3);
    a1 = coefficient_a_all_video(i,2);
    a0 = coefficient_a_all_video(i,1);
    QoE_LR(i,:) = (a3*t_obw.^3 + a2*t_obw.^2 + a1*t_obw + a0).*t_cc./T_cc_max;
end
QoE_LR = sum(QoE_LR,1)/No_video;

clear figure
figure(2)
plot(recp_T,QoE_CB,'-b*','MarkerSize',8,'LineWidth',2);hold on;
plot(recp_T,QoE_LR,'-g^','MarkerSize',8,'LineWidth',2);hold on;
plot(x,y_obw,'--r','LineWidth',2);hold on;
set(gca,'xlim',[min(recp_T),max(recp_T)],'xtick',[min(recp_T) 1:1:max(recp_T)]);hold on;
set(gca,'ylim',[0,0.9],'ytick',[0:0.2:0.8 0.9],'yticklabel',{'0','20%','40%','60%','80%','90%'});hold on;
set(gca,'FontSize',20,'Fontname', 'Times New Roman');hold on;grid on;


legend('legend_2C_obw');hold on;
legend_2C_obw = legend('CB method','LR method','$\displaystyle T_{\mathrm{cc}}^{\max} = T_{\mathrm{ps}} - \tau $','FontName','Times New Roman','Fontsize',22);
legend_2C_obw.Interpreter = 'latex';
set(legend_2C_obw,'Box','off');

text(1/(T_seg - tau)- 0.5, max(t_obw) - 0.1,'Resource-limited region','FontName','Times New Roman','Fontsize',20,'FontWeight','bold');hold on; %
text(1/(T_seg - tau)+ 1,max(t_obw) - 0.5,'Prediction-limited region','FontName','Times New Roman','Fontsize',20,'FontWeight','bold');hold on;

xlabel('xtolatex');
xtolatex = xlabel('$\displaystyle 1/T_{\mathrm{cc}}^{\max}$(1/seconds)','Fontsize',20);
xtolatex.Interpreter = 'latex';
ylabel('Average QoE','FontName','Times New Roman','Fontsize',20);


function  [t_obw, t_cc,x,y_obw]= optimal_solution(T_cc_max,tau,T_ps)


t_obw = max(T_ps - T_cc_max, tau);

t_cc = min(T_cc_max,T_ps - tau);

x = 1./(T_ps - tau)*ones(5,1);

y_obw = linspace(0,0.9,5); 
end



