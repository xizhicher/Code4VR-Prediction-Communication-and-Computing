function [mu_r_Turing,s_cpt,s_com,N] = obtain_global_MEC_parameter

%% 1. obtain the rendering parameter mu_r for Turing architecture
% The evolution of GPU architechture is as follows:
% Maxwell(2015) --> Pascal(2016) --> Turing (2018)
% Since there are no measured results for rendering using Turing
% architecture when we revised our paper, we roughtly estimate mu_r from the
% Maxwell and Pascal architecture, by considering the gain from Pascal to
% Turing is the same as the gain from Maxwell to Pascal.

% 1.1 mu_r under Maxwell architecture
C_r = 3.920*10^(12);%in FLOPS, GPU:GTX 970 
r = 0.2;
R_w = 4096;
R_h = 2160;
b = 12;
T_r = [47.13 47.13 37.77 33.77 38.72 41.08 33.33 33.33 45.76 33.55]*10^(-3); %s

mu_r_Maxwell = T_r*C_r/(r*R_w*R_h*b);
mu_r_Maxwell_aver = mean(mu_r_Maxwell);
mu_r_Maxwell = mu_r_Maxwell';

% 1.2 mu_r under Pascal architecture
C_r = 6.691*10^(12);% in FLOPS, GPU: Tiantain X
r = 0.2;
R_w = 2160;
R_h = 1200;
b = 12;
T_r = [5.4 9.5 7.9 4.5]*10^(-3);

mu_r_Pascal = T_r*C_r/(r*R_w*R_h*b);

% The 2nd in Maxwell architecture measurement results and the 4th in Pascal
% is the same video
G_mu_r = mu_r_Maxwell(2)/mu_r_Pascal(4);

% 1.3 estimate the mu_r for the Turing architecture
mu_r_Turing  = mu_r_Maxwell_aver/G_mu_r^2;

%% 2 obtain s_com, s_cpt, and N

%total resolution:4K
% 3840/6 = 640
% 2160/4 = 540;
r_w = 640;
r_h = 540;
% 30 frames per second
N_tf = 30;
gamma_fov = 0.3;
b = 12;%bit/pixel ?
M = 24; % total tiles
N = ceil(M*gamma_fov);

s_cpt = r_w*r_h*b*N_tf;%bits
compress_ratio = 2.41;
s_com = s_cpt/compress_ratio;%bits