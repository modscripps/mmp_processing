function [eps,n2,krho,pr_krho]=krho_drops(drops,pr_lb,pr_ub,dp);
%[eps,n2,krho,pr_krho]=krho_drops(drops,pr_lb,pr_ub,dp) :
% for a sequence of mmp drops, compute average epsilon, n-squared, and k_rho
% over pressure windows of thickness dp, the first starting at pr_lb, the last
% ending before pr_ub
pavg = (pr_lb+dp/2:dp:pr_ub); % maximum array of output pressures
nprs = length(pavg); % max number of rows
ndps = length(drops); % max number of columns
eparr = NaN * ones(nprs,ndps);
n2arr = eparr;
id = 1;
% compute pressure avg'd epsilon, nsq for each drop,
% place in arrays at appropriate position
while id <= ndps
   drop=drops(id);
   [p,t,th,s,sgth]=get_thetasd2_mmp(drop,'t','','s','');
   
   ig=find(~isnan(p) & ~isnan(t) & ~isnan(s));
   [n2,p_n2,dtdz,dsdz]=nsqfcn(s(ig),t(ig),p(ig),pr_lb,dp);
   p_iof = 0; pn2of=p_n2(1);
   while pn2of > pr_lb + 1.01*(dp/2)
      p_iof=p_iof+1; pn2of=pn2of-dp;
   end
   ia = find(~isnan(n2)&p_n2<pr_ub);
   n2arr(ia+p_iof,id) = n2(ia);
   
   [epsilon,pr_eps]=get_epsilon1_mmp(drop);
   [eps_avg,n_epsavg,p_epsavg]=average_p(epsilon,pr_eps,pr_lb,pr_ub,dp);
   ia = find(~isnan(eps_avg));
   eparr(ia,id) = eps_avg(ia);
   
   id = id+1;
end

% avg over drops
if ndps>1
   eps = nanmean(eparr');
   n2 = nanmean(n2arr');
else
   eps=eparr';
   n2=n2arr';
end

krho=0.2*eps./n2;
pr_krho=pavg;
