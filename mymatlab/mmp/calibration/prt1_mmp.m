function prt=prt1_mmp(drop);
% Usage: prt=prt1_mmp(drop);
% Function: compute temperature at the ParosScientific gauge
%  using nominal calibration coefficients 

% nominal calibration coef
a0=1.375;
a1=0.0225;

prt_v=read_rawdata_mmp('prt',drop);
prt_v=atod1_mmp(prt_v);


prt=(prt_v-a0)/a1;
