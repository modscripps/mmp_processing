function shear_accel_spec_mmp(drop, prstart, prstop)

% read in pressure
prV=read_raw_mmpdata('pr', drop, 'volts');
pr=pr_mmp(prV);
clear prV

% find sample numbers of selected pressure range
ispectra=find(pr>p0 & pr < p1);
prspectra=pr(ispectra);
clear pr

% get data between prstart & prstop
a1=read_raw_mmpdata('a1', drop, 'volts');
a1spectra=a1(ispectra);
clear a1
a2=read_raw_mmpdata('a2', drop, 'volts');
a2spectra=a2(ispectra);
clear a2
v1=read_raw_mmpdata('v1', drop, 'volts');
v1spectra=v1(ispectra);
clear v1
v2=read_raw_mmpdata('v2', drop, 'volts');
v2spectra=v2(ispectra);
clear v2
	
% plot data
clf
orient landscape
subplot(1,4,1)
plot(a1spectra, prspectra)
a1max=max(a1spectra);
a1min=min(a1spectra);
set(gca,'YDIR','reverse')
axis([a1min a1max p0 p1])
xlabel(' a1 / volts'), ylabel('p / MPa')
title(['MMP ' , num2str(drop)])
subplot(1,4,2)
plot(a2spectra, prspectra)
a2max=max(a2spectra);
a2min=min(a2spectra);
set(gca,'YDIR','reverse')
axis([a2min a2max p0 p1])
xlabel(' a2 / volts'), ylabel('p / MPa')
subplot(1,4,3)
plot(v1spectra, prspectra)
v1max=max(v1spectra);
v1min=min(v1spectra);
set(gca,'YDIR','reverse')
axis([v1min v1max p0 p1])
xlabel(' v1 / volts'), ylabel('p / MPa')
subplot(1,4,4)
plot(v2spectra, prspectra)
v2max=max(v2spectra);
v2min=min(v2spectra);
set(gca,'YDIR','reverse')
axis([v2min v2max p0 p1])
xlabel(' v2 / volts'), ylabel('p / MPa')
	
DoSpec=input('Do Spectra? ', 's');
if strcmp(DoSpec,'y') | strcmp(DoSpec,'Y') == 1

	% calculate  spectra
	[Pv1,f]=psd(v1spectra, 1024, 400);
	Pv1 = Pv1 / 200;
	[Pa1,f]=psd(a1spectra, 1024, 400);
	Pa1 = Pa1 / 200;
	Ca1v1=cohere(a1spectra, v1spectra, 1024, 400);
	
	figure
	orient tall
	subplot(3,1,1)
	loglog(f,Pv1)
	ymax=max(Pv1); ymin=min(Pv1); fmax=max(f); fmin=min(f);
    axis([fmin fmax ymin ymax])
	xlabel('f / Hz'), ylabel('Pv1 / volts^2 / Hz')
	grid
	title(['MMP ' , num2str(drop), ' : ' prstart ' - ' prstop ' MPa'])
	subplot(3,1,2)
	ymax=max(Pa1); ymin=min(Pa1); fmax=max(f); fmin=min(f);
	loglog(f,Pa1)
	axis([fmin fmax ymin ymax])
	xlabel('f / Hz'), ylabel('Pa1 / volts^2 / Hz')
	grid
	subplot(3,1,3)
	semilogx(f,Ca1v1)
	axis([fmin fmax 0 1])
	xlabel('f / Hz'), ylabel('Coh^2 a1 v1')
	grid
	break
			
else
	break
end

DoSpec=input('Do v2 Spectra? ', 's');
if strcmp(DoSpec,'y') | strcmp(DoSpec,'Y') == 1

	% calculate  spectra
	[Pv2,f]=psd(v2spectra, 1024, 400);
	Pv2 = Pv2 / 200;
	[Pa2,f]=psd(a2spectra, 1024, 400);
	Pa2 = Pa2 / 200;
	Ca2v2=cohere(a2spectra, v2spectra, 1024, 400);
	
	figure
	orient tall
	subplot(3,1,1)
	loglog(f,Pv2)
	ymax=max(Pv2); ymin=min(Pv2); fmax=max(f); fmin=min(f);
    axis([fmin fmax ymin ymax])
	xlabel('f / Hz'), ylabel('Pv2 / volts^2 / Hz')
	grid
	title(['MMP ' , num2str(drop), ' : ' prstart ' - ' prstop ' MPa'])
	subplot(3,1,2)
	ymax=max(Pa2); ymin=min(Pa2); fmax=max(f); fmin=min(f);
	loglog(f,Pa2)
	axis([fmin fmax ymin ymax])
	xlabel('f / Hz'), ylabel('Pa2 / volts^2 / Hz')
	grid
	subplot(3,1,3)
	semilogx(f,Ca2v2)
	axis([fmin fmax 0 1])
	xlabel('f / Hz'), ylabel('Coh^2 a1 v1')
	grid
	break
			
else
	break
end

