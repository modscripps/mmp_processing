function [mmpno, prno, calid, offsetid]=read_pr_config_mmp(drop)

mmpfolders;
source_file=[mmpcals '\pr\pr_config_mmp'];

[fid,message]=fopen(source_file,'r');
if (fid <= 2)
	errstr=['source_file = ' source_file ' : ' message];
	error(errstr);
end

test=0;
while test==0
	firstdrop=fscanf(fid,'%s',1);
	lastdrop=fscanf(fid,'%s',1);
	str_mmpno=fscanf(fid,'%s',1);
	str_prno=fscanf(fid,'%s',1);
	str_calid=fscanf(fid,'%s',1);
	str_offsetid=fscanf(fid,'%s',1);
	if firstdrop==[]
		error('      calid not found')
	else
		firstdrop=str2num(firstdrop);
		lastdrop=str2num(lastdrop);
	end
	if drop >= firstdrop & drop <= lastdrop
		test=1;
		mmpno=str_mmpno; prno=str_prno; calid=str_calid;
		offsetid=str_offsetid;
		break
	end
end

fclose(fid);
