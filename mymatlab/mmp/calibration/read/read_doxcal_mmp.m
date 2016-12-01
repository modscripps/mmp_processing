function [soc,boc,offset,tcor,pcor,tau]=read_doxcal_mmp(sensorid, calid)
% read_doxcal_mmp
%   Usage:
%      [soc,boc,offset,tcor,pcor,tau]=read_doxcal_mmp(sensorid, calid);
%         sensorid is string with serial no for SeaBird dis oxygen
%         calid is string identifying which calibration to use
%         soc,boc,offset,tcor,pcor,tau are calibration coeffs
%   Function:
%      Read calibration coef for Sea-Bird oxygen (SBE43).

mmpfolders;
source_file=fullfile(mmpdatabase,'cal','dox', sensorid);

fid=fopen(source_file,'r');
if (fid <= 2)
	msg=['read_doxcal_mmp: file missing for sensorid=' sensorid ...
	     ' and calid=' calid];
	disp(msg)
	test=0;
else 
	test=1;
	while test==1
		id=fscanf(fid,'%s',1);
		soc=fscanf(fid,'%s',1);
		boc=fscanf(fid,'%s',1);
		offset=fscanf(fid,'%s',1);
		tcor=fscanf(fid,'%s',1);
		pcor=fscanf(fid,'%s',1);
		tau=fscanf(fid,'%s',1);
		if isempty(id)==1
			msg=['read_doxcal_mmp: calid=' calid ' not found in ' ...
			     'cal file for ' sensorid];
			disp(msg)
			break
		elseif strcmp(id,calid)==1
			test=2;
			break
		end
	end
end
fclose(fid);

if test==2
	soc=str2num(soc); boc=str2num(boc); offset=str2num(offset);
	tcor=str2num(tcor); pcor=str2num(pcor); tau=str2num(tau);
end
