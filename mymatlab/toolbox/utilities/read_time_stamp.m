function [year,yday] = read_time_stamp(source_file)
% read_time_stamp
%   Usage: [year,yday] = read_time_stamp(source_file)
%      source_file is the string name of a data file written by MPU, e.g. '415'
%   Function: converts time stamp written by MPU to decimal year 
%      day, e.g. stamp of amp 15033: SunSep1809:36:091994
%      is output as 261.4001 in short format.

if exist(source_file)==2
   fid=fopen(source_file,'r');
   weekday=fscanf(fid,'%s',1);
   month=fscanf(fid,'%s',1);
   day=fscanf(fid,'%s',1);
   time=fscanf(fid,'%s',1);
   hour=time(1:2); minute=time(4:5); second=time(7:8);
   year=fscanf(fid,'%s',1);
    fclose(fid);

  
  % convert strings to numbers
  year=str2num(year);
  if strcmp(month,'Jan')
	month=1;
  elseif strcmp(month,'Feb')
	month=2;
  elseif strcmp(month,'Mar')
	month=3;
  elseif strcmp(month,'Apr')
	month=4;
  elseif strcmp(month,'May')
	month=5;
  elseif strcmp(month,'Jun')
	month=6;
  elseif strcmp(month,'Jul')
	month=7;
  elseif strcmp(month,'Aug')
	month=8;
  elseif strcmp(month,'Sep')
	month=9;
  elseif strcmp(month,'Oct')
	month=10;
  elseif strcmp(month,'Nov')
	month=11;
  elseif strcmp(month,'Dec')
	month=12;
  end
  day=str2num(day);
  hour=str2num(hour);
  minute=str2num(minute);
  second=str2num(second);

  % call "yearday" which should be in toolbox:utilities
  yday=yearday(day,month,year,hour,minute,second);
else
  disp_str=['read_time_stamp: ' source_file ' not found'];
  disp(disp_str)
  year=[]; yday=[];
end
