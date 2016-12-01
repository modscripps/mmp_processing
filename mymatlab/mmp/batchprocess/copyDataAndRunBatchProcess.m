function copyDataAndRunBatchProcess(droplist)

% copyDataAndRunBatchProcess.  Script for processing mmp drops 
% for ArcticMix15 and FLEAT16.
%
%	copyDataAndRunBatchProcess(droplist) copies mmp data from the 
%	Sikuliaq's server for each drop ID in the scalar of vector 
%	of integers in droplist from the Sikuliaq server, and 
%	then runs the batchprocess script for each one in succession.
%
%   	Input: droplist (can be scalar or vector of drops)

% turn warnings off
warning off

cd ~/Documents/MATLAB/mmp/mymatlab
set_mmp_paths
% don't need this anymore, just enter the cast number in the function call
%droplist = 19948;

% number of drops
ndropz      = length(droplist);

% path to the mmp data on the server
path_server = '/Volumes/scienceparty_share/data/mmp/raw';
% local path
path_local  = '/Users/mmp/Documents/MATLAB/mmp/data';

% copy files
for ii = 1:ndropz
    eval([  '!cp ' path_server '/' num2str(droplist(ii),'%d') ...
              ' ' path_local  ])
end

% save droplist
save droplist droplist

% run batch processing script
batchprocess4WW14_mmp
