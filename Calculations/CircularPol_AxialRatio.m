% n2f_plot_cuts_5files.m
% this script reads the N2F txt file; !!! make sure to remove the text header from the txt file for use with this script !!!
% takes the H-pol and V-pol mag and calculates E_sum in dBi
% selects the E_sum values for AZ-cut (Theta = 90), EL1-cut (Phi = 0/180) and EL2-cut (Phi = 90/270)
% plots E_sum values from these cuts in polar plots using NSI plot sub-routines 

clear all;
close all;
clc;

%%%
% Fixed variables

% for polar plot scaling - change as necessary
rho_max = 5;
rho_min = -35;
rho_div = 8; 

% for AZ-cut
theta_az = 90; % Theta equals 90 deg
n_phi = 360; % number of points in Phi
x_phi = 1:n_phi; % Phi axis in deg
x_phi = x_phi' - 181;

% for EL-cuts
phi_el1 = 0; % EL1-cut at Phi = 0/180
phi_el2 = 90; % EL2-cut at Phi = 90/270 

n_th = 180; % number of points in Theta at one value of Phi
x_th = 1:n_th; % Theta axis in deg
x_th = [(x_th-181) x_th]';


%%%
% Read files:
file_read_1 = input('Name of file 1:', 's'); % asks for 1st file name to read - please, include .txt in name (e.g. a1.txt)
file_read_2 = input('Name of file 2:', 's'); % asks for 2nd file name to read - please, include .txt in name (e.g. a2.txt)
file_read_3 = input('Name of file 3:', 's'); % asks for 3rd file name to read - please, include .txt in name (e.g. a3.txt)
file_read_4 = input('Name of file 4:', 's'); % asks for 4th file name to read - please, include .txt in name (e.g. a4.txt)
file_read_5 = input('Name of file 5:', 's'); % asks for 5th file name to read - please, include .txt in name (e.g. a5.txt)

% read data from files in data arrays %% it should be 65
e1_data = dlmread(file_read_1, '\t', 65, 0); % use this if there is a text header - change line and column position according to header size
e2_data = dlmread(file_read_2, '\t', 65, 0); % use this if there is a text header - change line and column position according to header size
e3_data = dlmread(file_read_3, '\t', 65, 0); % use this if there is a text header - change line and column position according to header size
e4_data = dlmread(file_read_4, '\t', 65, 0); % use this if there is a text header - change line and column position according to header size
e5_data = dlmread(file_read_5, '\t', 65, 0); % use this if there is a text header - change line and column position according to header size


% calculate E_sum in dBi from H-pol (3-rd col in data array) and V-pol (5-th col in data array) 
e1_sum = 10.*log10(10.^(e1_data(:,3)./10) + 10.^(e1_data(:,5)./10)); % E1_sum in dBi
e2_sum = 10.*log10(10.^(e2_data(:,3)./10) + 10.^(e2_data(:,5)./10)); % E2_sum in dBi
e3_sum = 10.*log10(10.^(e3_data(:,3)./10) + 10.^(e3_data(:,5)./10)); % E3_sum in dBi
e4_sum = 10.*log10(10.^(e4_data(:,3)./10) + 10.^(e4_data(:,5)./10)); % E4_sum in dBi
e5_sum = 10.*log10(10.^(e5_data(:,3)./10) + 10.^(e5_data(:,5)./10)); % E5_sum in dBi

%%% calculating left and right hand circular polarization components from
%%% Hor and Ver components - Start
e1_Hor_Temp = (10.^(e1_data(:,3)./10)).*exp(1i.*e1_data(:,4).*pi/180);
e1_Hor_complx = real(e1_Hor_Temp)+1i*imag(e1_Hor_Temp);
e1_Ver_Temp = (10.^(e1_data(:,5)./10)).*exp(1i.*e1_data(:,6).*pi/180);
e1_Ver_complx = real(e1_Ver_Temp)+1i*imag(e1_Ver_Temp);
e1_LHP = (1/sqrt(2)).*(e1_Ver_complx-1i*e1_Hor_complx);
e1_RHP = (1/sqrt(2)).*(e1_Ver_complx+1i*e1_Hor_complx);
AR1 = (abs(e1_LHP)+abs(e1_RHP))./(abs(e1_LHP)-abs(e1_RHP));

