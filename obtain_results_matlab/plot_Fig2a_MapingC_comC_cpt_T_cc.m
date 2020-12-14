clc;clear;
[mu,s_cpt,s_com,N] = obtain_global_MEC_parameter;
s_cpt = s_cpt/10^6; %Mbits
s_com = s_com/10^6; %Mbita

%% 1 obtain the ensemble-average transmission rate C_com
N_t = 64;
Num_B_P_t = 30;
B = linspace(5,200,Num_B_P_t);%MHz
K = 10;%user number
P_t = linspace(10,50,Num_B_P_t);%w 
P_t_dB = 10*log10(P_t*10^3);
Noise_SE = -174;%db/Hz
Noise_power = 10*log10(10^(-17.4).*B*10^6);
d_w = 200;%m
d_h = 25 - 1.5;%m
d_3d = sqrt(d_w^2+d_h^2);
f_c = 3.5;%GHz;
PL = 32.4 + 20*log10(f_c) + 30*log10(d_3d);

SNR_dB = (P_t_dB - PL - Noise_power);

%SNR_dB = 10:1:20;
SNR = 10.^((SNR_dB)/10);
%% C_com is averaged over 10^6 channel realization
r = zeros(length(SNR),1);
X = 10^6;
hk2 = chi2rnd(2*(N_t-K+1),X,1);
for i = 1:length(SNR)
    r(i) = mean(log2( 1 + SNR(i)'.*hk2));
end

C_com = B.*r;%Mbps
C_com = reshape(C_com,1,length(SNR)*length(B));%Mbps
C_com = sort(C_com);

%% 2 Computing rate C_cpt
C_total = linspace(1,15,15)*16*10^12;%FLOPS
C_cpt = C_total/mu/10^6/K;%Mbps

%% T_cc
T_cc = zeros(length(C_com),length(C_cpt));

for i = 1:length(C_com)
    for j = 1:length(C_cpt)
        T_cc(i,j) = s_com.*N./C_com(i) + s_cpt.*N./C_cpt(j);
    end
end

T_com = s_com*N./(C_com);
T_cpt = s_cpt*N./(C_cpt);


recp_T = 1./T_cc;

C_com = C_com./10^3;%Mbps->Gbps
C_cpt = C_cpt./10^3;%Mbps->Gbps


figure(1)
mesh(C_com',C_cpt',recp_T');
xlabel('$C_{\mathrm{com}}$(Gbps)','interpreter','Latex','Fontsize',20);
ylabel('$C_{\mathrm{cpt}}$(Gbps)','interpreter','Latex','Fontsize',20);
zlabel('$1/T_{\mathrm{cc}}^{\max}$(1/seconds)','interpreter','Latex','Fontsize',20);
set(gca,'xlim',[0,4],'xtick',[0:1:4]);hold on;
set(gca,'ylim',[0,12],'ytick',[0:4:12]);hold on;
set(gca,'zlim',[0,5],'ztick',[0:1:5]);hold on;
set(gca,'FontSize',20,'Fontname', 'Times New Roman');hold on;grid on;
