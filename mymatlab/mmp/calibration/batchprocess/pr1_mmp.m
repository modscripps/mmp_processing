function pr=pr1_mmp(drop,zero_shift)
% pr1_mmp
%   Usage: pr=pr1_mmp(drop,zeroshift)
%      drop is the integer drop number
%      zero_shift is the shift to be added to computed pressure.
%      pr is the pressure at the gauge
%   Function: calculate pressure, low-pass, and apply zeroshift if specified.  For
%      Lucas Schaevitz strain gauge in mmp1.

FS_hf=400; % sample rate of hf channels
LPF=3; % 3db cutoff frequency for low-pass filter


pr=read_rawdata_mmp('pr',drop); % read rawdata
pr=atod1_mmp(pr); % convert to volts

% get and apply pressure calibrations
mmpfolders;
mmpid=read_mmpid(drop);
[sensorid,electronicsid,filter,fc,scanpos]=read_chconfig_mmp('pr',mmpid,drop);
calid=read_whichcal_mmp('pr',sensorid,drop);
cal_str=['load ' setstr(39) mmpdatabase ':cal:pr:' calid '.mat' setstr(39)];
eval(cal_str)
pr=polyval(pf,pr)-1.247612293401895e-3; %corr for fit residual at zero pressure

% apply low-pass filter
% calculate lowpass filter coefficients
[b,a]=butter(4,LPF / (FS_hf/2));
pr=filtfilt(b,a,pr);

% if zero_shift is specified, apply to pressure
if nargin>=2
	pr=pr+zero_shift;
end