e2_Hor_Temp = (10.^(e2_data(:,3)./10)).*exp(1i.*e2_data(:,4).*pi/180);
e2_Hor_complx = real(e2_Hor_Temp)+1i*imag(e2_Hor_Temp);
e2_Ver_Temp = (10.^(e2_data(:,5)./10)).*exp(1i.*e2_data(:,6).*pi/180);
e2_Ver_complx = real(e2_Ver_Temp)+1i*imag(e2_Ver_Temp);
e2_LHP = (1/sqrt(2)).*(e2_Ver_complx-1i*e2_Hor_complx);
e2_RHP = (1/sqrt(2)).*(e2_Ver_complx+1i*e2_Hor_complx);
AR2 = (abs(e2_LHP)+abs(e2_RHP))./(abs(e2_LHP)-abs(e2_RHP));

e3_Hor_Temp = (10.^(e3_data(:,3)./10)).*exp(1i.*e3_data(:,4).*pi/180);
e3_Hor_complx = real(e3_Hor_Temp)+1i*imag(e3_Hor_Temp);
e3_Ver_Temp = (10.^(e3_data(:,5)./10)).*exp(1i.*e3_data(:,6).*pi/180);
e3_Ver_complx = real(e3_Ver_Temp)+1i*imag(e3_Ver_Temp);
e3_LHP = (1/sqrt(2)).*(e3_Ver_complx-1i*e3_Hor_complx);
e3_RHP = (1/sqrt(2)).*(e3_Ver_complx+1i*e3_Hor_complx);
AR3 = (abs(e3_LHP)+abs(e3_RHP))./(abs(e3_LHP)-abs(e3_RHP));

e4_Hor_Temp = (10.^(e4_data(:,3)./10)).*exp(1i.*e4_data(:,4).*pi/180);
e4_Hor_complx = real(e4_Hor_Temp)+1i*imag(e4_Hor_Temp);
e4_Ver_Temp = (10.^(e4_data(:,5)./10)).*exp(1i.*e4_data(:,6).*pi/180);
e4_Ver_complx = real(e4_Ver_Temp)+1i*imag(e4_Ver_Temp);
e4_LHP = (1/sqrt(2)).*(e4_Ver_complx-1i*e4_Hor_complx);
e4_RHP = (1/sqrt(2)).*(e4_Ver_complx+1i*e4_Hor_complx);
AR4 = (abs(e4_LHP)+abs(e4_RHP))./(abs(e4_LHP)-abs(e4_RHP));

e5_Hor_Temp = (10.^(e5_data(:,3)./10)).*exp(1i.*e5_data(:,4).*pi/180);
e5_Hor_complx = real(e5_Hor_Temp)+1i*imag(e5_Hor_Temp);
e5_Ver_Temp = (10.^(e5_data(:,5)./10)).*exp(1i.*e5_data(:,6).*pi/180);
e5_Ver_complx = real(e5_Ver_Temp)+1i*imag(e5_Ver_Temp);
e5_LHP = (1/sqrt(2)).*(e5_Ver_complx-1i*e5_Hor_complx);
e5_RHP = (1/sqrt(2)).*(e5_Ver_complx+1i*e5_Hor_complx);
AR5 = (abs(e5_LHP)+abs(e5_RHP))./(abs(e5_LHP)-abs(e5_RHP));

%%% calculating left and right hand circular polarization components from
%%% Hor and Ver components - End




%%% Select data from cuts
% Select Azimuth Cut - sweeping phi w/ Theta held at 90 deg.

e1_sum_az = e1_sum(theta_az*n_phi+1:(theta_az+1)*n_phi,1);
e2_sum_az = e2_sum(theta_az*n_phi+1:(theta_az+1)*n_phi,1);
e3_sum_az = e3_sum(theta_az*n_phi+1:(theta_az+1)*n_phi,1);
e4_sum_az = e4_sum(theta_az*n_phi+1:(theta_az+1)*n_phi,1);
e5_sum_az = e5_sum(theta_az*n_phi+1:(theta_az+1)*n_phi,1);

%%%% for Axial Ratio Start %%%%%%
AR1_az = AR1(theta_az*n_phi+1:(theta_az+1)*n_phi,1);
AR2_az = AR2(theta_az*n_phi+1:(theta_az+1)*n_phi,1);
AR3_az = AR3(theta_az*n_phi+1:(theta_az+1)*n_phi,1);
AR4_az = AR4(theta_az*n_phi+1:(theta_az+1)*n_phi,1);
AR5_az = AR5(theta_az*n_phi+1:(theta_az+1)*n_phi,1);
%%%% for Axial Ratio End %%%%%%
%
% Select EL1 Cut data - sweeping Theta w/ Phi held at 0/180 deg.

