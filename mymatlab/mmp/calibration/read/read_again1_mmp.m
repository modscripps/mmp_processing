function gain=read_again1_mmp(mmpid,ch,electronicsid,calid)
% Usage: gain=read_again1_mmp(mmpid,ch,electronicsid,calid);
%  inputs:  
%    mmpid: string id of vehicle
%    electronicsid: string with the id of the accelerometer electronics
%    sensorid: string with the accelorometer serial number
%    calid: string identifying which calibration to use
%  output:
%    gain: circuit gain, a scalar
% Function:
%   Read the accelerometer electronics gain in directory mmp:database:cal:accel
%   File has name like mmp3_a1elect.  The file has one gain per line and is
%   specified by the electronicsid and the calid.
% M.Gregg, 24jul96

mmpfolders;
global FSP
source_file=[mmpdatabase '\cal\accel\' mmpid '_' ch 'elect'];

if exist(source_file)==2
  fid=fopen(source_file,'r');
  if (fid <= 2)
	msg=['read_accelg1_mmp: cannot open ' source_file];
	disp(msg)
	test=0;
  else 
	test=1;
	while test==1
		eid=fscanf(fid,'%s',1);
		cid=fscanf(fid,'%s',1);
		gain=fscanf(fid,'%s',1);
		if isempty(eid)
			msg=['read_again1_mmp: ' source_file ' is empty'];
			disp(msg)
			break
		elseif strcmp(eid,electronicsid) & strcmp(cid,calid)
			test=2;
			break
		end
	end
  end
  fclose(fid);

  if test==2
	gain=str2num(gain);
  end
else
  msg=['read_again1_mmp:' source_file ' is missing'];
  disp(msg)
end
