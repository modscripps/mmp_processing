function [epsilon,kc]=eps1_mmp(k,Psheark,kvis,w,dk);
% eps1_mmp
%   Usage: epsilon=eps1_mmp(k,Psheark,kvis,w);
%      k is a vector array with wavenumber in cpm
%      Psheark is a vector array with the shear spectrum
%      kvis is the kinematic viscocity, in m^2/s
%      w is the vehicle speed, in m/s
%      dk is the elementary wavenumber bandwidth, in cpm
%      epsilon is the estimated dissipation rate, in W/kg
%      kc is the wavenumber at which integration is cutoff, in cpm
%   Function: To integrate airfoil shear versus k spectrum to
%      obtain epsilon.  Uses algorithm described by Wesson &
%      Gregg, 1994, JGR, 99, -9877. 

EPS_MIN=1; % epsilon needed for spectrum to exceed vibration peak
FMAX=40; % max frequency not contaminated by vibration peak
epsintflag=1;

% make first estimate, using samples from k < 10 cpm
krange=find(k>=2 & k<10); %wavenumber indices for k < 10 cpm
X=log10( sum(Psheark(krange)*dk) );  % integrate to 10cpm
Y= -1.03132 + 0.846426*X - 0.181407*X^2 - 0.0451062*X^3 - 0.00293765*X^4; % predict scale
eps1  = ( 10^Y * kvis^(1/4) )^(4/3);   % predict eps

% set k cutoff to include 90% of variance for second estimate
kc2 = (0.09)*( eps1  / kvis^3 )^(1/4);  % obtain cutoff wavenumber
if kc2 < 10 
	kc2=10; % min for integration
elseif kc2 > 100
	kc2=100; % max for size of probe
end
if eps1 < EPS_MIN & kc2 > FMAX/w 
	kc2 = FMAX/w; % max k not affected by 1st bending mode of tube
end
	
% iterate for third estimate
krange=find(k>0 & k<=kc2);
eps2=7.5*kvis*sum(Psheark(krange)*dk);
eps3=epsilon_correct(eps2,kvis,kc2)*eps2;
kc3=(0.09)*( eps3 / kvis^3 )^(1/4);
if kc3 < 10 
	kc3=10;
elseif kc3 > 100
	kc3=100;
end
if eps3 < EPS_MIN & kc3 > FMAX/w
	kc3 = FMAX/w;
end
krange=find(k>0 & k<=kc2);
eps4 = 7.5*kvis*sum(Psheark(krange)*dk); 
eps5=epsilon_correct(eps4,kvis,kc3)*eps4;

epsilon=eps5;
kc=kc3;
