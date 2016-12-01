function [afcase,case_config,Sv,Cs]=get_afinfo_mmp(ch,drop)
% get_afinfo_mmp
%   Usage: [afcase,case_config,Sv,Cs]=get_af_cal('ch',drop)
%      ch is airfoil data channel, e.g. v1 or v1
%      drop is sequential drop number for mmp family
%   Function: get airfoil case number & its config & probe cals

% declare error if ch is not v1 or v2
if strcmp(ch,'v1')~=1 & strcmp(ch,'v2')~=1
	error('   improper channel specification')
end


[vehicle,afcase,probe]=read_afconfig_mmp(ch,drop);
afcase_config=read_afcase_config(afcase,drop);
calid=read_afwhichcal_mmp(probe,drop);
[Sv,Cs]=read_afcal_mmp(probe,calid);
