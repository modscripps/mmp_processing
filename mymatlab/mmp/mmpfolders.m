% ------------------------------------------------------------ 
% mmpfolders: loads folder names for mmp processing and data
% edit selections based on disk configuration being used
%
% - modified 12/28/98 MHA
% ------------------------------------------------------------ 

global harddrive

harddrive	=	'/Users/mmp/Documents/MATLAB/mmp_processing/';
FSP		=	'/';
filesep		=	FSP';
rawmmp		= fullfile(harddrive,'data');
procdata	= fullfile(harddrive);
mmpdatabase	= fullfile(harddrive,'database');
mmpconfig	= fullfile(harddrive,'database','config');
matlabdisk	= '/Users/mmp/';
mymatlabdisk	= '/Users/mmp/Documents/MATLAB/mmp_processing/mymatlab';
cd(fullfile(mymatlabdisk,'mmp','batchprocess'))