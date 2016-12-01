function [epsilon,n2,krho,pr_eps]=get_krho_mmp(drop);
%
[epsilon,pr_eps]=get_epsilon1_mmp(drop);
pr_lb=min(pr_eps);
dp=mean(diff(pr_eps));
[p,t,th,s,sgth]=get_thetasd2_mmp(drop,'t','','s','');
ig=find(~isnan(p) & ~isnan(t) & ~isnan(s));
while ~isempty(find(diff(p(ig))<=0))
	  good = find(diff(p(ig))>0);
		ig=ig(good);
end;
[n2,p_n2,dtdz,dsdz]=nsqfcn(s(ig),t(ig),p(ig),pr_lb,dp);
n2=interp1(p_n2,n2,pr_eps);

krho=.2*epsilon./n2;