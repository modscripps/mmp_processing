function [Sv,Cs]=read_afcal_mmp(probe,calid)
% read_afcal_mmp
%   Usage: [Sv,Cs]=read_afcal_mmp('probe','calid')
%      probe is the number of the airfoil probe, e.g. 115
%      calid is the calibration date, e.g. 02jan93
%   Function: read calibration constants for given af probe
%      and drop

% Get folder name for config and cal files
mmpfolders;

% Read channel config file
config_file=[mmpcal '\af\af_' probe '_cal'];
[fid,message]=fopen(config_file,'r');
if (fid <= 2)
	errstr=['config_file = ' config_file ' : ' message];
	error(errstr);
end
test=0;
while test==0
	% Read a line in the config file
	calid_file=fscanf(fid,'%s',1);
	Sv=fscanf(fid,'%s',1);
	Cs=fscanf(fid,'%s',1);
	if calid_file==[]
		error('      config not found')
	end
	if strcmp(calid_file,calid)
		test=1;
	end
end
fclose(fid);

if test==1
	Sv=str2num(Sv); Cs=str2num(Cs);
else
	Sv=NaN; Cs=NaN;
end
