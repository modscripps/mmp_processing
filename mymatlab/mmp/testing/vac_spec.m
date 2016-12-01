%vac_spec.m
% modified 19aug99, m.gregg
close all

drop=input('vac_spec: drop=? ');
vac1=atod1_mmp(read_rawdata_mmp('vac1',drop));
vac2=atod1_mmp(read_rawdata_mmp('vac2',drop));

vac=[vac1 vac2];  clear vac1 vac2

subplot(2,1,1)
Hp1=plot(vac);
set(Hp1(1),'color','r'); set(Hp1(2),'color','g')
xlabel('Sample Number'), ylabel('Vac1 (r), Vac2(g) / volts')
title_str=['vac\_spec: drop=' int2str(drop)];
title(title_str)
grid on

start=input('vac_spec: sample_start=? ');
stop=input('vac_spec: sample_stop=? ');

ivac=start:stop;
[Pvac1,f]=psd(vac(ivac,1),1024,50);
Pvac1=Pvac1/25;
[Pvac2,f]=psd(vac(ivac,2),1024,50);
Pvac2=Pvac2/25;
Pmin=0.5*min(min(Pvac1),min(Pvac2));
Pmax=2*max(max(Pvac1),max(Pvac2));
fmin=0.5*f(2);
fmax=max(f)*2;

subplot(2,1,2)
Hp2=loglog(f,[Pvac1 Pvac2]);
set(gca,'ylim',[Pmin Pmax],'xlim',[fmin fmax])
set(Hp2(1),'color','r'); set(Hp2(2),'color','g')
xlabel('f / Hz'), ylabel('\Phi (f) / Volts^2 Hz^{-1}')
title2_str=['start=' int2str(start) ', stop=' int2str(stop)];
title(title2_str)
grid on
