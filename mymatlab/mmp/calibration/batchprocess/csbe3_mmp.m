function csbe=csbe3_mmp(drop,tsbe,pr_tsbe,cond_shift)
% csbe3_mmp
%   Usage: csbe=csbe3_mmp(drop,tsbe,pr_tsbe,cond_shift)
%      drop is the drop number (integer)
%      tsbe is the SeaBird temperature (vector), in deg C
%      pr_tsbe is the temperature (vector) at the tsbe sensor
%	   cond_shift: # pts to shift csbe forward relative to tsbe
%      csbe is conductivity in S/m
%   Function: convert raw csbe data from counts to S/m using
%      the SeaBird algorithm used in 1994.  All raw data are used.
%   M.Gregg, 4jul95 revised to vectorize frequency calculation
%            9jul96, revised to read clock frequencies of
%                    individual mmp vehicles;
%           June 2014, revised from csbe2_mmp.m to use SeaBird's
%               recommended 'ghij' coeffs and formula - dave w
 
TAUFR=327680; % number of reference cycles counted
CPcor = -9.57e-8;
CTcor = 3.25e-6;

% get csbe calibration
mmpfolders;
mmpid=read_mmpid(drop);
[sensorid,electronicsid,filter,fc,scanpos] = read_chconfig_mmp('csbe',mmpid,drop);	
calid=read_whichcal_mmp('csbe',sensorid,drop);
% read ghij coeffs in same order as older abcdm values, convert later
[a, b, c, d, m]=read_csbecal_mmp(sensorid, calid); % (m is not used)

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

g=a; h=b; i=c; j=d; % assign conventional names to coeffs now
csbe = (g+f.*f.*(h+f.*(i+j.*f))) ./ ...
    (10*(1+CTcor.*tsbe+CPcor.*(pr_tsbe*100))); 

% Shift csbe forward one scan to compensate for shift in
% period counting and additional scans for the delay in
% the plumbing
n=length(csbe);
csbe=[csbe(2+cond_shift:n); NaN*ones(1+cond_shift,1)];
