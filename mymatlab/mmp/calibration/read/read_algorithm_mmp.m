function algorithm = read_algorithm_mmp(ch,drop)% read_algorithm_mmp:%   Usage: algorithm = read_algorithm_mmp(ch,drop)%   Function: Returns basic processing algorithm for ch & drop% 4jul96: revised to read algorithm file by mmpid, M.Gregg % determine which config file to readmmpfolders;mmpid=read_mmpid(drop);algorithm_file=[mmpdatabase filesep 'algorithm' filesep mmpid filesep ch];[fid,message]=fopen(algorithm_file,'r');if (fid <= 2)	errstr=['algorithm_file = ' algorithm_file ' : ' message];	error(errstr);endtest=0;while test==0	% Read a line in the algorithm file	firstdrop=fscanf(fid,'%s',1);	lastdrop=fscanf(fid,'%s',1);	algorithm=fscanf(fid,'%s',1);	if isempty(firstdrop)		msg=['read_algorithm_mmp: algorithm not found for ' ...		      'ch = ' ch ' and drop=' drop];		disp(msg);		break;	else		firstdrop=str2num(firstdrop);		lastdrop=str2num(lastdrop);	end	if drop >= firstdrop & drop <= lastdrop		test=1;	endendfclose(fid);if test~=1	algorithm=[];end