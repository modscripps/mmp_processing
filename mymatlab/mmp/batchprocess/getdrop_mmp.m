function [drop,more]=getdrop_mmp
% getdrop_mmp.m
%   Usage: [drop,more]=getdrop_mmp;
%      Must be run in mmp:batchprocessing after saving current 
%      droplist.mat
%   Function: Returns first drop number in droplist and more=1 if
%  	   droplist contains additional drops.  Resaves droplist.mat
%      after deleting current drop number.

load droplist.mat
drop=droplist(1);

if length(droplist) >=2
	droplist=droplist(2:length(droplist));
	save droplist.mat droplist
	more=1;
else
	more=0;
end
	

