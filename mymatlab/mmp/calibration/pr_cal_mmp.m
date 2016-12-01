function [prG,offset_file]=pr_cal_mmp(x,drop)
% [prG,offset_file]=pr_cal_mmp(x,drop)
%    Converts raw presssure data in array x to MPa at pressure
% port.

% Find which calibration to use
[mmpno, prno, calid, offsetid]=read_pr_config_mmp(drop);

% make name of offset file
offset_file=[mmpno '_' offsetid];

% Call proper algorithm
prstr=['prG=' prno '_' mmpno '(x, calid );'];
eval(prstr);
