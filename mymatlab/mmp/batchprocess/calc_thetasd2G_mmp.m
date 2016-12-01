% calc_thetasd2G_mmp.m%   Usage: Called within batchprocess4G_mmp%	 Inputs: drop,cruise,procdata,pr_scan, cond, default_salinity%   Functions: %     1) Calculates SeaBird temperature and conductivity%	     and saves them in <cruise> FSP tc FSP tc<drop>.mat.  %        ** If the string, 'cond' in batchprocess2_mmp is set%             to 'normal', the data are assumed to be good and taken%             in salt water.  If 'cond' is 'fresh', csbe is set%             to zeros.  If 'cond' is 'bad', csbe is set to null. %        ** pr_thetasd is the pr shifted to the input port of%             the SBE sensors (with NaNs after max(pr_scan)).%        ** As is pr_thetasd, tsbe and csbe are shifted forward one%             scan to compensate for the period counting and a%             NaN added to the end to preserve the record length.%             In addition, csbe is shifted another scan to compensate% 			  for the lag in the plumbing re tsbe.%%     2) Calculates salinity after using problems files to set bad data%        to NaNs and low-passing the good data.  Salinity is evaluated with%        temperature corrected for the thermal lag of the conductivity cell.%        ** Salinity is set to an array of zeros for fresh water%           and to an array of default constants when csbe is bad.%	%     3) Calculates the sound speed from salinity,temp,pr_thetasd%		%     4) Several variables are retained in memory during batch processing:	%		   temp: useful sbe temperature (vector), low-passed if salinity is calc.%		   salinity: (vector), ss (vector)%		   pr_thetasd: (vector)%			tsbe: sbe temperature, NOT lowpassed (vector)%		   nthetasd: length of above vectors% M.Gregg, 9jul96;  modified jun-2000 by Dave W to use existing%	tc<drop>.mat data if drop_flag=2 % Added  strcmp(algorithm,'csbe3')  to allow recommended ghij CSBE cal%    -  dpw 4/2014if drop_flag==1 | drop_flag==2   tc_fil = [procdata filesep  cruise filesep 'tc' filesep 'tc' int2str(drop) '.mat'];   tsbe=[]; csbe=[]; pr_thetasd=[];      if drop_flag==2 & exist(tc_fil)==2      load(tc_fil); % retrieve existing temperature,conductivity data      nthetasd = length(pr_thetasd);   else      % calculate tsbe      algorithm=read_algorithm_mmp('tsbe',drop);      str=['tsbe=' algorithm '_mmp(drop);'];      eval(str);            % Calculate pr_thetasd by applying offset to give pressure      % at the entrance to the SBE port      pr_thetasd=pr_offset1_mmp(drop,'tsbe',pr_scan);      nthetasd=length(pr_thetasd);            % process csbe       if strcmp(cond,'bad')         csbe=[];      elseif strcmp(cond,'fresh')         csbe=zeros(size(tsbe));      elseif strcmp(cond,'normal')         algorithm=read_algorithm_mmp('csbe',drop);         % csbe is NaN after max(pr_scan) index, where pr_thetasd=NaN         if strcmp(algorithm,'csbe1')            str=['csbe=' algorithm '_mmp(drop,tsbe,pr_thetasd);'];            eval(str);         elseif strcmp(algorithm,'csbe2') || strcmp(algorithm,'csbe3')            str=['csbe=' algorithm '_mmp(drop,tsbe,pr_thetasd,cond_shift);'];            eval(str);         else            csbe=[];         end      else         csbe=[];      end            % save tsbe, csbe, pr_thetasd      save(tc_fil, 'pr_thetasd', 'tsbe', 'csbe');   end % of processing tsbe,csbe from raw datafile, then saving in tc<drop>.mat       % Calculate salinity	if strcmp(cond,'bad')      salinity=default_salinity*ones(size(csbe));   else      [pr_thetasd,temp,salinity]=salinity2_mmp(drop);      % reloads tc<drop>.mat, lowpasses temp(=tsbe),csbe prior to salin calc	end		% Calculate the sound speed	ss=sw_svel(salinity,tsbe,pr_thetasd);		clear algorithm str csbe tc_filend