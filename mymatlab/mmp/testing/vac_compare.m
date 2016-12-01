% vac_compare.
% Plots two sections of vac data on the same scale

drop1=7657; chan1='vac2'; pts1=8501:10500; mmpid1=read_mmpid(drop1);
drop2=7659; chan2='vac2'; pts2=10001:12000; mmpid2=read_mmpid(drop2);

npts1=length(pts1); npts2=length(pts2);

if npts1~=npts2
   error('pts1 not equal pts2')
end

vac1=atod1_mmp(read_rawdata_mmp(chan1,drop1));
vac2=atod1_mmp(read_rawdata_mmp(chan2,drop2));

t=.02*(1:npts1);

plot(t,vac1(pts1),'r');
hold on
plot(t,vac2(pts2),'g')
grid on
xlabel('Time / seconds')
ylabel('vac / volts')
title_str=['Red: drop=' int2str(drop1) ', ' mmpid1 ', ' chan1 ', ' ...
      int2str(pts1(1)) ':' int2str(pts1(npts1)) ', Green: drop=' int2str(drop2) ...
      ', ' mmpid2 ', ' chan2 ', ' int2str(pts2(1)) ':' int2str(pts2(npts2))];
title(title_str)