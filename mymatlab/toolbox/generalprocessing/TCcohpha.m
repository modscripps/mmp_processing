% TCcohpha.m
%   Function: 

lendata=length(temp);

start=100; % sample no to start taking spectra
stop=lendata-start; % sample no to stop taking spectra
cshift=0;  % no pts to shift cond ahead
len=1024; % no pts per spectrum
FS=25; % sample frequency
title_str=['MSP168, entire record, no shift'];

dof=2*fix((stop-start)/len);

[Pt,f]=psd(temp(start:stop),len,FS);
Pc=psd(cond(start+cshift:stop+cshift),len,FS);
Ptc=csd(temp(start:stop),cond(start+cshift:stop+cshift),len,FS);
[coh,pha,sig]=cohpha(95,Ptc,Pt,Pc,dof);

fmin=f(2); fmax=f(length(f));

orient portrait

% plot phase below
subplot(2,1,2)
semilogx(f,pha)
axis([fmin fmax -200 200])
xlabel('f / Hz'),ylabel('phase / deg')
grid on

% plotl coh_sq above
subplot(2,1,1)
semilogx(f,coh)
axis([fmin fmax 0 1])
xlabel('f / Hz'),ylabel('coh_sq')
grid on
title(title_str)

