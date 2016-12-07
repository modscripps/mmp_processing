% ------------------------------------------------------------ 
% mmpfolders: loads folder names for mmp processing and data
% edit selections based on disk configuration being used
%
% - modified 12/28/98 MHA
% ------------------------------------------------------------ 

global harddrive

harddrive	=	'/Users/mmp/Documents/MATLAB/mmp/';
FSP		=	'/';
filesep		=	FSP';

% rawmmp=[harddrive 'Data' filesep 'mmp' filesep 'data'];
% procdata=[harddrive 'Data' filesep 'mmp'];
% mmpdatabase=[harddrive 'Data' filesep 'mmp' filesep 'database'];
% mmpconfig=[harddrive 'Data' filesep 'mmp' filesep 'config'];
% matlabdisk=[harddrive2 ];
% mymatlabdisk=[harddrive2 'Projects' filesep 'MatlabLocal' filesep 'mymatlab'];

rawmmp		= fullfile(harddrive,'data');
procdata	= fullfile(harddrive);
mmpdatabase	= fullfile(harddrive,'database');
mmpconfig	= fullfile(harddrive,'database','config');
matlabdisk	= '/Users/mmp/';
mymatlabdisk	= '/Users/mmp/Documents/MATLAB/mmp/mymatlab';

cd(fullfile(mymatlabdisk,'mmp','batchprocess'))


% harddrive	=	'/Users/Maddie/Google Drive/Projects/NEMO/Cruises/WaWaves14/mmp';
% FSP		=	'/';
% filesep		=	FSP';
% 
% % rawmmp=[harddrive 'Data' filesep 'mmp' filesep 'data'];
% % procdata=[harddrive 'Data' filesep 'mmp'];
% % mmpdatabase=[harddrive 'Data' filesep 'mmp' filesep 'database'];
% % mmpconfig=[harddrive 'Data' filesep 'mmp' filesep 'config'];
% % matlabdisk=[harddrive2 ];
% % mymatlabdisk=[harddrive2 'Projects' filesep 'MatlabLocal' filesep 'mymatlab'];
% 
% rawmmp		= fullfile(harddrive,'data');
% procdata	= fullfile(harddrive);
% mmpdatabase	= fullfile(harddrive,'database');
% mmpconfig	= fullfile(harddrive,'database','config');
% matlabdisk	= '/Users/mmp/';
% mymatlabdisk	= '/Users/Maddie/Documents/GitHub/mmp_processing/mymatlab';
% 
% cd(fullfile(mymatlabdisk,'mmp','batchprocess'))
