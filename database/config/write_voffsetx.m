% write_voffsetx.m
% A script to write files containing vertical offsets of mmp
% sensors

FSP=':';

mmpid='mmp3';
voffsetid='voffset1';

  f_str=['deimosHD' FSP 'mmp' FSP 'database' FSP 'config' FSP ...
         mmpid FSP voffsetid '.mat'];

  offset_a1=1;
  offset_a2=1;
  offset_a3=1;
  offset_a4=1;
  offset_ac=1;
  offset_csbe=1;
  offset_kvh=1;
  offset_obs=1;
  offset_tl=1;
  offset_tl1=1;
  offset_tl2=1;
  offset_tl=1;
  offset_th1=1;
  offset_th2=1;
  offset_tsbe=1;
  offset_v1=1;
  offset_v2=1;
  offset_vac=1;
 
  
  sv_str=['save ' setstr(39) f_str setstr(39) ' offset_a1 ' ...
   ' offset_a2 offset_a3 offset_a4  offset_ac offset_csbe ' ...
   ' offset_kvh offset_obs offset_tl1 offset_tl2 offset_th1 ' ...
   ' offset_th2 offset_tsbe offset_v1 offset_v2 offset_vac ' ...
   ' offset_tl'];
   
  eval(sv_str)
   
