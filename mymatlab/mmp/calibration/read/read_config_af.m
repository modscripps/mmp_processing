function [vehicle,case,probe]=read_afconfig_mmp(ch,drop)
% read_afconfig_mmp
%   Usage: [vehicle,case,probe]=read_config_af('ch',drop)
%      ch is airfoil data channel, e.g. v1 or v1
%      drop is sequential drop number for mmp family
%   Function: get airfoil config and probe cals

% declare error if ch is not v1 or v2
if strcmp(ch,'v1')~=1 & strcmp(ch,'v2')~=1
	error('   improper channel specification')
end

% Get folder name for config and cal files
mmpfolders;

% Read channel config file
config_file=[mmpconfig '\af\' ch];
[fid,message]=fopen(config_file,'r');
if (fid <= 2)
	errstr=['config_file = ' config_file ' : ' message];
	error(errstr);
end s
test=0;
while test==0
	% Read a line in the config file
	firstdrop=fscanf(fid,'%s',1);
	lastdrop=fscanf(fid,'%s',1);
	vehicle=fscanf(fid,'%s',1);
	case=fscanf(fid,'%s',1);
	probe=fscanf(fid,'%s',1);
	if firstdrop==[]
		error('      config not found')
	else
		firstdrop=str2num(firstdrop);
		lastdrop=str2num(lastdrop);
	end
	if drop >= firstdrop & drop <= lastdrop
		test=1;
	end
end
fclose(fid);

if test~=1
	vehicle=[]; case=[]; probe=[];
end
