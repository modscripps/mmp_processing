function pr=pr1_mmp1(prV,sensorid,calid)
% pr1_mmp
%   Usage: pr=pr1_mmp1(prV,sensorid,calid) 
%      prV is a vector array of pressure data in volts
%      sensorid & calid are not evaluated in this function
%      pr is low-passed pressure in MPa
%   Function: Converts  mmp pressure data taken with Lucas
%      Schaevitz strain gauge to sea pressure in MPa using
%      manufacturer's linear calibration.


GAMMAp=0.689475729317;
P0=0.101325;

% GAMMAp is the linear calibration cst. P0 is nominal
% atmospheric pressure, which is subtracted from the absolute
% pressure measured by the gauge.

pr=GAMMAp .* x - P0;

% apply lowpass filter
[b,a]=cheby1(9,.5,10/400);
pr=filtfilt(b,a,pr);
