% write_voffsetx.m
% A script to write files containing vertical offsets of mmp
% sensors
%I've modified the other file in this directory to write the
%magnetometer offsets for MMP3.  It reads in the old voffsets file
%and adds offset_mag, saving it with the same name.
%mha 9/9/99

mmpfolders;
%pick an mmp3 drop
drop=7600;
mmpid=read_mmpid(drop);
[scanid,voffsetid]=read_config_mmp(mmpid,drop);
str=['load ' setstr(39) mmpdatabase '\config\' mmpid '\' ...
	     voffsetid '.mat' setstr(39)];
eval(str)

  f_str=[mmpdatabase '\config\' mmpid '\' ...
	     voffsetid '.mat'];

%add in the magnetometer offset, in meters.
%10.59" below the pressure guage.
offset_mag=10.59/39; 
  
  sv_str=['save ' setstr(39) f_str setstr(39) ' offset_a1 ' ...
   ' offset_a2 offset_a3 offset_a4  offset_ac offset_csbe ' ...
   ' offset_kvh offset_obs offset_tl1 offset_tl2 offset_th1 ' ...
   ' offset_th2 offset_tsbe offset_v1 offset_v2 offset_vac ' ...
   ' offset_tl offset_mag'];
   
  eval(sv_str)
   
