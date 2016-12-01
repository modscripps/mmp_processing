function obs=obs2_mmp(drop,mmpid)
% obs1_mmp
%   Usage: ob=obs2_mmp(drop,mmpid)
%      drop: drop number (integer)
%      mmpid: string instrument id, e.g. 'mmp3' (optional)
%      obs: scaled to be proportional to Formazin Turbidity Units
%   Function: For mmp1:mmp3 from drops 2262:present, with obs
%     mounted in a 400 Hz sensor port.  Script reads raw obs 
%     output in counts and converts to turbidity units.
%   M.Gregg, 12jul96

% get obs configuration
mmpfolders;
if nargin<2
  mmpid=read_mmpid(drop);
end
[sensorid,electronicsid,filter,fc,scanpos] = read_chconfig_mmp('obs',mmpid,drop);	

% read raw data and convert to volts
obsV=atod1_mmp(read_rawdata_mmp('obs',drop));

% Use electronicsid to set Gain
if strcmp(electronicsid,'1')
	G=4;
elseif strcmp(electronicsid,'2')
	G=15;
elseif strcmp(electronicsid,'3')
	G=54;
else
    G=[];
	disp_str=['obs1_mmp: improper electronicsid for drop ' int2str(drop)];
	disp(disp_str)
end

obs=(1600/G)*obsV;
