function csbeF=csbe_freq1_mmp(drop)
% csbe_freq1_mmp
%   Usage: csbeF=csbe_freq1_mmp(drop)
%      drop is the integer drop number
%      csbeF is the SBE conductivity output in Hz
%   Function: read raw csbe data and convert to frequency in Hz

FR=8192664; % reference freq. of period counter
TAUFR=327680; % number of reference cycles

% get dropinfo needed to read calibration
mmpfolders;

mmpid=read_mmpid(drop);
[sensorid,electronicsid,filter,fc,scanpos]=read_chconfig_mmp('csbe',mmpid,drop);
calid=read_whichcal_mmp('csbe',sensorid,drop);

% read calibrations for this sensor
[a, b, c, d, m]=read_csbecal_mmp(sensorid, calid);

% read raw data as a 2-column vector
dataC=read_rawdata_mmp('csbe',drop);

% convert from counts to frequency in Hz
n=size(dataC,1);
nr0=0;
f=zeros(1,n);
for i=1:n
	csbeF(i)=(dataC(i,1)*FR) / (TAUFR+dataC(i,2)-nr0);
	nr0=dataC(i,2);
end
