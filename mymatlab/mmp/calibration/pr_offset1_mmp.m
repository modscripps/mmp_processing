function pr=pr_offset1_mmp(drop,ch,pr_gauge)% pr_offset1_mmp%   Usage: pr=pr_offset1_mmp(drop,ch,pr_gauge)%      drop is the integer drop number, e.g. 1230%      ch is the string channel name, e.g. 'v1'%      pr_gauge is a vector of pressures at the gauge%      pr is the pressure at the sensor%   Function: convert gauge pressure to sensor pressure for a specified channel% 14jul96: revised to use one channel name for obs and vac% 26feb98: revised for PC and added statement to test%          pr_gauge using data without NaNs.% jun00: added one channel name for magnetometer channels (mx,my,mz)% get voffsetsmmpfolders;mmpid=read_mmpid(drop);[scanid,voffsetid]=read_config_mmp(mmpid,drop);str=['load ' mmpdatabase filesep 'config' filesep mmpid filesep voffsetid '.mat'];eval(str)% Choose one name for some double channelsif strcmp(ch,'vac1') | strcmp(ch,'vac2')  ch='vac';elseif strcmp(ch,'obs1') | strcmp(ch,'obs2')   ch='obs';elseif strcmp(ch,'mx') | strcmp(ch,'my') | strcmp(ch,'mz')  ch='mag';end% select offset, in meters, for specified channelstr=['offset=offset_' ch ';'];eval(str)	% convert offset to pressure and add (down) or subtract (up) from gauge pressureig=find(~isnan(pr_gauge));len=length(ig);if pr_gauge(1)<pr_gauge(ig(len)) % downward	pr=pr_gauge+.01*offset;elseif pr_gauge(1)>pr_gauge(ig(len)) % upward	pr=pr_gauge-.01*offset;else	pr=pr_gauge;end