e1_sum_el1 = zeros(1,2*n_th); % initialize array for E1_sum
e2_sum_el1 = zeros(1,2*n_th); % initialize array for E2_sum
e3_sum_el1 = zeros(1,2*n_th); % initialize array for E3_sum
e4_sum_el1 = zeros(1,2*n_th); % initialize array for E4_sum
e5_sum_el1 = zeros(1,2*n_th); % initialize array for E5_sum

%%%% for Axial Ratio Start %%%%%%
AR1_el1 = zeros(1,2*n_th);
AR2_el1 = zeros(1,2*n_th);
AR3_el1 = zeros(1,2*n_th);
AR4_el1 = zeros(1,2*n_th);
%%%% for Axial Ratio End %%%%%%

e1_pick1 = zeros(1,n_th); % initialize array for filling up E1_sum
e2_pick1 = zeros(1,n_th); % initialize array for filling up E2_sum
e3_pick1 = zeros(1,n_th); % initialize array for filling up E3_sum
e4_pick1 = zeros(1,n_th); % initialize array for filling up E4_sum
e5_pick1 = zeros(1,n_th); % initialize array for filling up E5_sum
e1_pick2 = zeros(1,n_th); % initialize array for filling up E1_sum
e2_pick2 = zeros(1,n_th); % initialize array for filling up E2_sum
e3_pick2 = zeros(1,n_th); % initialize array for filling up E3_sum
e4_pick2 = zeros(1,n_th); % initialize array for filling up E4_sum
e5_pick2 = zeros(1,n_th); % initialize array for filling up E5_sum

%%%% for Axial Ratio Start %%%%%%
AR1_pick1 = zeros(1,n_th);
AR2_pick1 = zeros(1,n_th);
AR3_pick1 = zeros(1,n_th);
AR4_pick1 = zeros(1,n_th);
AR5_pick1 = zeros(1,n_th);
%%%% for Axial Ratio End %%%%%%

% fill arrays point-by-point for Phi = 0/180 
for n = 1:n_th;
    m = n_phi*(n - 1) + phi_el1 + 1; % note index dependence on phi_el1 defined earlier
    e1_pick1(1,n) = e1_sum(m,1); % 1st half of E1 data @ Phi_EL1 = 0
    e2_pick1(1,n) = e2_sum(m,1); % 1st half of E2 data @ Phi_EL1 = 0
    e3_pick1(1,n) = e3_sum(m,1); % 1st half of E3 data @ Phi_EL1 = 0
    e4_pick1(1,n) = e4_sum(m,1); % 1st half of E4 data @ Phi_EL1 = 0
    e5_pick1(1,n) = e5_sum(m,1); % 1st half of E5 data @ Phi_EL1 = 0
    e1_pick2(1,n) = e1_sum(m+180,1); % 2nd half of E1 data @ Phi_EL1 + 180
    e2_pick2(1,n) = e2_sum(m+180,1); % 2nd half of E2 data @ Phi_EL1 + 180
    e3_pick2(1,n) = e3_sum(m+180,1); % 2nd half of E3 data @ Phi_EL1 + 180
    e4_pick2(1,n) = e4_sum(m+180,1); % 2nd half of E4 data @ Phi_EL1 + 180
    e5_pick2(1,n) = e5_sum(m+180,1); % 2nd half of E5 data @ Phi_EL1 + 180
    
    %%%% for Axial Ratio Start %%%%%%
    AR1_pick1(1,n) = AR1(m,1);
    AR2_pick1(1,n) = AR2(m,1);
    AR3_pick1(1,n) = AR3(m,1);
    AR4_pick1(1,n) = AR4(m,1);
    AR5_pick1(1,n) = AR5(m,1);
    AR1_pick2(1,n) = AR1(m+180,1);
    AR2_pick2(1,n) = AR2(m+180,1);
    AR3_pick2(1,n) = AR3(m+180,1);
    AR4_pick2(1,n) = AR4(m+180,1);
    AR5_pick2(1,n) = AR5(m+180,1);
    %%%% for Axial Ratio End %%%%%%
end

