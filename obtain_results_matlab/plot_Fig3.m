clc;clear;

T_cc_max = 0.2:0.005:50;
recp_T = 1./T_cc_max;
M = length(recp_T);

T_ps = 0.4:0.005:1.1;
N = length(T_ps);

t_obw = zeros(M,N);
t_cc = zeros(M,N);

tau = 0.1;
T_seg = 1;

boundary_recp_T = zeros(N,1);
boundary_T_ps = zeros(N,1);
boundary_t_obw = zeros(N,1);
boundary_t_cc = zeros(N,1);

%% find the boundary of the two regions and the optimal solution of t_obw and t_cc
for i = 1:N
    [t_obw(:,i),t_cc(:,i),boundary_recp_T(i),boundary_t_obw(i),boundary_t_cc(i)] = optimal_solution(T_cc_max,tau,T_ps(i));
    boundary_T_ps(i) = T_ps(i);
end

clear figure
figure(1)
plot3(boundary_T_ps,boundary_recp_T,boundary_t_obw,'-or','LineWidth',2);hold on;
mesh(T_ps',recp_T',t_obw);hold on;
legend('$T_{\mathrm{cc}}^{\max} = T_{\mathrm{ps}}-\tau$',...
    'interpreter','Latex','Fontsize',20,'box','off');hold on;
xlabel('$T_{\mathrm{ps}}$(seconds)','interpreter','Latex','Fontsize',20,'Rotation',20);
ylabel('$1/T_{\mathrm{cc}}^{\max}$(1/seconds)','interpreter','Latex','Fontsize',20,'Rotation',-20);
zlabel('$t_{\mathrm{obw}}^{*}$(seconds)','interpreter','Latex','Fontsize',20);
set(gca,'xlim',[0.4,1.1],'xtick',[0.4:0.2:1 1.1]);hold on;
set(gca,'ylim',[min(recp_T),max(recp_T)],'ytick',[min(recp_T) 1:1:max(recp_T)] );hold on;
set(gca,'zlim',[min(min(t_obw)),max(max(t_obw))],'ztick',[min(min(t_obw)):0.2:max(max(t_obw))]);hold on;
set(gca,'FontSize',20,'Fontname', 'Times New Roman');hold on;grid on;
text(1, 1,0.5,'Prediction-limited region','FontName','Times New Roman','Fontsize',20,'FontWeight','bold');hold on; %
text(1, 1,0.9,'Resource-limited region','FontName','Times New Roman','Fontsize',20,'FontWeight','bold');hold on;

figure(2)
plot3(boundary_T_ps,boundary_recp_T,boundary_t_cc,'-r','LineWidth',2);hold on;
mesh(T_ps',recp_T',t_cc);
legend('$T_{\mathrm{cc}}^{\max} = T_{\mathrm{ps}}-\tau$',...
    'interpreter','Latex','Fontsize',22,'box','off');hold on;
xlabel('$T_{\mathrm{ps}}$(seconds)','interpreter','Latex','Fontsize',22,'Rotation',-20);
ylabel('$1/T_{\mathrm{cc}}^{\max}$(1/seconds)','interpreter','Latex','Fontsize',22,'Rotation',15);
zlabel('$t_{\mathrm{cc}}^{*}$(seconds)','interpreter','Latex','Fontsize',22);
set(gca,'xlim',[0.4,1.1],'xtick',[0.4:0.2:1 1.1]);hold on;
set(gca,'ylim',[min(recp_T),max(recp_T)],'ytick',[min(recp_T) 1:1:max(recp_T)]);hold on;
set(gca,'zlim',[min(min(t_cc)),max(max(t_cc))],'ztick',[min(min(t_cc)):0.2:max(max(t_cc))]);hold on;
set(gca,'FontSize',22,'Fontname', 'Times New Roman');hold on;grid on;
text(1, 2,0.5,'Prediction-limited region','FontName','Times New Roman','Fontsize',22,'FontWeight','bold');hold on; %
text(1, 2,1,'Resource-limited region','FontName','Times New Roman','Fontsize',22,'FontWeight','bold');hold on;



%% The solution comes from formula (19) in the paper
function  [t_obw,t_cc,bd_recp_T,bd_t_obw,bd_t_cc]= optimal_solution(T_cc_max,tau,T_ps)

t_obw = max(T_ps - T_cc_max, tau);

t_cc = min(T_cc_max,T_ps - tau);

bd_recp_T = 1./(T_ps - tau);

bd_t_obw = min(t_obw); 
bd_t_cc = max(t_cc); 
end



