function load_pr_mmp(drop)
% Usage: load_pr_mmp(drop)
% Function: loads pr<drop>.mat if the processed data are online
% M.Gregg 12jul96

cruise=read_cruises_mmp(drop);
mmpfolders
global FSP

file_name=[procdata FSP cruise FSP 'pr' FSP 'pr' int2str(drop) '.mat']
if exist(file_name)==2
  ld_str=['load ' setstr(39) file_name setstr(39)];
  eval(ld_str)
else
  disp_str=['load_pr_mmp: ' file_name '.mat does not exist']
  disp(disp_str)
end
    