% combine data in the designated arrays
e1_sum_el1 = [fliplr(e1_pick1) e1_pick2]';
e2_sum_el1 = [fliplr(e2_pick1) e2_pick2]';
e3_sum_el1 = [fliplr(e3_pick1) e3_pick2]';
e4_sum_el1 = [fliplr(e4_pick1) e4_pick2]';
e5_sum_el1 = [fliplr(e5_pick1) e5_pick2]';

%%%% for Axial Ratio Start %%%%%%
AR1_el1 = [fliplr(AR1_pick1) AR1_pick2]';
AR2_el1 = [fliplr(AR2_pick1) AR2_pick2]';
AR3_el1 = [fliplr(AR3_pick1) AR3_pick2]';
AR4_el1 = [fliplr(AR4_pick1) AR4_pick2]';
AR5_el1 = [fliplr(AR5_pick1) AR5_pick2]';
%%%% for Axial Ratio End %%%%%%

% arrange data for correct plotting
e1_sum_el1 = flipud(e1_sum_el1);
e2_sum_el1 = flipud(e2_sum_el1);
e3_sum_el1 = flipud(e3_sum_el1);
e4_sum_el1 = flipud(e4_sum_el1);
e5_sum_el1 = flipud(e5_sum_el1);

%%%% for Axial Ratio Start %%%%%%
AR1_el1 = flipud(AR1_el1);
AR2_el1 = flipud(AR2_el1);
AR3_el1 = flipud(AR3_el1);
AR4_el1 = flipud(AR4_el1);
AR5_el1 = flipud(AR5_el1);
%%%% for Axial Ratio End %%%%%%
%
% Select EL2 Cut data - sweeping Theta w/ Phi held at 90/270 deg.

e1_sum_el2 = zeros(1,2*n_th); % initialize array for E1_sum
e2_sum_el2 = zeros(1,2*n_th); % initialize array for E2_sum
e3_sum_el2 = zeros(1,2*n_th); % initialize array for E3_sum
e4_sum_el2 = zeros(1,2*n_th); % initialize array for E4_sum
e5_sum_el2 = zeros(1,2*n_th); % initialize array for E5_sum

%%%% for Axial Ratio Start %%%%%%
AR1_el2 = zeros(1,2*n_th);
AR2_el2 = zeros(1,2*n_th);
AR3_el2 = zeros(1,2*n_th);
AR4_el2 = zeros(1,2*n_th);
AR5_el2 = zeros(1,2*n_th);
%%%% for Axial Ratio End %%%%%%

e1_pick1 = zeros(1,n_th); % initialize array for filling up E1_sum
e2_pick1 = zeros(1,n_th); % initialize array for filling up E2_sum
e3_pick1 = zeros(1,n_th); % initialize array for filling up E3_sum
e4_pick1 = zeros(1,n_th); % initialize array for filling up E4_sum
e5_pick1 = zeros(1,n_th); % initialize array for filling up E5_sum
e1_pick2 = zeros(1,n_th); % initialize array for filling up E1_sum
e2_pick2 = zeros(1,n_th); % initialize array for filling up E2_sum
e3_pick2 = zeros(1,n_th); % initialize array for filling up E3_sum
e4_pick2 = zeros(1,n_th); % initialize array for filling up E4_sum
e5_pick2 = zeros(1,n_th); % initialize array for filling up E5_sum

%%%% for Axial Ratio Start %%%%%%
AR1_pick1 = zeros(1,n_th);
AR2_pick1 = zeros(1,n_th);
AR3_pick1 = zeros(1,n_th);
AR4_pick1 = zeros(1,n_th);
AR5_pick1 = zeros(1,n_th);
%%%% for Axial Ratio End %%%%%%

