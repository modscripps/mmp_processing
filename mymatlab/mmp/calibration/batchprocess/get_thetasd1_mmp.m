function [p,t,th,s,sgth]=get_thetasd1_mmp(drop,v1,v2,v3,v4,pref)
% Usage: [p,t,th,s,sgth]=get_thetasd1_mmp(drop,v1,v2,v3,v4,pref);
%  inputs:
%    drop: integer mmp drop number
%    v1: 't' for temp, 't_uf' for unfiltered temp, '' no temp
%    v2: 'th' for potemp, 'th_uf' for unfiltered temp assuming
%        salinity is zero, '' no potemp
%    v3: 's' for salinity, '' no salinity
%    v4: 'sgth' for potdens, 'sgth_uf' for unfiltered potdens
%       assuming salinity is zero, '' no podens
%    pref: reference pressure for potential temp & density, MPa
%          assumed 0 if absent
%  outputs:
%    p: pressure in MPa
%    t: in-situ temperature in degC
%    th: potential temperature in degC
%    s: salinity in concentration units
%    sgth: potential density as density - 1000, kg / m^3
%
% Function: to obtain temperature, salinity, potential temperature,
%  or potential density from mmp data.  
%
%     ** All parameters calculated by the script are returned, 
%        even if they are not requested with the vi arguments.
%
%     ** Setting v3 to '' and specifying potential temperature
%        and/or potential density is equivalent to assuming s=0,
%        i.e. fresh water. 
%  
%     ** Salinity is calculated after low-pass filtering temperature
%        and conductivity to match their frequency content.  Also,
%        the temperature used is correctd to include the thermal
%        lag of the conductivity cell (Morison et al. 1994,
%        J. Tech. 11, 1151-1164).
%     
%     ** Setting v1 to 't_uf' and/or v2 to 'th_uf' results
%        in the unfiltered data being output, even if that
%        was not used to compute the matching s & sg_th.
%
%     ** The problems files are read and bad set to NaNs before
%        processing.
%
%  M.Gregg, 8jul96

FORDER=4; % Order of Butterworth low-pass applied to tsbe and
          % csbe to match the frequency content of the two records
FC=1;     % Cutoff frequency of low-pass filter
FSBE=25;  % Sample frequency of SBE data
LAG_CORRECT='y'; % Set to 'y' to correct temperature used w csbe
		         % Normally 'y'.  Alternative for testing
	
mmpfolders
global FSP
cruise=read_cruises_mmp(drop);
mmpid=read_mmpid(drop);
				 
% Read pump flow rate
Q=read_pump_mmp(mmpid,drop);		  

% Check for minimum # inputs & set pref if not specified
if nargin<5
  disp('  get_thetasd1_mmp: need 5 input arguments')
  break
elseif nargin<6
  pref=0;
end


%%%%%%%%%%%%%% LOAD tc<drop>.mat & check data &&&&&&&&&&&&
% Load tc<drop>.mat
f_str=[procdata FSP cruise FSP 'thetasd' FSP 'tc' int2str(drop) '.mat'];
if exist(f_str)==2
  ld_str=['load ' setstr(39) f_str setstr(39)];
  eval(ld_str)
else
  msg=['  get_thetasd1_mmp: ' f_str ' not found'];
	disp(msg)
  break
end
%
% Check that data exist in tsbe and pr_thetasd
if ~exist('tsbe') | ~exist('pr_thetasd')
  disp('  get_thetasd1_mmp: tsbe or pr_thetasd does not exist')
  break
elseif isempty(tsbe) | isempty(pr_thetasd)
  disp('  get_thetasd1_mmp: tsbe or pr_thetasd is empty')
  break
else
  n_tsbe=length(tsbe); 
  p=pr_thetasd; clear pr_thetasd
  n_p=length(p);
  if n_p~=n_tsbe
    disp('  get_thetasd1_mmp: tsbe & pr_thetasd differ in length')
    break
  end
end
%
% Check that data exist in csbe
if ~exist('csbe')
  disp('  get_thetasd1_mmp: csbe does not exist, assume cond=0')
  cond='zeros';
elseif isempty(csbe)
  disp('  get_thetasd1_mmp: csbe is empty, assume cond=0')
  cond='zeros';
else
  n_csbe=length(csbe);
  if n_csbe==n_tsbe
    cond='observed';
  else
    cond='bad';
  end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%%%%%%%%%%%% Load & apply pr_thetasd & tsbe problem files %%%%%%%%%%%%%%%%%
prob_pr_str=[procdata FSP cruise FSP 'problems' FSP 'pr' int2str(drop) '.mat'];
if exist(prob_pr_str)==2
  pr_str=['load ' setstr(39) prob_pr_str setstr(39)];
  eval(pr_str)
  n_badpr=length(badpr);
  for i=1:n_badpr
    ib=find(p>=badpr(i,1) & p<=badpr(i,2));
	p(ib)=NaN*ones(length(ib),1);
  end
