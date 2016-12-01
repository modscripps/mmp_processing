function vac=vac1_mmp(ch,drop,ss)
% Usage: vac=vac1_mmp(ch,drop,ss);
%  inputs:
%    ch: string name of data channel, vac1 or vac2
%    drop: integer drop number
%    ss: vector of sound speeds, one per scan
% Function: to convert data from the mmp3 acoustic current meter
%  from counts to m/s.  
% M.Gregg, 13jul96: implemented with nominal values for the
%   scaling constant and the separation between sensors.
% D.Winkel, jun2000: fixed a few bugs in sound speed code 'if nargin<3 ...'

F_ACM=2.75e6; % frequency of acoustic transmission
D_ACM=0.15; % separation between acoustic transducers
K_ACM=0.94; % scaling constant

% Read raw data and convert from counts to volts
vac_raw=read_rawdata_mmp(ch,drop);
vac_raw=atod1_mmp(vac_raw);
n=length(vac_raw);

% Average the two values in each scan
vac=(vac_raw(1:2:n)+vac_raw(2:2:n))/2;
nva=length(vac);

% Get sound speed if it is not supplied
if nargin<3
   ss=1500*ones(nva,1);
   clear sal
   [pr_thetasd,temp,ts,sal,sg]=get_thetasd1_mmp(drop,'t','','s','');
   if exist('pr_thetasd') & exist('temp') & exist('sal')
      if length(sal)==nva
         ss=sw_svel(sal,temp,pr_thetasd);
      end 
   end
end

vac=0.025*vac*K_ACM.*ss.^2/(F_ACM*D_ACM);