% fill arrays point-by-point for Phi = 90/270 
for n = 1:n_th;
    m = n_phi*(n - 1) + phi_el2 + 1; % note index dependence on phi_el2 defined earlier 
    e1_pick1(1,n) = e1_sum(m,1); % 1st half of E1 data @ Phi_EL2 = 90
    e2_pick1(1,n) = e2_sum(m,1); % 1st half of E2 data @ Phi_EL2 = 90
    e3_pick1(1,n) = e3_sum(m,1); % 1st half of E3 data @ Phi_EL2 = 90
    e4_pick1(1,n) = e4_sum(m,1); % 1st half of E4 data @ Phi_EL2 = 90
    e5_pick1(1,n) = e5_sum(m,1); % 1st half of E5 data @ Phi_EL2 = 90
    e1_pick2(1,n) = e1_sum(m+180,1); % 2nd half of E1 data @ Phi_EL2 + 180
    e2_pick2(1,n) = e2_sum(m+180,1); % 2nd half of E2 data @ Phi_EL2 + 180
    e3_pick2(1,n) = e3_sum(m+180,1); % 2nd half of E3 data @ Phi_EL2 + 180
    e4_pick2(1,n) = e4_sum(m+180,1); % 2nd half of E4 data @ Phi_EL2 + 180
    e5_pick2(1,n) = e5_sum(m+180,1); % 2nd half of E5 data @ Phi_EL2 + 180
    
    %%%% for Axial Ratio Start %%%%%%
    AR1_pick1(1,n) = AR1(m,1);
    AR2_pick1(1,n) = AR2(m,1);
    AR3_pick1(1,n) = AR3(m,1);
    AR4_pick1(1,n) = AR4(m,1);
    AR5_pick1(1,n) = AR5(m,1);
    AR1_pick2(1,n) = AR1(m+180,1);
    AR2_pick2(1,n) = AR2(m+180,1);
    AR3_pick2(1,n) = AR3(m+180,1);
    AR4_pick2(1,n) = AR4(m+180,1);
    AR5_pick2(1,n) = AR5(m+180,1);
    %%%% for Axial Ratio End %%%%%%
end

% combine data in the designated arrays
e1_sum_el2 = [fliplr(e1_pick1) e1_pick2]';
e2_sum_el2 = [fliplr(e2_pick1) e2_pick2]';
e3_sum_el2 = [fliplr(e3_pick1) e3_pick2]';
e4_sum_el2 = [fliplr(e4_pick1) e4_pick2]';
e5_sum_el2 = [fliplr(e5_pick1) e5_pick2]';

%%%% for Axial Ratio Start %%%%%%
    AR1_el2 = [fliplr(AR1_pick1) AR1_pick2]';
    AR2_el2 = [fliplr(AR2_pick1) AR2_pick2]';
    AR3_el2 = [fliplr(AR3_pick1) AR3_pick2]';
    AR4_el2 = [fliplr(AR4_pick1) AR4_pick2]';
    AR5_el2 = [fliplr(AR5_pick1) AR5_pick2]';
%%%% for Axial Ratio End %%%%%%

% arrange data for correct plotting
e1_sum_el2 = flipud(e1_sum_el2);
e2_sum_el2 = flipud(e2_sum_el2);
e3_sum_el2 = flipud(e3_sum_el2);
e4_sum_el2 = flipud(e4_sum_el2);
e5_sum_el2 = flipud(e5_sum_el2);

%%%% for Axial Ratio Start %%%%%%
    AR1_el2 = flipud(AR1_el2);
    AR2_el2 = flipud(AR2_el2);
    AR3_el2 = flipud(AR3_el2);
    AR4_el2 = flipud(AR4_el2);
    AR5_el2 = flipud(AR5_el2);
%%%% for Axial Ratio End %%%%%%

%  Find peak and average gain for measured azimuth cut
e1_sum_az_Peak=max(e1_sum_az);
e2_sum_az_Peak=max(e2_sum_az);
e3_sum_az_Peak=max(e3_sum_az);
e4_sum_az_Peak=max(e4_sum_az);
e5_sum_az_Peak=max(e5_sum_az);
% 
e1_sum_az_linear=10.^(e1_sum_az./10);
e1_sum_az_lin_avg=mean(e1_sum_az_linear);
e1_sum_az_dB_avg=10.*log10(e1_sum_az_lin_avg);
e2_sum_az_linear=10.^(e2_sum_az./10);
e2_sum_az_lin_avg=mean(e2_sum_az_linear);
e2_sum_az_dB_avg=10.*log10(e2_sum_az_lin_avg);
e3_sum_az_linear=10.^(e3_sum_az./10);
e3_sum_az_lin_avg=mean(e3_sum_az_linear);
e3_sum_az_dB_avg=10.*log10(e3_sum_az_lin_avg);
e4_sum_az_linear=10.^(e4_sum_az./10);
e4_sum_az_lin_avg=mean(e4_sum_az_linear);
e4_sum_az_dB_avg=10.*log10(e4_sum_az_lin_avg);
e5_sum_az_linear=10.^(e5_sum_az./10);
e5_sum_az_lin_avg=mean(e5_sum_az_linear);
e5_sum_az_dB_avg=10.*log10(e5_sum_az_lin_avg);

