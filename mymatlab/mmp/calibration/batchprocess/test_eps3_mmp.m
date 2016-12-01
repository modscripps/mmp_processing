% test_eps3_mmp.m

KVIS=1e-6;
SPEED=.7;
Fs=400;
NFFT=1024;

len=NFFT*SPEED/Fs;
dk=1/len;
k=dk:dk:NFFT*dk;

ik=find(k<=100);
k=k(ik);

ee=[-10:-1];
inum=length(ee);

for i=1:inum
  epsilon=10^(ee(i))
	[kpan,Ppan]=panchev(epsilon,KVIS,k);
	[eps_int,kc]=eps3_mmp(kpan,Ppan,KVIS,SPEED,mean(diff(kpan)),100/SPEED);
	disp_str=['epsilon=' num2str(epsilon) ', eps_est/epsilon=' num2str(eps_int/epsilon)];
	disp(disp_str)
	clf
	loglog(kpan,Ppan)
	[k2,P2]=panchev(eps_int,KVIS);
	hold on
	loglog(k2,P2,'+r')
	kmin=min(k2); kmax=max(k2);
	Pmin=min(P2); Pmax=max(P2);
	axis([kmin kmax Pmin Pmax])
	pause
end
