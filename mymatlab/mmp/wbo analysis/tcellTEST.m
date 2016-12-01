% tcellTEST.m
%   Usage: execute from MATLAB:mmp:wboanalysis after executing
%      Stest.m in the same directory.
%   Function: calculates the thermal lag of the SeaBird conductivity
%      cell and subtracts it from in-situ temperature before
%      calculating salinity and potential density.  

Q=0.030; % volume flow rate through cell, liters/s
FS_lf=25;

V=79.577*Q;
alpha=0.0264/V + 0.0135;
tau=2.7858/sqrt(V)+ 7.1499;
a=4*(FS_lf/2)*alpha*tau/(1+4*FS_lf*tau);
b=1-2*a/alpha;

difft=diff(tlp);

tlag=NaN*ones(length(tlp),1);
tlag(1)=0;
for i=2:length(tlp);
	tlag(i)=-b*tlag(i-1)+a*difft(i-1);
end

scorr=salinityfcn(clp,tlp-tlag,p);
theta=potemp(scorr,tlp,zeros(length(tlp),1));
sg=density(scorr,theta,zeros(length(tlp),1));
