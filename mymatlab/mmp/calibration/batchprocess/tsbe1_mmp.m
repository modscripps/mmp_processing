function tsbe=tsbe1_mmp(drop)
%   Usage: tsbe=tsbe1_mmp(drop)
%      drop is the integer drop number
%      tsbe is the SBE temperature output in deg C, except
%        for first word, which is no good.
%   Function: read raw tsbe data and convert to deg C
%
%   M.Gregg, 4jul95, revised to vectorize conversion from
%      counts to frequency
%	7jul96: revised to read calibration of reference frequency
%	   and to shift tsbe one scan forward to compensate for
%      shift produced by period counting.

TAUFR=327680; % number of reference cycles

% get dropinfo needed to read calibration
mmpfolders;

mmpid=read_mmpid(drop);
[sensorid,electronicsid,filter,fc,scanpos]=read_chconfig_mmp('tsbe',mmpid,drop);
calid=read_whichcal_mmp('tsbe',sensorid,drop);

% read calibrations for this sensor
[a, b, c, d, f0]=read_tsbecal_mmp(sensorid, calid);

% Read reference frequency, FR
fr_calid=read_whichcal_mmp('fr', mmpid,drop);
FR=read_frcal1_mmp(mmpid,fr_calid);

% read raw data as a 2-column vector
dataC=read_rawdata_mmp('tsbe',drop);

% convert from counts to frequency in Hz
n=size(dataC,1);
f=zeros(1,n);
f(1)=(dataC(1,1)*FR) / (TAUFR+dataC(1,2)-0);
f(2:n)=(dataC(2:n,1)*FR) ...
         ./ (TAUFR+dataC(2:n,2)-dataC(1:n-1,2));

% convert from frequency to deg C
x=log(f0./f);
tsbe=1./(a+b.*x+c.*x.^2+d.*x.^3) - 273.15;
tsbe=tsbe(:);

% Shift tsbe forward one scan to compensate for shift in
% period counting
n=length(tsbe);
tsbe=[tsbe(2:n); NaN];
