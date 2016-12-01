function [p,t,th,s,sgth]=get_thetasd2_mmp(drop,v1,v2,v3,v4,pref)
% Usage: [p,t,th,s,sgth]=get_thetasd2_mmp(drop,v1,v2,v3,v4,pref);
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
%  or potential density from mmp data. If salinity only is
%  wanted, use salinity2_mmp.
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
%	    ** Reads tsbe, csbe, pr_thetasd in <cruise>/tc/tc<drop>.mat
%
%  M.Gregg, 24aug96
% NOTE: Not debugged for fresh water.
% WARNING: Null returned for 't' only
%
%MHA modified for use on MHA machine by calling sw functions with normal
%units - 8/05 

% initialize outputs with null matrices
p=[]; t=[]; th=[]; s=[]; sgth=[];

mmpfolders
cruise=read_cruises_mmp(drop);
mmpid=read_mmpid(drop);

% Compute variables depending on salinity obtained by matching
% temperature and conductivity response functions				 
if strcmp(v2,'th') | strcmp(v2,'th_uf') | strcmp(v3,'s') | strcmp(v4,'sgth')
   [p,t,s]=salinity2_mmp(drop);
   if strcmp(v2,'th') | strcmp(v4,'sgth')
      th=sw_ptmp(s,t,p,pref);
		if strcmp(v4,'sgth')
%         sgth=sw_dens(s,th,pref); 
         sgth=sw_dens(s*1000,th,pref*100); 
		end
	end
end
	
% If any unfiltered record is specified, load tc<drop>.mat
if strcmp(v1,'t_uf') | strcmp(v2,'th_uf') | strcmp(v4,'sgth_uf')
   tc_file=[procdata '\' cruise '\tc\tc' int2str(drop) '.mat'];
   if exist(tc_file)~=2
      file_msg=['get_thetasd2_mmp: ' tc_file ' does not exist.'];
      disp(file_msg)
   else
		load_tc_str=['load ' setstr(39) tc_file setstr(39)];
		eval(load_tc_str)
		%
		% Check that data exist in tsbe, csbe, and pr_thetasd
      if ~exist('tsbe') | ~exist('pr_thetasd') | ~exist('csbe')
         disp('  get_thetasd2_mmp: tsbe, csbe, or pr_thetasd does not exist')
         return
      elseif isempty(tsbe) | isempty(pr_thetasd)
         disp('  get_thetasd2_mmp: tsbe or pr_thetasd is empty')
         return
      elseif isempty(csbe)
         disp('  get_thetasd2_mmp: s=[] because csbe is empty')
      else
         n_tsbe=length(tsbe); n_csbe=length(csbe); n_p=length(pr_thetasd);
         p=pr_thetasd;
			if n_p~=n_tsbe | n_csbe~=n_tsbe
            disp('  get_thetasd2_mmp: tsbe, csbe, pr_thetasd differ in length')
            return
         end
      end
      % Load & apply problem files %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      prob_pr_str=[procdata '\' cruise '\problems\pr' int2str(drop) '.mat'];
      if exist(prob_pr_str)==2
         pr_str=['load ' setstr(39) prob_pr_str setstr(39)];
         eval(pr_str)
         n_badpr=length(badpr);
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
         n_badtsbe=length(badtsbe);
         for i=1:n_badtsbe
            ib=find(pr_thetasd>=badtsbe(i,1) & pr_thetasd<=badtsbe(i,2));
            tsbe(ib)=NaN*ones(length(ib),1);
         end
      end
      %
		if strcmp(v1,'t_uf')
			t=tsbe;
		end
		if strcmp(v2,'th_uf') | strcmp(v4,'sgth_uf')
%			th=sw_ptmp(s,tsbe,p,pref);
			th=sw_ptmp(s*1000,tsbe,p*100,pref*100);
			if strcmp(v4,'sgth_uf')
            %sgth_uf=sw_dens(s,th,pref);
            sgth_uf=sw_dens(s*1000,th,pref*100);
			end
		end
	end
end
	
