% vac_lf_compare.
% Plots two low-passed sections of vac data on the same scale

drop1=7657; chan1='vac2'; mmpid1=read_mmpid(drop1);
drop2=7659; chan2='vac2'; mmpid2=read_mmpid(drop2);
lf_cutoff=1; % cutoff frequency in Hz

Fs=50;
Wn=1/(Fs/2);
[b,a]=butter(4,Wn);
R_deci=10;

vac1=atod1_mmp(read_rawdata_mmp(chan1,drop1));
vac2=atod1_mmp(read_rawdata_mmp(chan2,drop2));

%vac1_lp=filtfilt(b,a,vac1);
%vac2_lp=filtfilt(b,a,vac2);
vac1_lp=decimate(vac1,R_deci);
vac2_lp=decimate(vac2,R_deci);

npts1=length(vac1_lp); npts2=length(vac2_lp);
t1=.02*R_deci*(1:npts1); t2=.02*R_deci*(1:npts2);

i1=find(t1>10 & t1<max(t1)-10);
y1_min=min(vac1_lp(i1)); y1_max=max(vac1_lp(i1));
i2=find(t2>10 & t2<max(t2)-10);
y2_min=min(vac2_lp(i2)); y2_max=max(vac2_lp(i2));
ymin=min(y1_min,y2_min); ymax=max(y1_max,y2_max);



plot(t1,vac1_lp,'r');
hold on
plot(t2,vac2_lp,'g')
set(gca,'ylim',[ymin ymax])
grid on
xlabel('Time / seconds')
ylabel('vac / volts')
title_str=['Red: drop=' int2str(drop1) ', ' mmpid1 ', ' chan1 ', ' ...
      ', Green: drop=' int2str(drop2) ...
      ', ' mmpid2 ', ' chan2];
title(title_str)