clc;clear;
[mu,s_cpt,s_com,N] = obtain_global_MEC_parameter;
s_cpt = s_cpt/10^9; %Gbits
s_com = s_com/10^9; %Gbits

%% transmission parameters
N_t = 64;
B = 100;%MHz
K = 1:1:10;%user number
P_t = 200;%w maxmize 200w
P_t_dB = 10*log10(P_t./K*10^3);
Noise_SE = -174;%db/Hz
Noise_power = 10*log10(10^(-17.4).*B*10^6);
d_w = 200;%m
d_h = 10 - 1.5;%m
d_3d = sqrt(d_w^2+d_h^2);
f_c = 3.5;%GHz;
PL = 32.4 + 20*log10(f_c) + 31.9*log10(d_3d);
SNR_dB = (P_t_dB - PL - Noise_power);
SNR = 10.^((SNR_dB)/10);

% ensemble-average rate
r = zeros(length(SNR),1);
X = 10^6;
for i = 1:length(SNR)
    hk2 = chi2rnd(2*(N_t-K(i)+1),X,1);
    r(i) = mean(log2( 1 + SNR(i)'.*hk2));
end
C_com = B.*r/10^3;%Gbps

%% equivlent C_cpt
C_cpt = 16*10^(12)/mu./K/10^9;%Gbps
C_cpt = C_cpt';

%% T_cc
T_cc_max = s_com.*N./C_com + s_cpt.*N./C_cpt;

load fitting_performance_CB.mat coefficient_a_all_video;

No_video = 10;
Number_T_cc = length(T_cc_max);

QoE = zeros(Number_T_cc,No_video);
QoE_1_2 = zeros(Number_T_cc,No_video);
QoE_2_1 = zeros(Number_T_cc,No_video);
QoE_1_1 = zeros(Number_T_cc,No_video);

recp_T = 1./T_cc_max;

tau = 0.1;
T_ps = 1;

%% opt duration
t_obw = max(T_ps - T_cc_max, tau)';
t_cc = min(T_cc_max,T_ps - tau)';

%% average duration
t_obw_1_1 = 1/2*T_ps*ones(Number_T_cc,1);
t_2C_1_1 = 1/2*T_ps*ones(Number_T_cc,1);


%% 1:2 duration
t_obw_1_2 = 1/3*T_ps*ones(Number_T_cc,1);
t_2C_1_2 = 2/3*T_ps*ones(Number_T_cc,1);


%% 2:1 duration
t_obw_2_1 = 2/3*T_ps*ones(Number_T_cc,1);
t_2C_2_1 = 1/3*T_ps*ones(Number_T_cc,1);

for i = 1:No_video
    a0 = coefficient_a_all_video(i,1);
    a1 = coefficient_a_all_video(i,2);
    QoE(:,i) = (a1*t_obw + a0).*t_cc./T_cc_max';
    QoE_1_1(:,i) = (a1*t_obw_1_1 + a0).*min( t_2C_1_1./T_cc_max,1);
    QoE_1_2(:,i) = (a1*t_obw_1_2 + a0).*min( t_2C_1_2./T_cc_max,1);
    QoE_2_1(:,i) = (a1*t_obw_2_1 + a0).*min( t_2C_2_1./T_cc_max, 1);
end

QoE = sum(QoE,2)/No_video;
QoE_1_1 = sum(QoE_1_1,2)/No_video;
QoE_1_2 = sum(QoE_1_2,2)/No_video;
QoE_2_1 = sum(QoE_2_1,2)/No_video;


%% QoE_vs_K, compare
clear figure
plot(K,QoE,'-b*','MarkerSize',8,'LineWidth',2);hold on;
plot(K,QoE_1_1,'-+','MarkerSize',8,'LineWidth',1.5,'Color',[0 0.5 0.5 ]);hold on;
plot(K,QoE_1_2,'-^','MarkerSize',8,'LineWidth',1.5,'Color',[1 0.5 0 ]);hold on;
plot(K,QoE_2_1,'-V','MarkerSize',8,'LineWidth',1.5,'Color',[0.5 0.5 0.5 ]);hold on;
set(gca,'xlim',[1,max(K)],'xtick',[1 2:2:max(K)]);hold on;
set(gca,'ylim',[0.15,0.85],'ytick',[0.2:0.2:0.8 0.85],'yticklabel',{'20%','40%','60%','80%','85%'});hold on;
set(gca,'FontSize',20,'Fontname', 'Times New Roman');hold on;grid on;

xlabel('xtolatex');
xtolatex = xlabel('Number of users $K$','Fontname', 'Times New Roman','Fontsize',20);
xtolatex.Interpreter = 'latex';
ylabel('ytolatex');
ytolatex = ylabel('Average QoE/user','Fontsize',20);
legend('legend_QoE','FontName','Times New Roman','Fontsize',20);hold on;
legend_QoE = legend('Opt duration','1:1 duration','1:2 duration','2:1 duration','FontName','Times New Roman','Fontsize',20);
legend_QoE.Interpreter = 'latex';
legend('boxoff');



