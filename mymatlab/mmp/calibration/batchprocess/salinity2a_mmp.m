function [p,t,t_raw,s,s_raw,cn,cn_raw]=salinity2a_mmp(drop)
% Usage: [p,t,s]=salinity2_mmp(drop);
% Function: Computes salinity from tsbe and csbe
%   ** For normal data, processing applies problems files, 
%        low-passes tsbe and csbe to reduce salinity  spiking, and
%        corrects for thermal lag of conductivity cell.  Low-passed
%	     tsbe is returned.
%   ** Thermal lag correction can be shut off for testing
%   ** If csbe is null or zeros, salinity is returned as null
%	     or zeros and the problem files are applied to tsbe but
%        tsbe is not low-passed
%
%  M.Gregg, 9jul96
%
%  G.Carter, 14june99: version 2a
%     returns uncorrected temp, sal and cn as well as the corrected 
%     (problems). 

FORDER=4; % Order of Butterworth low-pass applied to tsbe and
          % csbe to match the frequency content of the two records
FC=1;     % Cutoff frequency of low-pass filter
FSBE=25;  % Sample frequency of SBE data
LAG_CORRECT='y'; % Set to 'y' to correct temperature used w csbe
		         % Normally 'y'.  Alternative for testing
	
mmpfolders
cruise=read_cruises_mmp(drop);
mmpid=read_mmpid(drop);
				 
% Read pump flow rate and stop processing if inadequate
Q=read_pump_mmp(mmpid,drop);
if Q<=0 | isempty(Q)
  disp('  salinity2_mmp: Q<=0 or [], no salinity')
  return
end

%%%%%%%%%%%%%% LOAD tc<drop>.mat & check data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load tc<drop>.mat
f_str=[procdata '\' cruise '\tc\tc' int2str(drop) '.mat'];
if exist(f_str)==2
   ld_str=['load ' setstr(39) f_str setstr(39)];
   eval(ld_str)
else
   disp('  salinity2_mmp: tc<drop> file not found')
   return
end
cn_raw = csbe;
t_raw = tsbe;
%
% Check that data exist in tsbe, csbe, and pr_thetasd
if ~exist('tsbe') | ~exist('pr_thetasd') | ~exist('csbe')
   disp('  salinity2_mmp: tsbe, csbe, or pr_thetasd does not exist')
   return
elseif isempty(tsbe) | isempty(pr_thetasd)
   disp('  salinity2_mmp: tsbe or pr_thetasd is empty')
   return
elseif isempty(csbe)
   disp('  salinity2_mmp: s=[] because csbe is empty')
else
   n_tsbe=length(tsbe); n_csbe=length(csbe); n_p=length(pr_thetasd);
   if n_p~=n_tsbe | n_csbe~=n_tsbe
      disp('  salinity2_mmp: tsbe, csbe, pr_thetasd differ in length')
      return
   end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%%%%%%%%%%%%%%%%% Load & apply problem files %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
prob_pr_str=[procdata '\' cruise '\problems\pr' int2str(drop) '.mat'];
if exist(prob_pr_str)==2
   pr_str=['load ' setstr(39) prob_pr_str setstr(39)];
   eval(pr_str)
   n_badpr=size(badpr,1);
   for i=1:n_badpr
      ib=find(pr_thetasd>=badpr(i,1) & pr_thetasd<=badpr(i,2));
      pr_thetasd(ib)=NaN*ones(length(ib),1);
   end
end
%
prob_tsbe_str=[procdata '\' cruise '\problems\tsbe' int2str(drop) '.mat'];
if exist(prob_tsbe_str)==2
   t_str=['load ' setstr(39) prob_tsbe_str setstr(39)];
   eval(t_str)
   n_badtsbe=size(badtsbe,1);
   for i=1:n_badtsbe
      ib=find(pr_thetasd>=badtsbe(i,1) & pr_thetasd<=badtsbe(i,2));
      tsbe(ib)=NaN*ones(length(ib),1);
   end
end
%
% Load csbe problem files, if they exist, and set badcsbe to NaNs
prob_csbe_str=[procdata '\' cruise '\problems\csbe' int2str(drop) '.mat'];
if exist(prob_csbe_str)==2 & ~isempty(csbe)
   c_str=['load ' setstr(39) prob_csbe_str setstr(39)];
   eval(c_str)
   n_badcsbe=size(badcsbe,1);
   % Set bad csbe data to NaNs
   for i=1:n_badcsbe
      ib=find(pr_thetasd>=badcsbe(i,1) & pr_thetasd<=badcsbe(i,2));
      csbe(ib)=NaN*ones(length(ib),1);
   end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%% Stop processing if csbe is null or all zeros %%%%%%%%%%%%%%%%%%%%%%%%%
if isempty(csbe)
   t=tsbe; s=[]; p=pr_thetasd;
   return
else
   inz=find(csbe~=0);
   if isempty(inz)
      s=zeros(size(tsbe));
      p=pr_thetasd; t=tsbe;
      disp('  salinity2_mmp: salinity=0 because csbe=0')
      return
   end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%% Find data blocks and apply low-pass  filter %%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% filtfilt needs consecutive data not NaNs for at least 3 FORDER
%
[b,a]=butter(FORDER,FC/(FSBE/2)); % calculate filter weights
%
tsbe_lp=NaN*ones(size(tsbe));
tsbe_blocks=find_data_blocks(tsbe,3*FORDER); % returns 2 col matrix
[n_tsbeblocks,dum]=size(tsbe_blocks);
if n_tsbeblocks > 0
   for i=1:n_tsbeblocks
      tsbe_lp(tsbe_blocks(i,1):tsbe_blocks(i,2)) = ...
	   filtfilt(b,a,tsbe(tsbe_blocks(i,1):tsbe_blocks(i,2)));
   end
else
   disp('  salinity2_mmp: tsbe contains only NaNs')
   return
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
   return
end 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%% Calculate salinity, accounting for thermal lag of cond cell %%%%%%%%%%%
%% Lag correction subtracts lag temperature from tsbe
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
s_raw=salinityfcn(cn_raw,t_raw,pr_thetasd);
t=tsbe_lp; p=pr_thetasd; cn = csbe_lp;
