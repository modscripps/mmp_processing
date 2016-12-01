function [tsbe_lp,csbe_lp]=lowpass_sbe_mmp(temp,cond)
% lowpass_sbe_mmp
%   Usage: [tsbe_lp,csbe_lp]=lowpass_sbe_mmp(temp,cond);
%      cond is a vector array of unfiltered csbe data
%      temp is a matching array of unfiltered tsbe data
%      csbe_lp is low-passed conductivity
%      tsbe_lp is low-passed temperature
%   Function: apply same low-pass filter to SeaBird temp and cond

% design and run low-pass butterworth filter
Wp=3/12.5; Ws=5/12.5; Rp=0.5; Rs=20;
[n,Wn]=buttord(Wp,Ws,Rp,Rs);
[b,a]=butter(n,Wn);
csbe_lp=filtfilt(b,a,cond);
tsbe_lp=filtfilt(b,a,temp); 
