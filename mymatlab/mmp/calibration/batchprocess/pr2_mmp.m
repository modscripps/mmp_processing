function pr=pr2_mmp(drop,zero_shift)
% pr2_mmp
%   Usage: pr=pr2_mmp(drop,zeroshift)
%      drop is the integer drop number
%      zero_shift is the shift to be added to computed pressure.
%      pr is the pressure at the gauge
%   Function: calculate pressure and apply zeroshift for 
%      Paros gauges in mmp1 and mmp2 using  12deg as the
%      nominal temperature of the gauges.  Data are shifted
%	   forward 1 scan to account for the offset produced by
%      period counting, and the data are low-passed with a
%      4-pole Butterworth with a 1 Hz cutoff frequency.

%   M.Gregg, 4jul95: for mmp1 and mmp2 between jul95 and apr96,
%      when they carried Paros gauges 1632 and 1654, resp.
%      6jul96: added forward shift and low-pass filtering.

TAUFR=327680;
PASCAL_PER_PSI=6894.757;
STD_ATMOS=0.101325; % MPa
temp=12;

% read Paros pressure gauge calibration
mmpfolders;
mmpid=read_mmpid(drop);
[sensorid,electronicsid,filter,fc,scanpos] ...
  = read_chconfig_mmp('pr',mmpid,drop);	
calid=read_whichcal_mmp('pr',sensorid,drop);
[C1,C2,C3,D1,D2,T1,T2,T3,T4,T5]= ...
   read_Parospcal2_mmp(sensorid, calid);
C=C1+C2*temp+C3*temp^2;
D=D1+D2*temp;
T0=T1+T2*temp+T3*temp^2+T4*temp^3+T5*temp^4;

% Read reference frequency, FR
fr_calid=read_whichcal_mmp('fr', mmpid,drop);
FR=read_frcal1_mmp(mmpid,fr_calid);

% read rawdata as 2-column array
dataC=read_rawdata_mmp('pr',drop); 

n=length(dataC);

% convert raw data in dataC to frequency in Hz
f=zeros(1,n);
f(1)=(dataC(1,1)*FR) ./ (TAUFR+dataC(1,2)-0);
f(2:n)=(dataC(2:n,1)*FR) ...
        ./ (TAUFR+dataC(2:n,2)-dataC(1:n-1,2));

% convert from frequency to period in microseconds
T = 1e6 ./ f;

% convert from period in micro-seconds to psia
aa=ones(size(T))-T0^2*ones(size(T))./(T.^2);
pr=C*aa .* (ones(size(T)) - D*aa);

% convert from psia to MPa sea pressure
pr=pr*PASCAL_PER_PSI/1e6 - STD_ATMOS;

%Apply 4-pole Butterworth low-pass filter with 1 Hz cutoff
[b,a]=butter(4,1/12.5);
prlp=filtfilt(b,a,pr(2:n));

% Shift data forward one scan to compensate to shift introduced
% by period counting
pr=[prlp(:); NaN];
