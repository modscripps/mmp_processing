function a=get_accel_mmp(drop);

%function a=get_vac_mmp(drop);
%basic routine just to read the accel data from mmp3.  At this 
%point it's stupid and user must check to make sure that 
%specified drop is in fact an mmp3 drop.  Otherwise the file
%won't exist and it'll break.
%mha 4/5/99
%
mmpfolders
cruise=read_cruises_mmp(drop);
fstr2=[procdata FSP cruise FSP 'Accel' FSP 'a' ];
eval(['load ' fstr2 int2str(drop)]);


