function Sa=read_Sa1_mmp(sensorid, calid)
%   Usage:
%      Sa=read_Sa1_mmp(sensorid, calid);
%         sensorid: string with the accelorometer serial number
%         calid: string identifying which calibration to use
%         Sa: accelerometer sensitivity, mV/g
%   Function:
%      Read the accelerometer sensitivity
% M.Gregg, 24jul96

mmpfolders;
source_file=[mmpdatabase '\cal\accel\' sensorid];

fid=fopen(source_file,'r');
if (fid <= 2)
	msg=['read_accelg1_mmp: file missing for sensorid=' sensorid ...
	     ' and calid=' calid];
	disp(msg)
	test=0;
else 
	test=1;
	while test==1
		id=fscanf(fid,'%s',1);
		Sa=fscanf(fid,'%s',1);
		if isempty(id)==1
			msg=['read_accelg1_mmp: calid=' calid ' not found in ' ...
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
	Sa=str2num(Sa);
end