%  Find peak and average gain for measured EL1 cut
e1_sum_el1_Peak=max(e1_sum_el1);
e2_sum_el1_Peak=max(e2_sum_el1);
e3_sum_el1_Peak=max(e3_sum_el1);
e4_sum_el1_Peak=max(e4_sum_el1);
e5_sum_el1_Peak=max(e5_sum_el1);

e1_sum_el1_linear=10.^(e1_sum_el1./10);
e1_sum_el1_lin_avg=mean(e1_sum_el1_linear);
e1_sum_el1_dB_avg=10.*log10(e1_sum_el1_lin_avg);
e2_sum_el1_linear=10.^(e2_sum_el1./10);
e2_sum_el1_lin_avg=mean(e2_sum_el1_linear);
e2_sum_el1_dB_avg=10.*log10(e2_sum_el1_lin_avg);
e3_sum_el1_linear=10.^(e3_sum_el1./10);
e3_sum_el1_lin_avg=mean(e3_sum_el1_linear);
e3_sum_el1_dB_avg=10.*log10(e3_sum_el1_lin_avg);
e4_sum_el1_linear=10.^(e4_sum_el1./10);
e4_sum_el1_lin_avg=mean(e4_sum_el1_linear);
e4_sum_el1_dB_avg=10.*log10(e4_sum_el1_lin_avg);
e5_sum_el1_linear=10.^(e5_sum_el1./10);
e5_sum_el1_lin_avg=mean(e5_sum_el1_linear);
e5_sum_el1_dB_avg=10.*log10(e5_sum_el1_lin_avg);

%  Find peak and average gain for measured EL2 cut
e1_sum_el2_Peak=max(e1_sum_el2);
e2_sum_el2_Peak=max(e2_sum_el2);
e3_sum_el2_Peak=max(e3_sum_el2);
e4_sum_el2_Peak=max(e4_sum_el2);
e5_sum_el2_Peak=max(e5_sum_el2);

e1_sum_el2_linear=10.^(e1_sum_el2./10);
e1_sum_el2_lin_avg=mean(e1_sum_el2_linear);
e1_sum_el2_dB_avg=10.*log10(e1_sum_el2_lin_avg);
e2_sum_el2_linear=10.^(e2_sum_el2./10);
e2_sum_el2_lin_avg=mean(e2_sum_el2_linear);
e2_sum_el2_dB_avg=10.*log10(e2_sum_el2_lin_avg);
e3_sum_el2_linear=10.^(e3_sum_el2./10);
e3_sum_el2_lin_avg=mean(e3_sum_el2_linear);
e3_sum_el2_dB_avg=10.*log10(e3_sum_el2_lin_avg);
e4_sum_el2_linear=10.^(e4_sum_el2./10);
e4_sum_el2_lin_avg=mean(e4_sum_el2_linear);
e4_sum_el2_dB_avg=10.*log10(e4_sum_el2_lin_avg);
e5_sum_el2_linear=10.^(e5_sum_el2./10);
e5_sum_el2_lin_avg=mean(e5_sum_el2_linear);
e5_sum_el2_dB_avg=10.*log10(e5_sum_el2_lin_avg);

% Compile the peak and average gain values

AzGainSummary=[e1_sum_az_Peak,e1_sum_az_dB_avg;e2_sum_az_Peak,e2_sum_az_dB_avg;...
    e3_sum_az_Peak,e3_sum_az_dB_avg;e4_sum_az_Peak,e4_sum_az_dB_avg;e5_sum_az_Peak,e5_sum_az_dB_avg];
El1GainSummary=[e1_sum_el1_Peak,e1_sum_el1_dB_avg;e2_sum_el1_Peak,e2_sum_el1_dB_avg;...
    e3_sum_el1_Peak,e3_sum_el1_dB_avg;e4_sum_el1_Peak,e4_sum_el1_dB_avg;e5_sum_el1_Peak,e5_sum_el1_dB_avg];
El2GainSummary=[e1_sum_el2_Peak,e1_sum_el2_dB_avg;e2_sum_el2_Peak,e2_sum_el2_dB_avg;...
    e3_sum_el2_Peak,e3_sum_el2_dB_avg;e4_sum_el2_Peak,e4_sum_el2_dB_avg;e5_sum_el2_Peak,e5_sum_el2_dB_avg];

