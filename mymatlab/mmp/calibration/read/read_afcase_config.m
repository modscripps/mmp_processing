function case_config=read_afcase_config(case,drop)
% read_af_caseconfig
%   Usage: case_config=read_afcase_config('case',drop)
%      case is airfoil sensor case, e.g. af1
%      drop is sequential drop number for mmp family
%   Function: get configuration number for airfoil case

% Get folder name for config and cal files
mmpfolders;

% Read channel config file
config_file=[mmpconfig '\af\' case];
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
	case_config=fscanf(fid,'%s',1);
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
	case_config=[];
end
