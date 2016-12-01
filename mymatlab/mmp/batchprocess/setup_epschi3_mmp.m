% setup_epschi3_mmp.m - This revision sets pr_eps to correspond to END
%	of cntr_scan, rather than at MIDDLE; and computes fallrate w_eps by
%	averaging w's over MIDDLE HALF of data window, rather than just
%  taking w AT cntr_scan - Dave W, June 2000
% Input: drop, pr_scan, scans_per_eps, temp, salinity, w
% Output: cntr_scan, neps,pr_eps,w_eps, t,s,kvis,ktemp, nchi,pr_chi
if drop_flag==1 | drop_flag==2
  %
  % Compute centers of eps and chi data windows.  Windows
  % contain 'scans_per_eps' scans and are half overlapped.
  cntr_scan=(scans_per_eps/2:scans_per_eps/2:stop_scan-scans_per_eps/2);
  
  neps=length(cntr_scan);
  if neps>0
     pr_endsc = ( pr_scan(cntr_scan)+pr_scan(cntr_scan+1) ) / 2;  
     pr_eps=pr_offset1_mmp(drop,'v1',pr_endsc);
     t=temp(cntr_scan);
     s=salinity(cntr_scan);
     kvis=nu(s,t,pr_eps); ktemp=kt(s,t,pr_eps);
     
     w_scns = fix(scans_per_eps/4);
     for ic=1:neps
        w_eps(ic) = nanmean(w(cntr_scan(ic)-w_scns:cntr_scan(ic)+w_scns));
     end
     w_eps=w_eps(:); % for column vector
     
     nchi=neps;
     pr_chi=pr_offset1_mmp(drop,'th1',pr_endsc);
  else
     pr_eps=[]; t=[];s=[];kvis=[];ktemp=[]; w_eps=[]; nchi=0; pr_chi=[];
  end
  
  clear pr_endsc w_scns
end