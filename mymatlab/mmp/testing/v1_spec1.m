% v1_spec1.m
drop=input('drop number: ');
v1=read_rawdata_mmp('v1',drop);
v1=atod1_mmp(v1);
clf
plot(v1)
title_str=['mmp drop ' int2str(drop)];
title(title_str), xlabel('sample number'), ylabel('v1 / volts')

start=input('start calculating spectrum at sample: ');
stop=input('stop calculating spectrum at sample: ');

[P,f]=psd(v1(start:stop),1024,400);
P=P/200;

figure
loglog(f,P)
axis([.5 200 1e-10 1e-4])
grid on

xlabel('f / Hz')
ylabel('Pv1 / V^2 / Hz')

mmpid=read_mmpid(drop);
ti_str=[mmpid ', drop=' int2str(drop) ', samples=' ...
      num2str(start) '--' num2str(stop) ',  length = ' num2str(length(v1))];
title(ti_str)

print_data=input('print data plot? y/n [y]: ','s');

if isempty(print_data)
   print_data='y';
end

print_spectrum=input('print spectral plot? y/n [y]: ','s');

if isempty(print_spectrum)
   print_data='y';
end

if strcmp(print_data,'y')
   figure(1)
   print -dwin
end
if strcmp(print_spectrum,'y')
   figure(2)
   print -dwin
end