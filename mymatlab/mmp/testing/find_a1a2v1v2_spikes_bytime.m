% find_a1a2v1v2_spikes_bytime.m

% parameters fixed by data structure
FS_hf=400; 		  % sample rate of high-frequency channels
FS_lf=25;		  % sample rate of low-frequency channels
hfperscan=16; 	  % number of samples per scan in high-freq channels

length_rms_scan=32;
adjust_to_max_pressure=1.5e-2;
pressure_min=1.5e-2;
threshold=1.3e-2;

len_rms = length_rms_scan; % number of samples for rms computation
thrshld = threshold; % threshold for rms(diff(a1,a2)) to flag spike

set_mmp_paths
cruise='sc99';
load([procdata '\' cruise '\mmplog'])

drop_list=[9263:9499];

sav_BADs=[]; % accumulate drop,pr_eps,ind#, rms(da1,da2,dv1,dv2), pr(data),scan(data)
for id=1:length(drop_list)
   drop=drop_list(id);
   
   eps_step=512; 	  	      % number of samples per epsilon & estimate
   % Use smaller window for higher resolution in sc99,
   % but increase for slower falling drops (0.25-0.3m/s)
   if drop>8182 & drop<11387
      eps_step=1024;
   end
   scans_per_eps=fix(eps_step/hfperscan); % # scans per eps estimate
   % # scans in downweighted part of Hanning window (25% at 1/6 from ends)
   scTAPER = floor(scans_per_eps/6);
   
   % Need pressure file to proceed
   time=[];
   pr_file = [procdata '\' cruise '\pr\pr' num2str(drop) '.mat'];
   if exist(pr_file)==2
      load(pr_file)
   else
      disp(['find_a1a2v1v2_spikes_bytime.m: Cannot find ' pr_file]);
   end
	% find max pr, as in cal_prscan2_mmp.m from batchprocess_mmp
   [pmax, stop_scan] = max(pr_scan);
   pr_scan(stop_scan+1:end)=NaN;
   
   % Get raw v1 and v2 data
   clear v1 v2 a1 a2
   v1=atod1_mmp(read_rawdata_mmp('v1',drop));
	v2=atod1_mmp(read_rawdata_mmp('v2',drop));
   % Get raw a1 and a2 data
   a1=atod1_mmp(read_rawdata_mmp('a1',drop));
   a2=atod1_mmp(read_rawdata_mmp('a2',drop));
   
   pv1 = pr_offset1_mmp(drop,'v1',pr_scan);
   xx=length(pv1); yy=hfperscan;
   p = interp1( [ fix(yy/2):yy:fix(yy*xx-yy/2) ], pv1, ...
      [ fix(yy/2):1:fix((yy*xx)-(yy/2)) ] );
   xx = length(v1)-length(p)-fix(yy/2);
   pv1 = [NaN*ones(yy/2,1); p'; NaN*ones(xx,1)];
   clear p

 if ~isempty(time) & ~isempty(a1)   
   % Reproduce centers of epsilon data windows from batchprocess_mmp.
   % Windows contain 'scans_per_eps' scans and are half overlapped.
   cntr_scan=(scans_per_eps/2:scans_per_eps/2:stop_scan-scans_per_eps/2);
   neps=length(cntr_scan);
     
   % get epsilon data, check vs cntr_scans
   eps_file = [procdata '\' cruise '\eps\eps' num2str(drop) '.mat'];
   if exist(eps_file)==2
      load(eps_file);
   else
      epsilon=[]; pr_eps=[]; w_eps=[];
      pr_mid = ( pr_scan(cntr_scan) + pr_scan(cntr_scan+1) ) / 2;  
      pr_eps = pr_offset1_mmp(drop,'v1',pr_mid);
   end
   clear eps1 eps2 kc kmax t s
   if ~isempty(pr_eps) & length(pr_eps)~=neps
      disp(['Mismatch of computed windows vs. ' eps_file])
      neps=0;
   end
   
   % get times for start,end of 'steady' downward drop
   ix = find(mmplog(:,1)==drop);
   if ~isempty(ix)
      tBEG = mmplog(ix,12); tEND = mmplog(ix,13);
   else
      tBEG=0; tEND=time(stop_scan);
   end
   % compute corresponding scan numbers
   scBEG=tBEG*FS_lf; scEND=tEND*FS_lf;
   
   % Reproduce sampleNo bounds for windows, as in calc_eps3_mmp.m
   sampLO = cntr_scan*hfperscan - fix(eps_step/2)+1;
   sampUP = cntr_scan*hfperscan + fix(eps_step/2);
   % corresponding scan nos.
   scLO = ceil(sampLO/hfperscan); scUP = ceil(sampUP/hfperscan);
   
   % Find eps-windows outside/inside of downward portion
   OUTind = find(scLO<scBEG | scUP>scEND);
   INind = find(scLO>=scBEG & scUP<=scEND);
   rmsa1=[]; rmsa2=[]; rmsv1=[]; rmsv2=[];
   
   % compute rms(diff(a1,a2,v1,v2)) in small,overlapping intervals
   if length(INind>1)
      sampBEG=sampLO(INind(1)); sampEND=sampUP(INind(end));
      % check rms of diff(a1,a2) for len_rms-points, 50% overlapped
      rmsLB = [sampBEG:fix(len_rms/2):sampEND-len_rms];
      rmsUB = rmsLB+len_rms-1;
      rmsPR = pv1(fix( (rmsLB+rmsUB)/2 )); % pressure at midpoint
      rmsSC = ceil( 0.5*(rmsLB+rmsUB)/hfperscan ); % midpoint scan no.
      
      da1 = [diff(a1); 0]; da2 = [diff(a2); 0];
      dv1 = [diff(v1); 0]; dv2 = [diff(v2); 0];
      
      for ie=1:length(rmsLB)
         rmsa1(ie) = std(da1(rmsLB(ie):rmsUB(ie)), 1);
         rmsa2(ie) = std(da2(rmsLB(ie):rmsUB(ie)), 1);
         rmsv1(ie) = std(dv1(rmsLB(ie):rmsUB(ie)), 1);
         rmsv2(ie) = std(dv2(rmsLB(ie):rmsUB(ie)), 1);
      end
   end % of computing rms(diff(a1,a2,v1,v2))'s
   
   ix=[];
   % flag where accel and airfoils exceed spike threshold,
   %	or where both airfoils have larger spikes
   ix = find( ((rmsa1+rmsa2)>0.14 & (rmsv1+rmsv2)>0.4) | ...
      (rmsv1>0.25 & rmsv2>0.25) );
   
   if ~isempty(ix) & length(INind>1)
      for ie=1:length(INind)
         % flag eps-windows with suspect data (in middle 2/3)
         scA = scLO(INind(ie))+scTAPER;
         scB = scUP(INind(ie))-scTAPER;
         iy = find(rmsSC(ix)>=scA & rmsSC(ix)<=scB);
         for ir=1:length(iy)
            iz = ix(iy(ir));
            sav_BADs = [sav_BADs; drop pr_eps(INind(ie)) INind(ie) ...
                  rmsa1(iz) rmsa2(iz) rmsv1(iz) rmsv2(iz) ...
                  rmsPR(iz) rmsSC(iz) ];
         end % of saving suspect-data attributes
      end % of looping thru eps-windows
   end % of non-empty intervals
 end % of processing non-empty drop
 disp(drop)
 %keyboard
end % of drop loop
   
   
   
     
   if 1==0
      
      close all
      get_epsilon2_mmp(drop);
      figure
      subplot(1,4,1)
      plot(rmsa1,rmsPR,'r-'), grid on, axis ij, set(gca,'xlim',[0 0.15]);
      subplot(1,4,2)
      plot(rmsa2,rmsPR,'b-'), grid on, axis ij, set(gca,'xlim',[0 0.15]);
      subplot(1,4,3)
      plot(rmsv1,rmsPR,'r-',rmsv2,rmsPR,'k-'), grid on, axis ij,...
         set(gca,'xlim',[0 0.40]);
      subplot(1,4,4)
      plot(log10(epsilon(INind,1)), pr_eps(INind),'r.'), grid on, axis ij
      hold on
      plot(log10(epsilon(INind,2)), pr_eps(INind),'b.')
      title(num2str(drop)), zoom on
      plot_mmp_spike_vssampno(drop,0,max(pr_eps)+0.01);
      
   end
   