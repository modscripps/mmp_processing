function [Ktemp,navg]=Kthermalfcn(chi,pr_chi,ktemp,Tgrad,pn2)
% Kthermalfcn.m
%   Usage: [Kthermal,navg]=Kthermalfcn(chi,pr_chi,Tgrad,pn2)
%      chi is a vector of thermal dissipation rates, in K^2/s
%      pr_chi is a vector of center pressures of chi
%      ktemp is a vector of thermal molecular diffusivities, in m^2/s
%      Tgrad is a vector of vertical temperature gradient, in K/m
%      pn2 is a vector of center pressures of Tgrad
%      Kthermal is a vector of Kthermal in m^2/s
%      navg is the number of chi values in each Kthermal
%   Function: Compute Kthermal=chi/(2 ktemp Tgrad^2).  All chi's, not NaNs, with center
%      pressures within each N^2 window are used.
%      M. Gregg, 6 March 1995

% Delete negative pressures
i=find(pr_chi>=0);
chi=chi(i); pr_chi=pr_chi(i);

% Reverse the order of upward profiles
if pr_chi(1)>pr_chi(length(pr_chi)) % upward
	pr_chi=flipud(pr_chi); chi=filpud(chi);
end
	
% Calculate upper and lower boundaries of Tgrad windows.
dp_n2=mean(diff(pn2)); % expect evenly spaced pn2
p0_n2=pn2-dp_n2/2; % lower bound in the nsq time series
p1_n2=pn2+dp_n2/2; % upper bound in the nsq time series

% check that pressure window exceeds chi window
dp_chi=mean(diff(pr_chi)); % mean pressure window for chi
if dp_chi >= dp_n2
	error('dp for chi >= dp for Tgrad')
end

len=length(Tgrad);
chi_mean=NaN*ones(len,1);
navg=NaN*ones(len,1);
ktemp_mean=NaN*ones(len,1);

for i=1:len
	j=find(pr_chi>p0_n2(i) & pr_chi<p1_n2(i)); % chi w indices in pr window
	chi_samples=chi(j); % chi's with cntr pressures in this window
	ktemp_samples=ktemp(j);
	jj=find(~isnan(chi_samples)); % select those not NaNs
	navg(i)=length(jj);
	chi_mean(i)=mean(chi_samples(jj));
	ktemp_mean(i)=mean(ktemp_samples(jj));
end

Tgrad_sq=(Tgrad').^2;
size(Tgrad_sq)
size(ktemp)
size(chi_mean)

Kthermal=chi_mean ./ (2*ktemp.*Tgrad_sq');                                                          
