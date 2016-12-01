function [sigmath, pr_sigth]=get_sigmath_mmp(drop);
% Usage: [sigmath, pr_sigth]=get_sigmath_mmp(drop);
%   drop is the integer drop number
%	sigmath is the density -1000 (using theta instead of regular temp)
%   pr_eps is the pressure at the center of the density window.
%
% J. MacKinnon  23 Aug 96

mmpfolders
cruise=read_cruises_mmp(drop);

%temporary fix cuz procdata moved to deimos2 halfway through data retrieval
%procdata='deimosHD:mmp';


FORDER=4; % Order of Butterworth low-pass applied to tsbe and
          % csbe to match the frequency content of the two records
FC=1;     % Cutoff frequency of low-pass filter
FSBE=25;  % Sample frequency of SBE data
LAG_CORRECT='y'; % Set to 'y' to correct temperature used w csbe
		         % Normally 'y'.  Alternative for testing
mmpid=read_mmpid(drop);						 
Q=read_pump_mmp(mmpid,drop);

% set up string names of files to open

  fstr1=[procdata FSP cruise FSP 'tc' FSP 'tc' int2str(drop) '.mat'];
 


% load eps<drop>
if exist(fstr1)==2
	str=['load ' setstr(39) fstr1 setstr(39)];
	eval(str)
else
	str=[fstr1 ' does not exist'];
	error(str)
end

%%%%%%%%%%%%%%%% Find data blocks and apply low-pass  filter %%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% filtfilt needs consecutive data not NaNs for at least 3 FORDER
%
[b,a]=butter(FORDER,FC/(FSBE/2)); % calculate filter weights
%
tsbe_lp=NaN*ones(size(tsbe));
tsbe_blocks=find_data_blocks(tsbe,3*FORDER);
[n_tsbeblocks,dum]=size(tsbe_blocks);
if n_tsbeblocks > 0
  for i=1:n_tsbeblocks
    tsbe_lp(tsbe_blocks(i,1):tsbe_blocks(i,2)) = ...
	    filtfilt(b,a,tsbe(tsbe_blocks(i,1):tsbe_blocks(i,2)));
   end
else
  disp('  salinity2_mmp: tsbe contains only NaNs')
  break
end
%
csbe_lp=NaN*ones(size(csbe));
csbe_blocks=find_data_blocks(csbe,3*FORDER);
[n_csbeblocks,dum]=size(csbe_blocks);
if n_csbeblocks > 0
  for i=1:n_csbeblocks
    csbe_lp(csbe_blocks(i,1):csbe_blocks(i,2)) = ...
	   filtfilt(b,a,csbe(csbe_blocks(i,1):csbe_blocks(i,2)));
  end
else
  disp('  salinity2_mmp: csbe contains only NaNs')
  break
end 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%% Calculate salinity accounting for thermal lag of cond cell %%%%%%%%%%%
if strcmp(LAG_CORRECT,'y')
  % Correct for thermal lag of conductivity cell using
  % procedures of Morison et al. (1994), JTech, 11, 1151-1164
  %
  % Calculate coefficients
  V=79.577*Q; % flow speed through cell, m/s (p. 1164)
  alpha=0.0264/V + 0.0135; % (eq 6)
  tau=2.7858/sqrt(V)+ 7.1499; % time lag of cell (eq 7)
  a=4*(FSBE/2)*alpha*tau/(1+4*FSBE*tau); % (eq 3)
  b=1-2*a/alpha; % (eq 4)
  %
  dt=diff(tsbe_lp);
  %
  % Set up vector for lag temperature
  tlag=NaN*ones(size(tsbe));
  for i=1:n_tsbeblocks
    if i==1 
	  last_tlag=0; 
    end % take initial lag=0
    for j=tsbe_blocks(i,1)+1:tsbe_blocks(i,2)-1
	  tlag(j)=-b*last_tlag+a*dt(j-1);
      last_tlag=tlag(j);
     end
  end
  s=salinityfcn(csbe_lp,tsbe_lp-tlag,pr_thetasd);
else
  s=salinityfcn(csbe_lp,tsbe_lp,pr_thetasd);
end
t=tsbe_lp; p=pr_thetasd;

theta=sw_ptmp(s,t,p,0);
sigmath=sw_dens(s,theta,zeros(size(s)))-1000;
pr_sigth=pr_thetasd;	
	
