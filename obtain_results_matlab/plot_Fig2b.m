clc;clear;

T_cc_max = 0.2:0.05:50;
Number_T_cc_max = length(T_cc_max);
recp_T = 1./T_cc_max;
tau = 0.1;
T_seg = 1;
T_ps = 1;


%% The solution comes from formula (19) in the paper
t_obw = max(T_ps - T_cc_max, tau);

t_cc = min(T_cc_max,T_ps - tau);

boundary_x = 1./(T_ps - tau)*ones(5,1);

boundary_y = linspace(min(t_obw),max(t_cc),5); 


clear figure

plot(recp_T,t_obw,'-b*','MarkerSize',8,'LineWidth',2);hold on;
plot(recp_T,t_cc,'-g^','MarkerSize',8,'LineWidth',2);hold on;
plot(boundary_x,boundary_y,'--r','LineWidth',2);hold on;
set(gca,'xlim',[min(recp_T),max(recp_T)],'xtick',[min(recp_T) 1:1:max(recp_T)]);hold on;
set(gca,'ylim',[min(min(t_obw)),max(max(t_cc))],'ytick',[min(min(t_obw)) 0.2:0.2:1 ] );hold on;
set(gca,'FontSize',20,'Fontname', 'Times New Roman');hold on;grid on;


legend('legend_2C_obw');hold on;
legend_fig2b = legend('$t_{\mathrm{obw}}^{*}$','$t_{\mathrm{cc}}^{*}$','$\displaystyle T_{\mathrm{cc}}^{\max} = T_{\mathrm{ps}} - \tau $','FontName','Times New Roman','Fontsize',22);
legend_fig2b.Interpreter = 'latex';
set(legend_fig2b,'Box','off');

text(1/(T_seg - tau)+ 0.5, max(t_cc) - 0.1,'Resource-limited region','FontName','Times New Roman','Fontsize',20,'FontWeight','bold');hold on; %
text(1/(T_seg - tau)+ 0.5,min(t_obw)+0.1,'Prediction-limited region','FontName','Times New Roman','Fontsize',20,'FontWeight','bold');hold on;

xlabel('xtolatex');
xtolatex = xlabel('$\displaystyle 1/T_{\mathrm{cc}}^{\max}$(1/seconds)','Fontsize',20);
xtolatex.Interpreter = 'latex';
ylabel('Duration(seconds)','FontName','Times New Roman','Fontsize',20);





