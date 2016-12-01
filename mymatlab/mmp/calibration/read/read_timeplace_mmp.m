function [yday,year,lat,long]=read_timeplace_mmp(drop)

% load timeplace.mat for cruise
mmpfolders;
cruise=read_cruises_mmp(drop);
str=['load ' setstr(39) procdata '\' cruise '\timeplace.mat' setstr(39)];
eval(str)

% read column for drop
col=find(timeplace(:,1)==drop);
year=timeplace(col,2);
yday=timeplace(col,3);
lat=timeplace(col,4);
long=timeplace(col,5);