% First "doctor" data points so that very small values do not go below rho_min to avoid artifacts in the polar plots - e.g. values much smaller than rho_min poke on the other side of zero  

% get the number of points in the arrays for each cut
n_az = size(e1_sum_az);
n_az = n_az(1);

n_el1 = size(e1_sum_el1);
n_el1 = n_el1(1);

n_el2 = size(e1_sum_el2);
n_el2 = n_el2(1);

% "Doctor" AZ data points
for n = 1:n_az
    if e1_sum_az(n,1) < rho_min
        e1_sum_az(n,1) = rho_min;
    else e1_sum_az(n,1) = e1_sum_az(n,1);
    end
    if e2_sum_az(n,1) < rho_min
        e2_sum_az(n,1) = rho_min;
    else e2_sum_az(n,1) = e2_sum_az(n,1);
    end
    if e3_sum_az(n,1) < rho_min
        e3_sum_az(n,1) = rho_min;
    else e3_sum_az(n,1) = e3_sum_az(n,1);
    end
    if e4_sum_az(n,1) < rho_min
        e4_sum_az(n,1) = rho_min;
    else e4_sum_az(n,1) = e4_sum_az(n,1);
    end
    if e5_sum_az(n,1) < rho_min
        e5_sum_az(n,1) = rho_min;
    else e5_sum_az(n,1) = e5_sum_az(n,1);
    end
end

% "Doctor" EL1 data points
for n = 1:n_el1
    if e1_sum_el1(n,1) < rho_min
        e1_sum_el1(n,1) = rho_min;
    else e1_sum_el1(n,1) = e1_sum_el1(n,1);
    end
    if e2_sum_el1(n,1) < rho_min
        e2_sum_el1(n,1) = rho_min;
    else e2_sum_el1(n,1) = e2_sum_el1(n,1);
    end
    if e3_sum_el1(n,1) < rho_min
        e3_sum_el1(n,1) = rho_min;
    else e3_sum_el1(n,1) = e3_sum_el1(n,1);
    end   
    if e4_sum_el1(n,1) < rho_min
        e4_sum_el1(n,1) = rho_min;
    else e4_sum_el1(n,1) = e4_sum_el1(n,1);
    end
    if e5_sum_el1(n,1) < rho_min
        e5_sum_el1(n,1) = rho_min;
    else e5_sum_el1(n,1) = e5_sum_el1(n,1);
    end
end

% "Doctor" EL2 data points
for n = 1:n_el2
    if e1_sum_el2(n,1) < rho_min
        e1_sum_el2(n,1) = rho_min;
    else e1_sum_el2(n,1) = e1_sum_el2(n,1);
    end
    if e2_sum_el2(n,1) < rho_min
        e2_sum_el2(n,1) = rho_min;
    else e2_sum_el2(n,1) = e2_sum_el2(n,1);
    end
    if e3_sum_el2(n,1) < rho_min
        e3_sum_el2(n,1) = rho_min;
    else e3_sum_el2(n,1) = e3_sum_el2(n,1);
    end
    if e4_sum_el2(n,1) < rho_min
        e4_sum_el2(n,1) = rho_min;
    else e4_sum_el2(n,1) = e4_sum_el2(n,1);
    end
    if e5_sum_el2(n,1) < rho_min
        e5_sum_el2(n,1) = rho_min;
    else e5_sum_el2(n,1) = e5_sum_el2(n,1);
    end
end

% Plot "doctored" cuts

% plot AZ cut
figure(1);
Azplot(x_phi,e1_sum_az,'r-',[rho_max rho_min rho_div]); hold on;
Azplot(x_phi,e2_sum_az,'b-',[rho_max rho_min rho_div]);
Azplot(x_phi,e3_sum_az,'k-',[rho_max rho_min rho_div]);
%Azplot(x_phi,e4_sum_az,'g-',[rho_max rho_min rho_div]);
%Azplot(x_phi,e5_sum_az,'m-',[rho_max rho_min rho_div]);
%legend('5145 MHz','5147 MHz','5149 MHz','5151 MHz','5153 MHz');
% legend('2450 MHz','2450 MHz','2450 MHz','2450 MHz');
legend('2400 MHz','2450 MHz','2500 MHz');
title('AZ Cut');

