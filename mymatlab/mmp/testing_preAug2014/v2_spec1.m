% v2_spec1.m

drop=input('drop= ');

v2=read_rawdata_mmp('v2',drop);
v2=atod1_mmp(v2);

clf
plot(v2)
title_str=['mmp' int2str(drop)];
title(title_str)
xlabel('sample number'), ylabel('v2 / volts')

start=input('starting sample number: ');
stop=input('stopping sample number: ');

[P,f]=psd(v2(start:stop),512,400);
P=P/200;

loglog(f,P)
axis([.5 200 1e-10 1e-4])
grid on

xlabel('f / Hz')
ylabel('Pv2 / V^2 / Hz')

ti_str=['mmp' int2str(drop) ' , ' num2str(start) '--' ...
      num2str(stop) ',  length = ' num2str(length(v2))];
title(ti_str)

print