function [a,b,c,d,f0]=read_csbecal_mmp(probe,drop)
% read_csbecal_mmp
%   Usage: [a,b,c,d,m]=read_csbecal_mmp('probe',drop)
%      probe is the serial number of the SeaBird cond sensor
%      calid is the string calibration id, e.g. 21apr93
%      a,b,c,d,f0 are numbers containing calibration constants
%   Function: read calibration csts for Sea-Bird cond.

% Get folder name for config and cal files
mmpfolders;

% Read whichcal file to get calid for drop
whichcal_file=[mmpdatabase '\cal\csbe\whichcal_' probe];
fid1=fopen(whichcal_file,'r');
if (fid1 <= 2)
	msg0=['read_csbecal_mmp: whichcal_' probe ' not found'];
	disp(msg0)
	test=0;
	break
else
	test=1;
	while test==1
		% Read a line in the whichcal file
		firstdrop=fscanf(fid1,'%s',1);
		lastdrop=fscanf(fid1,'%s',1);
		calid=fscanf(fid1,'%s',1);
		if isempty(firstdrop)==1
			msg1=['read_csbecal_mmp: drop = ' longint2str(drop) ...
				  ' not found in whichcal_' probe];
			disp(msg1)
			break
		else
			firstdrop=str2num(firstdrop);
			lastdrop=str2num(lastdrop);
			if firstdrop<=drop & lastdrop>=drop
				test=2; % found proper drop range
				break;
			end
		end
	end
	fclose(fid1);
end

% Read csbe cal file if a calid was found in the whichcal file
if test==2
	cal_file=[mmpdatabase '\cal\csbe\' probe];
	fid2=fopen(cal_file,'r');
	if (fid2 <= 2)
		msg2=['read_csbecal_mmp: cal file not found for ' ...
		      'probe = ' probe ' and calid = ' calid];
		disp(msg2);
		test=0;
	else
		while test==2
			% Read a line in the cal file
			id=fscanf(fid2,'%s',1);
			a=fscanf(fid2,'%s',1);
			b=fscanf(fid2,'%s',1);
			c=fscanf(fid2,'%s',1);
			d=fscanf(fid2,'%s',1);
			f0=fscanf(fid2,'%s',1);
			if isempty(id)==1
		 		msg2= ['read_csbecal_mmp: cal not found for calid = ' ...
		        		calid ' and probe = ' probe];
				disp(msg2)
				break
			elseif strcmp(id,calid)
				test=3; % proper calid was found
			end
		end
	end
	fclose(fid2);
end

if test==3
	a=str2num(a); b=str2num(b); c=str2num(c); d=str2num(d);
	f0=str2num(f0);
end


