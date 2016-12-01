function acmspec_mmp(drop,prstart,prstop,cruise)
% not debugged.  Reads processed acm data

FS=25;
NFFT=512;

mmpfolders

if nargin<4
   cruise=read_cruises_mmp(drop);
end

vacm_file=[procdata '\' cruise '\vac\vac' int2str(drop) '.mat'];
if exist(vacm_file)~=2
   msg1=['acmspec_mmp: ' vacm_file ' does not exist.'];
   disp(msg1)
else
   ld_str=['load ' setstr(39) vacm_file setstr(39)];
   eval(ld_str)
end

ip=find(pr_vac>=prstart & pr_vac<=prstop);

figure
plot(vac(ip,:),pr_vac(ip))
title_str=['mmp' int2str(drop) ', prstart=' num2str(prstart,3) ...
      ', prstop=' num2str(prstop,3)];
set(gca,'ydir','rev')
xlabel('v1,v2 / m/s'), ylabel('p / MPa'), title(title_str)


%demeaning
vac(ip,1)=vac(ip,1)-nanmean(vac(ip,1));
vac(ip,2)=vac(ip,2)-nanmean(vac(ip,2));
%BB=hanning(length(vac(ip,1)))./sum(hanning(length(vac(ip,1))));

%[P1,f]=periodogram(vac(ip,1),BB,NFFT,FS);    %[Pxx,F] = PERIODOGRAM(X,WINDOW,NFFT,Fs)
%[P2,f2]=periodogram(vac(ip,2),BB,NFFT,FS);

%determining length of appropriate NFFT based on the number of values in the vac range.

AL=length(vac(ip,1));
if AL<256
   NFFT=256;
elseif AL>=256 & AL<512
      NFFT=512;
elseif AL>=512 & AL<1024
   NFFT=1024;
else
   NFFT=2048;
end

NFFT
disp(['number of vac values= ',num2str(AL)]);

[P1,f]=pmtm(vac(ip,1),4,NFFT,FS,'eigen');
[P2,f2]=pmtm(vac(ip,2),4,NFFT,FS,'eigen');


%[P1a,fa]=psd(vac(ip,1),NFFT,FS,NFFT,'none'); P1a=P1a./FS;  %[Pxx,F] = PSD(X,NFFT,Fs,WINDOW,NOVERLAP)
%[P2a,f2a]=psd(vac(ip,2),NFFT,FS,NFFT,'none'); P2a=P2a./FS;  %[Pxx,F] = PSD(X,NFFT,Fs,WINDOW,NOVERLAP)

%Pa=P1a+P2a;
P=P1+P2;

figure;
loglog(f,P)
xlabel('f / Hz'), ylabel('Pvac / m^2 s^{-2} Hz^{-1}'), title(title_str)
fmin=0; fmax=1.1*FS/2;
Pmin=0.9*min(P); Pmax=1.1*max(P);
axis([fmin fmax Pmin Pmax])

hold on

%loglog(fa,Pa,'r');
%return

loglog(f,P1,'r')
loglog(f2,P2,'b')
legend('total spectrum','VAC1','VAC2');

%saving previous depth section of same drop for comparison of spectra

%save D:\mmp\epic01\vac\bad12714 P1 P2 f f2 P