% plot EL1 cut
figure(2);
Dirplot(x_th,e1_sum_el1,'r-',[rho_max rho_min rho_div]); hold on;
Dirplot(x_th,e2_sum_el1,'b-',[rho_max rho_min rho_div]);
Dirplot(x_th,e3_sum_el1,'k-',[rho_max rho_min rho_div]);
% Dirplot(x_th,e4_sum_el1,'g-',[rho_max rho_min rho_div]);
% Dirplot(x_th,e5_sum_el1,'m-',[rho_max rho_min rho_div]);
%legend('5150 MHz','5250 MHz','5350 MHz','5725 MHz','5825 MHz');
% legend('2450 MHz','2450 MHz','2450 MHz','2450 MHz');
legend('2400 MHz','2450 MHz','2500 MHz');
title('EL1 (Front-to-Back) Cut');

% plot EL2 cut
figure(3);
Dirplot(x_th,e1_sum_el2,'r-',[rho_max rho_min rho_div]); hold on;
Dirplot(x_th,e2_sum_el2,'b-',[rho_max rho_min rho_div]);
Dirplot(x_th,e3_sum_el2,'k-',[rho_max rho_min rho_div]);
% Dirplot(x_th,e4_sum_el2,'g-',[rho_max rho_min rho_div]);
% Dirplot(x_th,e5_sum_el2,'m-',[rho_max rho_min rho_div]);
%legend('5150 MHz','5250 MHz','5350 MHz','5725 MHz','5825 MHz');
% legend('2450 MHz','2450 MHz','2450 MHz','2450 MHz');
legend('2400 MHz','2450 MHz','2500 MHz');
title('EL2 (Side-to-Side) Cut');

%%%% for Axial Ratio Start %%%%%%
figure(4);
Azplot(x_phi,10.*log10(abs(AR1_az)),'r-',[150 0 5]); hold on;
Azplot(x_phi,10.*log10(abs(AR2_az)),'b-',[150 0 5]);
Azplot(x_phi,10.*log10(abs(AR3_az)),'k-',[150 0 5]);
%Azplot(x_phi,e4_sum_az,'g-',[rho_max rho_min rho_div]);
%Azplot(x_phi,e5_sum_az,'m-',[rho_max rho_min rho_div]);
%legend('5145 MHz','5147 MHz','5149 MHz','5151 MHz','5153 MHz');
% legend('2450 MHz','2450 MHz','2450 MHz','2450 MHz');
legend('5150 MHz','5250 MHz','5350 MHz');
%legend('2400 MHz','2450 MHz','2500 MHz');
title('Axial Ratio AZ Cut');


figure(5);
Dirplot(x_th,10.*log10(abs(AR1_el1)),'r-',[150 0 5]); hold on;
Dirplot(x_th,10.*log10(abs(AR2_el1)),'b-',[150 0 5]);
Dirplot(x_th,10.*log10(abs(AR3_el1)),'k-',[150 0 5]);
% Dirplot(x_th,e4_sum_el1,'g-',[rho_max rho_min rho_div]);
% Dirplot(x_th,e5_sum_el1,'m-',[rho_max rho_min rho_div]);
%legend('5150 MHz','5250 MHz','5350 MHz','5725 MHz','5825 MHz');
% legend('2450 MHz','2450 MHz','2450 MHz','2450 MHz');
legend('5150 MHz','5250 MHz','5350 MHz');
%legend('2400 MHz','2450 MHz','2500 MHz');
title('Axial Ratio EL1 (Front-to-Back) Cut');

figure(6);
Dirplot(x_th,10.*log10(abs(AR1_el2)),'r-',[150 0 5]); hold on;
Dirplot(x_th,10.*log10(abs(AR2_el2)),'b-',[150 0 5]);
Dirplot(x_th,10.*log10(abs(AR3_el2)),'k-',[150 0 5]);
% Dirplot(x_th,e4_sum_el1,'g-',[rho_max rho_min rho_div]);
% Dirplot(x_th,e5_sum_el1,'m-',[rho_max rho_min rho_div]);
%legend('5150 MHz','5250 MHz','5350 MHz','5725 MHz','5825 MHz');
% legend('2450 MHz','2450 MHz','2450 MHz','2450 MHz');
legend('5150 MHz','5250 MHz','5350 MHz');
%legend('2400 MHz','2450 MHz','2500 MHz');
title('Axial Ratio EL1 (Front-to-Back) Cut');
%%%% for Axial Ratio End %%%%%%


