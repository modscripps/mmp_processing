% check_analog_mmp3.m
%  Plots raw mmp data from analog channels only on mmp3:
%  kvh, a3, a4, vac1, vac2.  Requests drop number as an input.

drop=input('drop ');
mmpid=read_mmpid(drop);
if strcmp(mmpid,'mmp3')~=1
   disp('This script is only for mmp3')
   break
end

% Get raw  data in volts
kvh=atod1_mmp(read_rawdata_mmp('kvh',drop));
a3=atod1_mmp(read_rawdata_mmp('a3',drop));
a4=atod1_mmp(read_rawdata_mmp('a4',drop));
vac1=atod1_mmp(read_rawdata_mmp('vac1',drop));
vac2=atod1_mmp(read_rawdata_mmp('vac2',drop));

title_str=[mmpid ' drop ' int2str(drop)];
figure
orient tall

subplot(3,2,1)
plot(a3)
ig=find(~isnan(a3));
if ~isempty(ig)
   y_max=max(a3(ig)); y_min=min(a3(ig)); x_max=length(a3);
   axis([0 x_max y_min y_max])
end
title(title_str)

subplot(3,2,2)
plot(a4)
ig=find(~isnan(a4));
if ~isempty(ig)
   y_max=max(a4(ig)); y_min=min(a4(ig)); x_max=length(a4);
   axis([0 x_max y_min y_max])
end
ylabel('a4 / volts')

subplot(3,2,3)
plot(kvh)
ig=find(~isnan(kvh));
if ~isempty(ig)
   y_max=max(kvh(ig)); y_min=min(kvh(ig)); x_max=length(kvh);
   axis([0 x_max y_min y_max])
end
ylabel('kvh / volts')

subplot(3,2,4)
plot(vac1)
ig=find(~isnan(vac1));
if ~isempty(ig)
   y_max=max(vac1(ig)); y_min=min(vac1(ig)); x_max=length(vac1);
   axis([0 x_max y_min y_max])
end
xlabel('sample number'), ylabel('vac1 / volts')

subplot(3,2,5)
plot(vac2)
ig=find(~isnan(vac2));
if ~isempty(ig)
   y_max=max(vac2(ig)); y_min=min(vac2(ig)); x_max=length(vac2);
   axis([0 x_max y_min y_max])
end
xlabel('sample number'), ylabel('vac2 / volts')