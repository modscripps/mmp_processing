% calc_hofp3G_mmp - compute height-above-bottom vs pressure from altimeter data
%  inputs:
%		drop, cruise, procdata
%		pr_scan: gauge pressure
%		ss: sound speed

%  outputs:

%		Saved in ac<drop>.mat are vectors hout,pout:

%			height and pressure at the altimeter;

%		Passed along for subsequent batchprocessing and plotting are:

%			h_tsbe,prh_tsbe [vectors]: height, pressure at the SeaBird temp sensor;

%			pbot [vector]: pressure at the seafloor, infered from h_tsbe,prh_tsbe;

%			hout,pout [scalars]: height,pressure (at altimeter) nearest the bottom;

%			last_pbot [scalar]: pbot determined nearest the bottom;

%				This is also saved in mmplog.mat in the 10th column.

%		

% This script and function=get_hofp2G_mmp.m  modify scripts calc_hofp2_mmp.m

%	(J. MacKinnon Oct 10, 1996) and calc_altimeter2_mmp.m (Mike??), and

%	function=get_hofp1_mmp.m;   NOTE that here, the reference for saved

%	height and pressure is at the altimeter, while the earlier versions

%	sometimes refered pressure to the pressure port.  This version's first

%	use was in post-processing SC99 data - D. Winkel, June-2000



if drop_flag==1 | drop_flag==2

   ht_fil = [procdata filesep  cruise filesep 'ac' filesep 'ac' int2str(drop) '.mat'];

   log_fil = [procdata filesep  cruise filesep 'mmplog'];

   hout=[]; pout=[]; h_tsbe=[];

   

   if drop_flag==2 & exist(ht_fil)==2

      load(ht_fil); % retrieve existing height,pres (at altimeter) data

   else

      % compute altimeter height,pressure from raw data file

      [hout, pout] = get_hofp2G_mmp(drop,'ac',pr_scan,ss);

      if ~isempty(hout) & ~isempty(pout)

         save(ht_fil, 'pout', 'hout');

      end

   end

   

   botmax = NaN; hmax=NaN; pmax=NaN;

   %% Prepare data for subsequent plots, mmplog.mat

   if ~isempty(hout) & ~isempty(pout)

      ppr=[1 2]; % insures 'downward' interpretation by pr_offset1_mmp.m

      pac=pr_offset1_mmp(drop,'ac',ppr);

      ptc=pr_offset1_mmp(drop,'tsbe',ppr);

      dp = ptc(1)-pac(1);

      % save height,pressure at SeaBird temp,cond (for motionplot1_mmp.m)

      prh_tsbe = pout + dp;

      h_tsbe = hout - (dp*100);

      % Calculate pbot, pressure at sea floor
      pbot=0.01*h_tsbe+prh_tsbe;

      

      % Find deepest pressure and corresponding GOOD height and bottom depth

      ig = find(~isnan(pout) & ~isnan(hout)); % find where BOTH are good

      if ~isempty(ig)

         [pmax, i_max] = max(pout(ig));

         hmax = hout(ig(i_max));

         botmax = pbot(ig(i_max));

      end

   end

   hout=hmax; pout=pmax;

   

   %% Enter bottom pressure determined nearest the bottom in mmplog.mat

   load(log_fil)

   irow = find(mmplog(:,1)==drop);

   last_pbot = mmplog(irow,10);

   

   %% If existing value is NaN or drop_flag=1, update mmplog.mat

   if ( isnan(last_pbot) ) | drop_flag==1

      last_pbot = botmax;

      mmplog(irow,10)=last_pbot;
      save(log_fil, 'mmplog');

   end

   

   clear ht_fil log_fil pmax hmax botmax irow ig i_max gp ppr pac ptc mmplog

end
















