function [f,P]=panchev_voltf_mmp(drop,ch,w)
% panchev_voltf_mmp
%   Usage: [f_panchev,P_panchev]=panchev_voltf_mmp(drop,ch,w);
%      drop is the mmp drop number
%      ch is the airfoil data channel, v1 or v2
%      w is the fall rate in m/s
%      k is an array of wavenumbers in cpm
%      Ppanchev is a matching array of Panchev universal shear
%         spectra versus wavenumber
%      f is an array of frequencies
%      P is an array of universal transverse shear spectra
%   Function: Convert Panchev spectra to recorded spectra in
%      volts^2 Hz^-1

G=9.81;


% load arrays with panchev spectra, Ppanchev, and wavenumbers, k
mmpfolders;
source_file=[matlabdisk '\mymatlab\toolbox\generaltrf\panchev.mat'];
str=['load ' setstr(39) source_file setstr(39)];
eval(str)

% convert Ppanchev shear spectrum to velocity spectrum
Ppanchev=Ppanchev./(2*pi*k).^2;

% convert wavenumber to frequency
f=k*w; clear k

% get parameters for sensor transfer function
mmpid=read_mmpid(drop); 
[scanid,voffsetid] = read_config_mmp(mmpid,drop);
[sensorid,electronicsid,filter,fc,scanpos] = read_chconfig_mmp(ch,mmpid,drop);	
calid=read_whichcal_mmp('af',sensorid,drop);
[Sv,Cs]=read_af_cal(sensorid, calid);

% obtain the total transfer function
str1=['helectronics=helectronics_' electronicsid '(Cs,f);'];
eval(str1); % evaluate electronics transfer function
str1=['[hfilt,pfilt]=' filter '(f,fc);'];
eval(str1)  % evaluate anti-alias filter transfer fcn
h_freq=helectronics .* hfilt;
htotal=(Sv*w/(2*G))^2 * h_freq .* haf_oakey(f,w);

P=Ppanchev.*htotal/w;
