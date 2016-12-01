function csbe=csbe2_mmp(drop,tsbe,pr_tsbe,cond_shift)
% csbe1_mmp
%   Usage: csbe=csbe2_mmp(drop,T,p)
%      drop is the drop number (integer)
%      tsbe is the SeaBird temperature (vector), in deg C
%      pr_tsbe is the temperature (vector) at the tsbe sensor
%	   cond_shift: # pts to shift csbe forward relative to tsbe
%      csbe is conductivity in S/m
%   Function: convert raw csbe data from counts to S/m using
%      the SeaBird algorithm used in 1994.  All raw data are used.
%   M.Gregg, 4jul95 revised to vectorize frequency calculation
%            9jul96, revised to read clock frequencies of
%                    individual mmp vehicles
 
TAUFR=327680; % number of reference cycles counted

% get csbe calibration
mmpfolders;
mmpid=read_mmpid(drop);
[sensorid,electronicsid,filter,fc,scanpos] = read_chconfig_mmp('csbe',mmpid,drop);	
calid=read_whichcal_mmp('csbe',sensorid,drop);
[a, b, c, d, m]=read_csbecal_mmp(sensorid, calid);

% Read reference frequency, FR
fr_calid=read_whichcal_mmp('fr', mmpid,drop);
FR=read_frcal1_mmp(mmpid,fr_calid);

% read raw data, as counts in two columns
rawcsbe=read_rawdata_mmp('csbe',drop);

% convert raw data from counts to frequency in Hz
n=size(rawcsbe,1);
f=zeros(1,n);
f(1)=(rawcsbe(1,1)*FR) / (TAUFR+rawcsbe(1,2)-0);
f(2:n)=(rawcsbe(2:n,1)*FR) ...
        ./ (TAUFR+rawcsbe(2:n,2)-rawcsbe(1:n-1,2));

% convert from frequency to S/m
f=f'./1000; % convert to kHz

csbe=(a.*f.^m+b.*f.^2+c+d.*tsbe)./(10.*(1-9.57e-6.*pr_tsbe));

% Shift csbe forward one scan to compensate for shift in
% period counting and additional scans for the delay in
% the plumbing
n=length(csbe);
csbe=[csbe(2+cond_shift:n); NaN*ones(1+cond_shift,1)];
