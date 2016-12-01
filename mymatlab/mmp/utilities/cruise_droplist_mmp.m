function list=cruise_droplist_mmp(cruise,which)
% cruise_droplist_mmp
%   Usage: list=cruise_droplist_mmp(cruise,which)
%      cruise is the string name of a cruise, e.g. 'flip95'
%      which is an optional string.  It which is not specified, list contains 
%         all drops for the cruise.  'proc' restricts the list to processed
%         drops, and 'unproc' to unprocessed drops
%   Function: Read timeplace.mat for the cruise and return a list of drops.

% load timeplace.mat for cruise
mmpfolders;
file_str=['load ' setstr(39) procdata '\' cruise '\timeplace' setstr(39)];
eval(file_str);

% first column contains all drop numbers for cruise
list=timeplace(:,1);

% select processed or unprocessed drops if which is specified
if nargin==2
	if strcmp(which,'proc')
		i_proc=find(~isnan(timeplace(:,2)));
		list=list(i_proc);
	elseif strcmp(which,'unproc')
		i_unproc=find(isnan(timeplace(:,2)));
		list=list(i_unproc);
	end
end
