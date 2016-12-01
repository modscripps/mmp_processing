% vspec_mmp.m

close all

drop=input('mmp drop number: ')
ch=input('data channel- v1, v2, th1, th2, pr, a1, a2, tl1: ','s');

data=read_rawdata_mmp(ch,drop);
data=atod1_mmp(data);

plot(data)
title_str=['mmp drop: ' int2str(drop) ', channel: ' ch];
title(title_str) 
xlabel('sample number')
y_str=[ch ' / volts']; ylabel(y_str)

start=input('start calculating spectrum at sample number: ');
stop=input('stop calculating spectrum at sample number: ');

[P,f]=psd(data(start:stop),1024,400);
P=P/200;

figure
loglog(f,P)
axis([.1 200 1e-10 1e-2])
grid on

xlabel('f / Hz')
y_str=['P_' ch ' / (V^2 / Hz)']
ylabel(y_str)

ti_str=['mmp drop:' int2str(drop) ' , ch: ' ch ...
      ' , ' num2str(start) '--' num2str(stop) ];
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
   print
end
if strcmp(print_spectrum,'y')
   figure(2)
   print
end