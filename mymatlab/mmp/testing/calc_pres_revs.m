% calc_pres_revs.m  -  Find time of pressure reversals, and also time
%	when final descent started and when first "end-of-drop" occurred
%	Dave W May-2000

%set_mmp_paths
cruise='sc99';

pDOWN = 0.03; % maximum start-of-drop pressure
pDend = 0.02; % start checking for end-of-drop this far before max-pressure
wREV = 0.03; % fall rates <= wREV are considered upward (slightly>0)
wSLO = 0.17; % flag fall rates < wSLO for further consideration
dNH = 2; % for center-difn fall rate, compute using points +/-dNH away

pr_file = [procdata '\' cruise '\pr\pr' num2str(drop) '.mat'];
if exist(pr_file)==2
   load(pr_file)
   
   clear p t i*
   
   p = pr_scan; t = time;
   fp = dNH+1; lp = length(p)-dNH;
   
   dz = ( p(fp+dNH:lp+dNH) - p(fp-dNH:lp-dNH) ) * 100;
   dt = ( t(fp+dNH:lp+dNH) - t(fp-dNH:lp-dNH) );
   
   for i = dNH-1:-1:1 % use fewer points near ends
      x(1)=( p(2*i+1)-p(1) )*100; x(2)=( p(end)-p(end-2*i) )*100;
      y(1)=( t(2*i+1)-t(1) );  y(2)=( t(end)-t(end-2*i) );
      dz = [x(1); dz; x(2)];  dt = [y(1); dt; y(2)];
   end
   % fwd/bwd difn at ends
   dz = [ (p(2)-p(1))*100; dz; (p(end)-p(end-1))*100 ];
   dt = [ t(2)-t(1); dt; t(end)-t(end-1) ];
   
   w = dz./dt; % FALL RATES (down>0) aligned with pr_scan,time
   dwdt = diff(w)./diff(t); dwdt = [dwdt(1); dwdt]; % bwd difn accel
   
   ix = find(p>=pDOWN); ix=[ix; 1]; % (in case of very short drop)
   tDOWN=t(ix(1)); % first time past pDOWN
   
   [pMAX iMAX] = max(p); % find points beyond when max pressure attained
   if iMAX<length(p)
      p(iMAX+1:end) = NaN; % to exclude post-drop ascent
   end
   
   iDWb = find(w<=wREV & p<pDOWN); % find start of steady descent
   if isempty(iDWb) iDWb=1; else iDWb=iDWb(end)+1; end
   
   iDWe = find(w<=wREV & p>pMAX-pDend); % find first end-of-drop stoppage
   if isempty(iDWe) iDWe=iMAX; else iDWe=iDWe(1)-1; end
   if iDWe<=iDWb
      iDWe=iDWb;
      disp(['calc_pres_revs.m - NO DOWNWARD DATA for drop ' num2str(drop)]);
   end
   
   if iMAX-iDWe>6 disp(drop), end % started up, then went <pDend deeper
   
   pBEG = p(iDWb); tBEG = t(iDWb);
   pEND = p(iDWe); tEND = t(iDWe);
   
   % Now, find reversals between start(down) and stop(up) times
   iREV = find( w<=wREV & t>tBEG & t<=tEND );
   tREV=[]; pREV=[];
   if ~isempty(iREV)
      drev = diff(iREV);
      % find start,end times of reversals
      ix = find(drev>10); % ignore short (0.5-s) "un"-reversals
      iy = 1; % start of first one
      for ia=1:length(ix)
         iy = [iy; ix(ia); ix(ia)+1]; % end of one, start of next
      end
      iREV = [iREV(iy); iREV(end)]; % (add end of last one)
      ix=length(iREV);
      if mod(ix,2)>0  iREV = [iREV; iREV(end)]; end % (just in case)
      tREV(:,1) = t(iREV(1:2:end-1)); pREV(:,1) = p(iREV(1:2:end-1));
      tREV(:,2) = t(iREV(2:2:end)); pREV(:,2) = p(iREV(2:2:end));
   end
   
   % Next, find slow falls between start(down) and stop(up) times
   %iSLO = find( w>0 & (w<=wSLO | dwdt>0.15|dwdt<-0.25) & t>tBEG & t<=tEND );
   iSLO = find( w>wREV & (w<=wSLO) & t>tBEG & t<=tEND );
   tSLO=[]; pSLO=[];
   if ~isempty(iSLO)
      dslo = diff(iSLO);
      % find start,end times of slow falls
      ix = find(dslo>10); % ignore short (0.5-s) non-slows
      iy = 1; % start of first one
      for ia=1:length(ix)
         iy = [iy; ix(ia); ix(ia)+1]; % end of one, start of next
      end
      iSLO = [iSLO(iy); iSLO(end)]; % (add for end of last one)
      ix=length(iSLO);
      if mod(ix,2)>0  iSLO = [iSLO; iSLO(end)]; end % (just in case)
      tSLO(:,1) = t(iSLO(1:2:end-1)); pSLO(:,1) = p(iSLO(1:2:end-1));
      tSLO(:,2) = t(iSLO(2:2:end)); pSLO(:,2) = p(iSLO(2:2:end));
   end
   
   % Pressures refer to depth at pr-gauge
   
   %save([procdata '\' cruise '\prlims\lims' int2str(drop)], ...
   %   'pBEG','pEND','tBEG','tEND','pREV','tREV','pSLO','tSLO');
   
else
   disp(['calc_pres_revs.m - ' pr_file ' not found'])
end