function calid=read_afwhichcal_mmp(probe,drop)
% read_afwhichcal_mmp
%   Usage: calid=read_whichafcal_mmp('probe',drop)
%      probe is the number of the airfoil probe, e.g. 115
%      drop is the sequential drop number
%		calid=[] if correct drop range is not found
%   Function: reads calibration id for a given probe and drop

% Get folder name for config and cal files
mmpfolders;

% Read channel config file
config_file=[mmpcal '\af\af_' probe '_whichcal'];
[fid,message]=fopen(config_file,'r');
if (fid <= 2)
	errstr=['config_file = ' config_file ' : ' message];
	error(errstr);
end

test=0;
drop=num2str(drop);

while test==0
	% Read a line in the config file
	firstdrop=fscanf(fid,'%s',1);
	lastdrop=fscanf(fid,'%s',1);
	calid=fscanf(fid,'%s',1);
	if firstdrop==[]
		error('      calid not found')
	else
		firstdrop=str2num(firstdrop); lastdrop=str2num(lastdrop);
	end
	if drop >= firstdrop & drop <= lastdrop
		test=1;
	end
end
fclose(fid);

if test~=1
	calid=[];
end
