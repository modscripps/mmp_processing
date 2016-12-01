%function [krho,pr_krho]=krho_mmp(drop,pr_lb,pr_ub,dp);

[p,t,th,s,sgth]=get_thetasd2_mmp(drop,'t','','s','');

ig=find(~isnan(p) & ~isnan(t) & ~isnan(s));
[n2,p_n2,dtdz,dsdz]=nsqfcn(s(ig),t(ig),p(ig),pr_lb,dp);

[epsilon,pr_eps]=get_epsilon1_mmp(drop);
[eps_avg,n_epsavg,p_epsavg]=average_p(epsilon,pr_eps,pr_lb,pr_ub,dp);

neps=length(eps_avg); nn2=length(n2);
if nn2~=neps
  npts=min(neps,nn2);
else
  npts=neps;
end

krho=0.2*eps_avg(1:npts)./n2(1:npts);
pr_krho=p_n2(1:npts);
