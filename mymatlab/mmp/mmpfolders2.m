% mmpfolders: loads folder names for mmp processing and data
% edit selections based on disk configuration being used
%modified 12/28/98 MHA
%global FSP
global harddrive
harddrive='/Users/ecfine/Documents/MATLAB/MMP_proc/';
%harddrive='/Volumes/DataDrive1/DataArchive/';
%harddrive2='~malford/';
FSP='/';
filesep=FSP';

% rawmmp=[harddrive 'Data' filesep 'mmp' filesep 'data'];
% procdata=[harddrive 'Data' filesep 'mmp'];
% mmpdatabase=[harddrive 'Data' filesep 'mmp' filesep 'database'];
% mmpconfig=[harddrive 'Data' filesep 'mmp' filesep 'config'];
% matlabdisk=[harddrive2 ];
% mymatlabdisk=[harddrive2 'Projects' filesep 'MatlabLocal' filesep 'mymatlab'];

rawmmp=fullfile(harddrive,'data');
procdata=fullfile(harddrive);
mmpdatabase=fullfile(harddrive,'database');
mmpconfig=fullfile(harddrive,'database','config');
matlabdisk='/Users/malford/';
mymatlabdisk='/Users/ecfine/Documents/MATLAB/MMP_proc/mymatlab';

cd(fullfile(mymatlabdisk,'mmp','batchprocess'))