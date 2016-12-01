function tsbe=tsbe1_mmp(dataC,sensorid,calid,start_scan,cond_shift)
% tsbe1_mmp
%   Usage: tsbe=tsbe1_mmp(dataC,sensorid,calid)
%      dataC is output from read_rawdata_mmp as a 2-column vector
%         in counts
%      sensorid is string name of SeaBird temp probe
%      calid is string id of calibration
%      tsbe is temperature in deg C
%      start_scan is the number of the scan to begin keeping data
%      cond_shift is number of scans to take off record end
%   Function: convert raw tsbe data from counts to deg C using
%      the SeaBird algorithm used in 1994.

FR=8192664; % reference freq. of period counter
TAUFR=327680; % number of reference cycles

mmpfolders;
[a, b, c, d, f0]=read_tsbecal_mmp(sensorid, calid);

% convert from counts to frequency in Hz
n=size(dataC,1);
nr0=0;
f=zeros(1,n);

for i=1:n
	f(i)=(dataC(i,1)*FR) / (TAUFR+dataC(i,2)-nr0);
	nr0=dataC(i,2);
end
clear dataC

% convert from frequency to deg C
f=f(start_scan:length(f)-cond_shift);
x=log(f0./f);
tsbe=1./(a+b.*x+c.*x.^2+d.*x.^3) - 273.15;
tsbe=tsbe';
