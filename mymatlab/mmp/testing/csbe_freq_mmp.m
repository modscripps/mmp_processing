function f = csbe_freq_mmp(drop)
% csbe_freq_mmp
%   Usage: f=csbe_freq_mmp(drop)
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

