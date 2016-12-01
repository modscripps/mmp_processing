function [vac,pr_vac]=get_vac_mmp(drop);

%function [vac,pr_vac]=get_vac_mmp(drop);
%basic routine just to read the vac data from mmp3.  At this 
%point it's stupid and user must check to make sure that 
%specified drop is in fact an mmp3 drop.  Otherwise the file
%won't exist and it'll break.
%mha 4/5/99
%
mmpfolders
cruise=read_cruises_mmp(drop);
fstr2=[procdata filesep cruise filesep 'Vac' filesep 'Vac' ];
eval(['load ' fstr2 int2str(drop)]);
	