end

% Load tsbe problem files, if they exist, and set badtsbe to NaNs
prob_tsbe_str=[procdata FSP cruise FSP 'problems' FSP 'tsbe' int2str(drop) '.mat'];
if exist(prob_tsbe_str)==2
  t_str=['load ' setstr(39) prob_tsbe_str setstr(39)];
  eval(t_str)
  n_badtsbe=length(badtsbe);
  for i=1:n_badtsbe
    ib=find(p>=badtsbe(i,1) & p<=badtsbe(i,2));
	tsbe(ib)=NaN*ones(length(ib),1);
  end
end
t=tsbe;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%% If needed, calculate s, theta, sigma_theta %%%%%%%%%%%%%
% Test conditions for needing salinity
if strcmp(v2,'th') | strcmp(v2,'th_uf') | strcmp(v3,'s') | strcmp(v4,'sg_th')
  if strcmp(cond,'bad') % Bad cond., can't get salinity
    s=[]; th=[]; sg_th=[];
	%
  elseif strcmp(cond,'zeros') 
    % Assume fresh water
	s=[];
	if strcmp(v2,'th') | strcmp(v2,'th_uf') | strcmp(v4,'sg_th')
	  th=sw_ptmp(zeros(size(tsbe)),tsbe,p,pref);
	  if strcmp(v4,'sg_th')
	    sg_th=sw_dens(zeros(size(tsbe)),th,pref);
	  end
	  disp('   get_thetasd1_mmp: theta and sigma_theta computed for fresh water')
	end
	%
  elseif strcmp(cond,'observed')
    % Calculate salinity for salt water
	%
	% Load csbe problem files, if they exist, and set badcsbe to NaNs
    prob_csbe_str=[procdata FSP cruise FSP 'problems' FSP 'csbe' int2str(drop) '.mat'];
    if exist(prob_csbe_str)==2 & csbe_flag~=0
      c_str=['load ' setstr(39) prob_csbe_str setstr(39)];
      eval(c_str)
      n_badcsbe=length(badcsbe);
	  % Set bad csbe data to NaNs
      for i=1:n_badcsbe
        ib=find(p>=badcsbe(i,1) & p<=badcsbe(i,2));
	    csbe(ib)=NaN*ones(length(ib),1);
      end
    end
    % In preparation for filtering, find blocks of valid data, 
	% i.e. not NaNs, longer than 3 FORDER and apply low-pass filter
    %
	% tsbe blocks 
    tsbe_blocks=find_data_blocks(tsbe,3*FORDER);
    tsbe_lp=NaN*ones(size(tsbe));
    if length(tsbe_blocks) > 0
      for i=1:length(tsbe_blocks)
        tsbe_lp(tsbe_blocks(i,1):tsbe_blocks(i,2)) = ...
	      filtfilt(b,a,tsbe(tsbe_blocks(i,1):tsbe_blocks(i,2)));
      end
    else
      t=[]; s=[]; th=[]; sg_th=[];
      disp('  get_thetasd1_mmp: tsbe contains only NaNs')
	  break
    end
	%
    % csbe blocks
    csbe_blocks=find_data_blocks(csbe,3*FORDER);
    if length(csbe_blocks) > 0
      for i=1:length(csbe_blocks)
        csbe_lp(csbe_blocks(i,1):csbe_blocks(i,2)) = ...
	      filtfilt(b,a,csbe(csbe_blocks(i,1):csbe_blocks(i,2)));
      end
    else
      s=[]; t=tsbe; th=[]; sg_th=[];
	  disp('  get_thetasd1_mmp: csbe contains only NaNs')
	  break
    end 
	%
    % Apply correction for thermal lag of conductivity cell
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
      tlag=NaN*ones(size(tsbe));
	  for i=1:length(tsbe_blocks)
	    if i==1 
		  last_tlag=0; 
		end % take initial lag=0
	    for j=tsbe_blocks(i,1)+1:tsbe_blocks(i,2)-1
	      tlag(j)=-b*last_tlag+a*dt(j-1);
		  last_tlag=tlag(j);
	    end
	  end
      s=salinityfcn(csbe_lp,tsbe_lp-tlag,p);
    else
      s=salinityfcn(csbe_lp,tsbe_lp,p);
    end
    if strcmp(v2,'th') | strcmp(v4,'sg_th')
      th=sw_ptmp(s,tsbe_lp,p);
	  if srcmp(v4,'sg_th')
	    sg_th=sw_dens(s,th,pref);
	  end
    end
    if strcmp(v2,'th_uf')
      th=sw_ptmp(s,tsbe,pref);
    end
    if strcmp(v1,'t')
      t=tsbe_lp;
    end
  end
end

if strcmp(v1,'t_uf')
 t=tsbe;
end
