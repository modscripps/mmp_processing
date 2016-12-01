function [hout,pout]=get_hofp2G_mmp(drop,ch,p,ss);
% Usage: [hout,pout]=get_hofp2G_mmp(drop,ch,p,ss);
%  inputs:
%    drop: integer drop number
%		 ch: channel (optional) The channel one wants the pressure offset to.  
%        If not specified, pressure and height at the altimeter is returned.
%		 p:	pr_scan, at pressure sensor (optional - will load if not given)
%		 ss: sound speed (optional - will load and calculate if not given)
%  outputs:
%    hout: height of altimeter (or 'ch' sensor) above bottom  [m]
%    pout: pressure at altimeter (or 'ch' sensor)  [MPa]
% Function: Read altimeter channel (ac), retain data where
%   value is updated, shift data to compensate for delay in
%   updating recorded values, and convert to height.  If sound 
%   speed isn't available, 1500  m/s is used during conversion.
%   Heights are corrected for the inclination of the 
%   altimeter  relative to the MMP pressure tube (but not for mmp tilt).
%
% This function doesn't update mmplog
% 
%	J. MacKinnon Oct 10, 1996 ;  revised slightly, jun-2000 D. Winkel

AC_DELAY=6; % # scans ac is delayed relative to other channels
NOISE=5e2; % threshold for noise spikes
AC_CLOCK=128000;
NO_ECHO=-32768;
PULSE_INT=5;  % number of scans between pulses 
%% Not included is an offset (0.08 m??), associated with the 0.1-ms
%	phase delay in the altimeter electronics.  For AMP, the value used is:
%H_OFFSET=0.22; % observed height when AMP14430 hit bottom
H_OFFSET = 0.00;

mmpfolders
cruise=read_cruises_mmp(drop);
mmpid=read_mmpid(drop);
hout=[]; pout=[];

[sensorid,electronicsid,filter,fc,scanpos] = read_chconfig_mmp('ac',mmpid,drop);
if isempty(scanpos)
   disp_str=['  get_hofp2G_mmp: no scanpos for drop ' int2str(drop) ...
         ' in config\' mmpid '\ac'];
   disp(disp_str)
   return
end

% Read raw data, which are in counts
ac=read_rawdata_mmp('ac',drop);
if ~isempty(ac)
   nac=length(ac);
   % refer height and pressure to altimeter if no other channel specified
   if nargin < 2
      ch = 'ac';
   end
   % load pressure file if not supplied
   if nargin<3
      file_name=[procdata '\' cruise '\' 'pr' '\' 'pr' int2str(drop) '.mat']
      if exist(file_name)==2
         load(file_name);
         p = pr_scan;
      else
         disp_str=['get_hofp2_mmp: ' file_name ' does not exist']
         error(disp_str);
      end
   end
	% compute sound speed profile if none supplied  
   if nargin<4
      ss=1500*ones(nac,1);
      [pr_thetasd,temp,sal]=salinity2_mmp(drop);
      if exist('pr_thetasd') & exist('temp') & exist('sal')
         if length(sal)==nac
            ss=sw_svel(sal,temp,pr_thetasd);
         end 
      end	
   end
   %
   % Shift data upward to correct fo 6 scan delay in updating
   % altimeter readings (i.e., synchronize timing of ac to scan#)
   ac=[ac(AC_DELAY+1:nac); NaN*ones(AC_DELAY,1)];
   if AC_DELAY>=1
      ac(end-AC_DELAY+1:end)=[];
      p(end-AC_DELAY+1:end)=[]; ss(end-AC_DELAY+1:end)=[];
   end
   %
   % Identify scans where signal is updated and keep those only 
   dac=diff(ac);
   iac=find(dac~=0)+1;
   if isempty(iac) | size(p,1) ~= size(ac,1)
      pout = []; hout = [];
      warning(['hofp2G: ' int2str(drop) ' has empty iac or size(p)~=size(ac)']);
      return
   end
   ac2=ac(iac); p2=p(iac); ss2=ss(iac);
   % Revision: compute avg ss to end of record; better approx than using ss at
   %	mmp depth (still refered to T,C sensors, but close enough) - D Winkel
   for ic=1:length(ss2)
      ss2(ic) = nanmean(ss2(ic:end));
   end
   % Set no-echo values to NaNs
   ino=find(abs((ac2-NO_ECHO)/NO_ECHO) < 1e-6);
   if ~isempty(ino)
      ac2(ino) = NaN;
   end
   %
   % Compute height from ac counts
   h=(ss2.*ac2)/(2*AC_CLOCK);
   %
   % Find improbable values and remove; hout,pout are at altimeter
   if length(find(h>-1))<3
      pout = []; hout = [];
      warning(['hofp2G: ' int2str(drop) ' has too few altim values']);
      return
   end
   ii=find(h>-1 | isnan(h));
   hout = h(ii);
   pout = pr_offset1_mmp(drop,'ac',p2(ii));
   %
   % Read channel configuration, where sensor tilt, relative to
   % mmp chassis, is put under sensorid (3rd column), in degrees.
   mmpid=read_mmpid(drop);
   [tilt,eid,f,fc,scanpos]=read_chconfig_mmp('ac',mmpid,drop);
   %
   if ~isempty(tilt)
      tilt=str2num(tilt);
      hout=hout*cos(pi*tilt/180);
   end
   hout = hout - H_OFFSET;
end

% if data were found, offset from altimeter to requested sensor (i.e., channel)
if ~isempty(pout) & ~isempty(hout)
   if ~strcmp(ch,'ac')
      pa = pr_offset1_mmp(drop,'ac',[1 2]);
      px = pr_offset1_mmp(drop,ch,[1 2]);
      dp = px(1)-pa(1);
      pout = pout + dp;
      hout = hout - (dp*100);
   end
end

