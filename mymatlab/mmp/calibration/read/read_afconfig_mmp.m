function [vehicle,afcase,probe]=read_afconfig_mmp(ch,drop)
% read_afconfig_mmp
%   Usage: [vehicle,case,probe]=read_afconfig_mmp(ch,drop)
%      channel is airfoil data channel, e.g. v1
%      drop is sequential drop number for mmp family
%   Function: get airfoil configuration

% Get folder name for config and cal files
mmpfolders;

% Read channel config file
config_file=[mmpconfig '\af\' ch];
[fid,message]=fopen(config_file,'r');
if (fid <= 2)
	errstr=['config_file = ' config_file ' : ' message];
	error(errstr);
end
test=0;
while test==0
	% Read a line in the config file
	firstdrop=fscanf(fid,'%s',1);
	lastdrop=fscanf(fid,'%s',1);
	vehicle=fscanf(fid,'%s',1);
	afcase=fscanf(fid,'%s',1);
	probe=fscanf(fid,'%s',1);
	if isempty(firstdrop)
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
	vehicle=[]; afcase=[]; probe=[];
end
