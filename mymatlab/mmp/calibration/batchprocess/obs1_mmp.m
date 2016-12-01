function ftu=obs1_mmp(drop,mmpid)
% obs1_mmp
%   Usage: ob=csbe1_mmp(drop)
%      drop: drop number (integer)
%      mmpid: string instrument id, e.g. 'mmp3' (optional)
%      ftu is proportional to formazin turbidity units
%   Function: read raw obs output in counts and covert to
%      turbidity units, for obs in mmp1:mmp2 from drops
%      2099:2261.

%   M.Gregg, 4jul95

% get obs configuration
mmpfolders;
if nargin<2
  mmpid=read_mmpid(drop);
end
[sensorid,electronicsid,filter,fc,scanpos] = read_chconfig_mmp('obs',mmpid,drop);	

% read raw data and convert to volts
obsV=read_rawdata_mmp('obs',drop);
obsV=atod1_mmp(obsV);

% Use electronicsid to set Gain
if strcmp(electronicsid,'1')
	Gobs=4;
elseif strcmp(electronicsid,'2')
	Gobs=15;
elseif strcmp(electronicsid,'3')
	Gobs=54;
else
    Gobs=[];
	disp_str=['obs1_mmp: improper electronicsid for drop ' int2str(drop)];
	disp(disp_str)
end

ftu=(1600/Gobs)*obsV;
