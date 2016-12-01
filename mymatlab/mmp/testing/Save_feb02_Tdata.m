% Save_feb02_Tdata.m - Gather temperature data to examine new fast thermistors
%drop=12302;
clear DATA, nd=0; mxl=0;
for drop=[13502:13515 13526:13550 13564:13569]
    
load(['c:\mmp\feb02\tc\tc' num2str(drop)])
cruise=read_cruises_mmp(drop);
mmpid=read_mmpid(drop);

if strcmp(mmpid,'mmp1')
    
scLO=1:length(tsbe);
mxl=max(mxl,length(tsbe));

% high-freq channels:
chHI={'tl1','th1','tl2','th2'}; %,'a1','a2','v1','v2'};
scHI=[1:length(scLO)*16]/16 + 1/2 - 1/32;
for ic=1:length(chHI)
   str=[chHI{ic} '= atod1_mmp(read_rawdata_mmp(''' chHI{ic} ''',drop));'];
   eval(str)
end

nd=nd+1; DATA(nd).drop = drop;
DATA(nd).tempSB=tsbe;
DATA(nd).depth=pr_thetasd*100;
DATA(nd).fp07=tl2;
DATA(nd).fp07_grad=th2;
DATA(nd).fast=tl1;
DATA(nd).fast_grad=th1;

end % of mmp1

end % of drop-loop
sec25Hz = [1:mxl]/25 -.02;
sec400Hz = ([1:mxl*16]/16 + 1/2 - 1/32) / 25 -.02;

