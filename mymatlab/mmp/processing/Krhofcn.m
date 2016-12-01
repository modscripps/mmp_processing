function [Krho,navg]=Krhofcn(epsilon,pr_eps,n2,pn2)
% Krhofcn.m
%   Usage: [Krho,navg]=Krhofcn(epsilon,pr_eps,n2,pn2)
%      epsilon is a vector of dissipation rates, in W/kg
%      pr_eps is a vector of center pressures of epsilon
%      n2 is a vector of N^2
%      pn2 is a vector of center pressures of n2
%      Krho is a vector of Krho in m^2/s
%      navg is the number of eps values in each Krho
%   Function: Compute Krho=0.2 <epsilon>/N^2.  All epsilons not NaNs with center
%      pressures within each N^2 window are used.
%      M. Gregg, 5 March 1995

% Delete negative pressures
i=find(pr_eps>=0);
epsilon=epsilon(i); pr_eps=pr_eps(i);

% Reverse the order of upward profiles
if pr_eps(1)>pr_eps(length(pr_eps)) % upward
	pr_eps=flipud(pr_eps); epsilon=filpud(epsilon);
end
	
% Calculate upper and lower boundaries of nsq windows.
dp_n2=mean(diff(pn2)); % expect evenly spaced pn2
p0_n2=pn2-dp_n2/2; % lower bound in the nsq time series
p1_n2=pn2+dp_n2/2; % upper bound in the nsq time series

% check that pressure window exceeds epsilon window
dp_eps=mean(diff(pr_eps)); % mean pressure window for epsilon
if dp_eps >= dp_n2
	error('dp for epsilon >= dp for N-squared')
end

Krho=NaN*ones(length(n2),1);
navg=NaN*ones(length(n2),1);

for i=1:length(pn2)
	j=find(pr_eps>p0_n2(i) & pr_eps<p1_n2(i)); % eps w indices in pr window
	eps_samples=epsilon(j); % epsilons with cntr pressures in this window
	jj=find(~isnan(eps_samples)); % select those not NaNs
	navg(i)=length(jj);
	eps_mean(i)=mean(eps_samples(jj));
end

Krho=0.2*eps_mean./n2;
