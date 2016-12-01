function f = pr_freq_mmp(drop)
% pr_freq_mmp
%   Usage: f=pr_freq_mmp(drop)
%      drop is the drop number (integer)
%		f is the raw pressure data, frequency in kHz 

TAUFR=327680; % number of reference cycles counted

% get pr calibration
mmpfolders;
mmpid=read_mmpid(drop);

% Read reference frequency, FR
fr_calid=read_whichcal_mmp('fr', mmpid,drop);
FR=read_frcal1_mmp(mmpid,fr_calid);

% read raw data, as counts in two columns
rawpr=read_rawdata_mmp('pr',drop);

% convert raw data from counts to frequency in Hz
n=size(rawpr,1);
f=zeros(1,n);
f(1)=(rawpr(1,1)*FR) / (TAUFR+rawpr(1,2)-0);
f(2:n)=(rawpr(2:n,1)*FR) ...
        ./ (TAUFR+rawpr(2:n,2)-rawpr(1:n-1,2));

% convert from frequency to S/m
f=f'./1000; % convert to kHz

