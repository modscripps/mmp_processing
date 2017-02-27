function csbe=csbe1_mmp(dataC,sensorid,calid,T,p,start_scan,cond_shift)
% csbe1_mmp
%   Usage: csbe=csbe1_mmp(dataC,sensorid,calid)
%      dataC is output from read_rawdata_mmp as a 2-column vector
%         in counts
%      sensorid is string name of SeaBird cond probe
%      calid is string id of calibration
%      csbe is conductivity in S/m
%   Function: convert raw csbe data from counts to S/m using
%      the SeaBird algorithm used in 1994.

FR=8192664; % reference freq. of period counter
TAUFR=327680; % number of reference cycles

mmpfolders;
[a, b, c, d, m]=read_csbecal_mmp(sensorid, calid);

% convert from counts to frequency in Hz
n=size(dataC,1);
nr0=0;
f=zeros(1,n);
for i=1:n
	f(i)=(dataC(i,1)*FR) / (TAUFR+dataC(i,2)-nr0);
	nr0=dataC(i,2);
end
clear dataC

% convert from frequency to S/m
f=f(start_scan:length(f)-cond_shift);
f=f'./1000;
csbe=(a.*f.^m+b.*f.^2+c+d.*T)./(10.*(1-9.57e-6.*p));
