function [tlp,s]=salinity2_mmp(proc_cond,tcp_fc,FS_lf,Q,temp,cond,p)
% salinity1_mmp
%   Usage: [tlp,s]=salinity1_mmp(proc_cond,lpf,Q,temp,cond,p);
%      proc_cond='yes' or 'no' and is set in batchprocess1_mmp
%      tcp_lf is cutoff freq for the lp filter applied to temp,cond,pr_thetasd
%      FS_lf is the sample frequency for temp,cond,pr_thetasd
%      Q is the pump rate, in liters/s
%      temp & cond are from SeaBird
%	   p is averaged to one per scan
%      s is salinity
%   Function: low-pass temperature and low-pass conductivity
%      and calculate salinity if proc_cond=='yes'.  Conductivity
%      is calculated with temperatures corrected for the thermal
%      lag of the conductivity cell.  An arrays of NaN's is returned
%      when proc_cond~='yes'

% calculate low-pass filter and apply to temp
[b,a]=butter(4,tcp_fc/(FS_lf/2));
tlp=filtfilt(b,a,temp);

% process conductivity if proc_cond=='yes'
if strcmp(proc_cond,'yes')
	clp=filtfilt(b,a,cond);
	
	% correct for thermal lag of conductivity cell using
	% procedures of Morison et al. (1994), JTech, 11, 1151-1164
	V=79.577*Q; % flow speed through cell, m/s
	alpha=0.0264/V + 0.0135;
	tau=2.7858/sqrt(V)+ 7.1499; % time lag of cell
	
	% coefficients for lag filter
	a=4*(FS_lf/2)*alpha*tau/(1+4*FS_lf*tau);
	b=1-2*a/alpha;

	difft=diff(tlp);

	tlag=NaN*ones(length(tlp),1);
	tlag(1)=0; % take initial lag=0, as cell begins sitting
	           % at surface of turning around slowly at depth
		for i=2:length(tlp);
		tlag(i)=-b*tlag(i-1)+a*difft(i-1);
	end

	s=salinityfcn(clp,tlp-tlag,p);
else
	salinity=NaN*ones(length(tlp),1);
end


