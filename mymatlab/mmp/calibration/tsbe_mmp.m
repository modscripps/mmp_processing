function tsbe=tsbe1_mmp(drop)
% tsbe_mmp
%   Usage: tsbe=tsbe1_mmp(drop)
%      drop is the integer drop number
%      tsbe is the SBE temperature output in deg C
%   Function: read raw tsbe data and convert to deg C

FR=8192664; % reference freq. of period counter
TAUFR=327680; % number of reference cycles

% get dropinfo needed to read calibration
mmpfolders;

mmpid=read_mmpid(drop);
[sensorid,electronicsid,filter,fc,scanpos]=read_chconfig_mmp('tsbe',mmpid,drop);
calid=read_whichcal_mmp('tsbe',sensorid,drop);

% read calibrations for this sensor
[a, b, c, d, f0]=read_tsbecal_mmp(sensorid, calid);

% read raw data as a 2-column vector
dataC=read_rawdata_mmp('tsbe',drop);

% convert from counts to frequency in Hz
n=size(dataC,1);
nr0=0;
f=zeros(1,n);
for i=1:n
	f(i)=(dataC(i,1)*FR) / (TAUFR+dataC(i,2)-nr0);
	nr0=dataC(i,2);
end

% convert from frequency to deg C
x=log(f0./f);
tsbe=1./(a+b.*x+c.*x.^2+d.*x.^3) - 273.15;
tsbe=tsbe';
