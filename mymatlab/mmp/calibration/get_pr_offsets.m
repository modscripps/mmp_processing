function get_pr_offsets(ch,drop)
% [Sv,Cs]=get_af_cal('ch',drop)

% declare error if ch is not v1 or v2
if strcmp(ch,'v1')~=1 & strcmp(ch,'v2')~=1
	error('   improper channel specification')
end

mmpfolders;

% Read config file to get probe number
config_file=[HD '\probecals\af\af_config_mmp']; 

[fid,message]=fopen(config_file,'r');
if (fid <= 2)
	errstr=['config_file = ' config_file ' : ' message];
	error(errstr);
end 

test=0;
while test==0
	firstdrop=fscanf(fid,'%s',1);
	lastdrop=fscanf(fid,'%s',1);
	v1probe=fscanf(fid,'%s',1);
	v2probe=fscanf(fid,'%s',1);
	if firstdrop==[]
		error('      calid not found')
	else
		firstdrop=str2num(firstdrop);
		lastdrop=str2num(lastdrop);
	end
	if drop >= firstdrop & drop <= lastdrop
		test=1;
		if strcmp(ch,'v1')
			probe=v1probe;
		else
			probe=v2probe;	
		end
	end
end
fclose(fid);

% if probe is not NaN, meaning no probe installed, get calid
if strcmp(probe,'NaN')
	Sv=NaN; Cs=NaN;
else	
	% Read "af_probe_whichcal" to determine which cal to use
	% for this drop 
	whichcal_file=[HD '\probecals\af\af_' probe '_whichcal'];
	[fid,message]=fopen(source_file,'r');
	if (fid <= 2)
		errstr=['source_file = ' source_file ' : ' message];
		error(errstr);
	end 

	test=0;
	while test==0
		firstdrop=fscanf(fid,'%s',1);
		lastdrop=fscanf(fid,'%s',1);
		calid=fscanf(fid,'%s',1);
		if firstdrop==[]
			error('      calid not found')
		elseif strcmp(id,calid)==1
			test=1;
			Sv=str2num(Sv); Cs=str2num(Cs);
			break
		else
			Sv=[]; Cs=[];
		end
	end
end
fclose(fid);
