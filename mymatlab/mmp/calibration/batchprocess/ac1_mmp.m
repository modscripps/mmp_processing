function [hout,pout]=ac1_mmp(drop,p,ss)
% Usage: [hout,pout]=ac1_mmp(drop,p,ss);
%  inputs:
%    drop: integer drop number
%    p: pressure, use pr_scan, optional
%    ss: sound speed profile, optional
%  outputs:
%    hout: height of altimeter above bottom, meters
%    pout: pressure at the pressure port, or gauge pressure
% Function: Read altimeter channel (ac), retain data where
%   value is updated, shift data to compensate for delay in
%   updating recorded values, and convert to height.  If sound 
%   speed isn't available, 1500  m/s is used during conversion.
%   Heights are corrected for the inclination of of the 
%   altimeter  relative to the MMP pressure tube.
% M.Gregg, 12jul96

AC_DELAY=6; % # scans ac is delayed relative to other channels
NOISE=5e2; % threshold for noise spikes
AC_CLOCK=128000;
NO_ECHO=-32768;
PULSE_INT=5;  % number of scans between pulses 

% Read raw data, which are in counts
ac=read_rawdata_mmp('ac',drop);
if ~isempty(ac)
  nac=length(ac);
  %
  % set presssure & soundspeed if not input
  if nargin<2
    p=load_pr_mmp(drop);
    if ~exist('p')
      disp_str=['ac1_mmp: no pressure record for drop ' int2str(drop)];
	  disp(disp_str)
	  break
    end
  end
  if nargin<3
    [pr_thetasd,temp,ts,sal,sg]=get_thetasd1_mmp(drop,'t','','s','');
    if exist('pr_thetasd') & exist('temp') & exist('sal')
      if length(sal)==nac
	    ss=sw_svel(sal,temp,pr_thetasd);
	    ss=[ss(AC_DELAY+1:nac); NaN*ones(AC_DELAY,1)]; % shift as below
	  else
	    ss=1500*ones(nac,1);
	  end 
    else
      ss=1500*ones(nac,1);
    end
  end
  %
  % Shift data forward to align altimeter with pressure, to
  % correct for offset introduced by the delay in updating
  % the ac channel
  ac=ac(:);
  ac=[ac(AC_DELAY+1:nac); NaN*ones(AC_DELAY,1)];
  %
  % Identify scans where signal is updated and keep those only 
  dac=diff(ac);
  iac=find(dac~=0)+1;
  ac2=ac(iac); p2=p(iac); ss2=ss(iac);
  %
  % Set no-echo values to NaNs
  ino=find(ac==NO_ECHO);
  if ~isempty(ino)
    ac2(ino)=NaN*ones(size(ino));
  end
  %
  % Compute height from ac counts
  h=(ss2.*ac2)/(2*AC_CLOCK);
  %
  % Find improbable values and remove
  ii=find(h>-1);
  hout=h(ii); pout=p2(ii);
  %
  % Read channel configuration, where sensor tilt, relative to
  % mmp chassis, is put under sensorid, in degrees.
  mmpid=read_mmpid(drop);
  [tilt,eid,f,fc,scanpos]=read_chconfig_mmp('ac',mmpid,drop);
  %
  if ~isempty(tilt)
    tilt=str2num(tilt);
    hout=hout*cos(pi*tilt/180);
  end
else
  hout=[]; pout=[];
end
