function [obs,pr_obs]=get_obs_mmp(drop);

%function [obs,pr_obs]=get_obs_mmp(drop);
%  created to load processed obs data and do some basic filtering
%		drop=input drop
%		obs=profile of optical backscatter, in ftu
%		associated pressure
%
% created 22/10/98 by j. mackinnon

mmpfolders
cruise=read_cruises_mmp(drop);

	fstr2=[procdata FSP cruise FSP 'obs' FSP 'obs' ];
		eval(['load ' fstr2 int2str(drop)]);
	% median filter
	good = find(~isnan(pr_obs));
	while ~isempty(find(diff(pr_obs(good))<=0))
	  good_ = find(diff(pr_obs(good))>0);
		good=good(good_);
	end;
	good_ = find(~isnan(obs(good))&~isnan(pr_obs(good)));
	good=good(good_);
	
	dp=median(diff(pr_obs(good)));
	filtl=floor(0.02/dp);
	if length(good)>3*filtl
	  obs=filtfilt(ones(filtl,1)./filtl,1,obs(good));
  end;
  pr_obs=pr_obs(good);

