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


[P1,f]=psd(vac(ip,1),NFFT,FS,NFFT/2); P1=P1/(FS/2);
P2=psd(vac(ip,2),NFFT,FS,NFFT/2); P2=P2/(FS/2);
P=P1+P2;

figure
loglog(f(2:NFFT/2),P(2:NFFT/2))
xlabel('f / Hz'), ylabel('Pvac / m^2 s^{-2} Hz^{-1}'), title(title_str)
fmin=0.9*f(2); fmax=1.1*FS/2;
Pmin=0.9*min(P); Pmax=1.1*max(P);
axis([fmin fmax Pmin Pmax])