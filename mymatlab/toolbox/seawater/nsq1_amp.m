function [pr_nsq,nsq]=nsq1_amp(s,t,p,dp);
% nsq1_amp
%   Usage: [pr_nsq,nsq]=nsq1_amp(s,t,p,dp);
%     inputs
%      s a vector of salinities, in c.u.
%      t is a vector of temperatures, in deg C
%      p is a vector of pressures, in MPa
%      dp is a number giving the pressure increment, in MPa
%     outputs
%      pr_nsq is the pressure at the center of each p increment
%         over which nsq is calculated
%      nsq is the buoyancy frequency squared, in (rad/s)^2
%   Function: compute N^2 a fixed interval, dp, at all data
%      in the input array, i.e. the interval is moved point-
%      by-point through the data rather than being shifted by
%      dp. The data are assumed to contain no gaps.
%         N^2 is computed by adiabatically displacing s,t
%      values from upper and lower bounds of the interval
%      to the center of the interval.
%   M.Gregg, 29 May 1995


G=9.80665;

% check that dp>0;
if dp<=0
	error('dp must be > 0');
end

% remove NaNs from start or end of good data
igood=find(~isnan(s)==1 & ~isnan(t)==1);
%igaps=find(diff(igood)>1);
s=s(igood); t=t(igood); p=p(igood);

% low pass input data to match dp
dp_data=diff(p);
dp_med=median(dp_data);
[b,a]=butter(4,2*dp_med/dp);
t=filtfilt(b,a,t);
s=filtfilt(b,a,s);

% set up output vectors and 
i=find(p>p(1)+dp/2 & p<p(length(p))-dp/2);
nout=size(i);
nsq=NaN*ones(nout,1);
pr_nsq=p(i);

%
for k=1:nout
	pri=pr_nsq(k);
	ipw=find(p>pri-dp/2 & p<pri+dp/2);

	% upper end of interval
	iu=ipw(1); pu=p(iu); su=s(iu); tu=t(iu);
	ptu=potempref(su,tu,pu,pri);
	rhou=density(su,ptu,pri);

	% lower end of interval
	il=ipw(length(ipw)); pl=p(il); sl=s(il); tl=t(il);
	ptl=potempref(sl,tl,pl,pri);
	rhol=density(sl,ptl,pri);

	nsq(k)=G^2*(rhou - rhol) / (1e6 * (pu - pl));
end
