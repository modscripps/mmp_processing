% check_analog1_mmp.m
%  Plots raw mmp data from analog channels sg, vb, v1, v2,
%  a1, a2, th1, and tl1.  Requests drop number as an input.

drop=input('drop ');
mmpid=read_mmpid(drop);

% Get raw  data in volts
sg=atod1_mmp(read_rawdata_mmp('sg',drop));
vb=atod1_mmp(read_rawdata_mmp('vb',drop));
v1=atod1_mmp(read_rawdata_mmp('v1',drop));
v2=atod1_mmp(read_rawdata_mmp('v2',drop));
a1=atod1_mmp(read_rawdata_mmp('a1',drop));
a2=atod1_mmp(read_rawdata_mmp('a2',drop));
th1=atod1_mmp(read_rawdata_mmp('th1',drop));
tl1=atod1_mmp(read_rawdata_mmp('tl1',drop));

title_str=[mmpid ' drop ' int2str(drop)];
figure
orient tall

subplot(4,2,1)
plot(sg)
ig=find(~isnan(vb));
if ~isempty(ig)
   y_max=max(sg(ig)); y_min=min(sg(ig)); x_max=length(sg);
   axis([0 x_max y_min y_max])
end
ylabel('sg / volts')
title(title_str)

subplot(4,2,2)
plot(vb)
ig=find(~isnan(vb));
if ~isempty(ig)
   y_max=max(vb(ig)); y_min=min(vb(ig)); x_max=length(vb);
   axis([0 x_max y_min y_max])
end
ylabel('vb / volts')

subplot(4,2,3)
plot(v1)
ig=find(~isnan(v1));
if ~isempty(ig)
   y_max=max(v1(ig)); y_min=min(v1(ig)); x_max=length(v1);
   axis([0 x_max y_min y_max])
end
ylabel('v1 / volts')

subplot(4,2,4)
plot(v2)
ig=find(~isnan(v2));
if ~isempty(ig)
   y_max=max(v2(ig)); y_min=min(v2(ig)); x_max=length(v2);
   axis([0 x_max y_min y_max])
end
ylabel('v2 / volts')

subplot(4,2,5)
plot(a1)
ig=find(~isnan(a1));
if ~isempty(ig)
   y_max=max(a1(ig)); y_min=min(a1(ig)); x_max=length(a1);
   axis([0 x_max y_min y_max])
end
ylabel('a1 / volts')

subplot(4,2,6)
plot(a2)
ig=find(~isnan(a2));
if ~isempty(ig)
   y_max=max(a2(ig)); y_min=min(a2(ig)); x_max=length(a2);
   axis([0 x_max y_min y_max])
end
ylabel('a2 / volts')

subplot(4,2,7)
plot(th1)
ig=find(~isnan(th1));
if ~isempty(ig)
   y_max=max(th1(ig)); y_min=min(th1(ig)); x_max=length(th1);
   axis([0 x_max y_min y_max])
end
xlabel('sample number'), ylabel('th1 / volts')

subplot(4,2,8)
plot(tl1)
ig=find(~isnan(a1));
if ~isempty(ig)
   y_max=max(tl1(ig)); y_min=min(tl1(ig)); x_max=length(tl1);
   axis([0 x_max y_min y_max])
end
xlabel('sample number'), ylabel('tl1 / volts')