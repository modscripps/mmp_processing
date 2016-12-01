% calc_prscan3G_mmp.m
%   Usage: Called within batchprocess4G_mmp, starting with drop 7700 (2nd round)
%   Function: Calculate gauge pressure.
%	It creates and saves:		
%			pr_scan:	gauge pressure (vector)
%			time: elapsed time for scans (vector)
%			nscans: number of scans (integer)
%			stop_scan: last useful scan (integer)
%        pmin, pmax: pressure limits (absolute extrema)
%  J.MacKinnon 24 Oct 96  Revised to save mmplog after editing it;
%  D.Winkel jun-2000, don't modify existing files if drop_flag=2

if drop_flag==1 | drop_flag==2
   pr_fil = [procdata '\' cruise '\pr\pr' int2str(drop)];
   log_fil = [procdata '\' cruise '\mmplog'];
   pr_scan=[]; time=[];
   
   if drop_flag==2 & exist(pr_fil)==2
      load(pr_fil); % retrieve existing pressure,time data
      nscans = length(pr_scan);
   else
      % read name of pressure algorithm & call
      algorithm=read_algorithm_mmp('pr',drop);
      str=['pr_scan=' algorithm '_mmp(drop);'];
      eval(str)
      nscans=length(pr_scan);
      % Calculate a vector of scan times
      time=(1:nscans)/FS_lf; time=time(:);
      % Save pressure and time records 
      if isempty(pr_scan)
         disp('   No pressure, terminate further processing of drop')
         drop_flag=0;
         break
      else
         save(pr_fil, 'pr_scan', 'time');
      end
   end
   
   % Determine minimum and maximum pressures
   pmin = min(pr_scan);
   [pmax, stop_scan] = max(pr_scan);
   % For subsequent processing, place NaN's past deepest pressure (mmp ascending)
   pr_scan(stop_scan+1:nscans)=NaN*ones(nscans-stop_scan,1);
   
   % Write pmin and pmax in mmplog for cruise (unless reprocessing w/drop_flag=2)
   load(log_fil)
   irow=find(mmplog(:,1)==drop); sv=0;
   if isnan(mmplog(irow,7)) | drop_flag==1
      mmplog(irow,7)=pmin; sv=1;
   end
   if isnan(mmplog(irow,8)) | drop_flag==1
      mmplog(irow,8)=pmax; sv=1;
   end
   if sv>0
      save(log_fil, 'mmplog')
   end
   
   % Calculate instantaneous fall rate
   dp=diff(pr_scan);
   dp=[dp(1); dp]; % duplicate 1st value so # dp = # pr
   dt=1/FS_lf; % time interval between scans
   w=100*dp/dt;
   
   clear str algorithm irow pr_fil log_fil mmplog
   
end
