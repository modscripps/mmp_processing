% get_dropinfo1G_mmp.m
%   Usage: called by batchprocess4G_mmp
%   Function: reads mmpid, cruise, scanid, voffsetid
% revised June 2000 by Dave W.

mmpid=read_mmpid(drop); 
cruise=read_cruises_mmp(drop);
[scanid,voffsetid] = read_config_mmp(mmpid,drop);

% If proper info was NOT found above, set drop_flag=0
% to stop further processing of this drop
if isempty(mmpid)==1 | isempty(cruise)==1 | ...
      isempty(scanid)==1 | isempty(voffsetid)==1
	drop_flag=0;
end

% load offsets file later, as needed
clear sc voffstr
