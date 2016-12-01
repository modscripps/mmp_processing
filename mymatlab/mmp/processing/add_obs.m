% function add_obs(filename)
%
% ADD_OBS add obs grid to the grid data in filename 
%
% Temporary routine....
%
cruise = 'cmo97';
filename='europaHD:CMO97:yday115';
% cruise='cmo96';t1=232.8;t2=233.3;filename='europaHD:boo';
% Make 1m grid for sigmat etc, and 4m grid for epsilon....
%

mmpfolders

% load timeplace.mat
fstr1=[procdata FSP cruise FSP 'obs' FSP 'obs' ]

eval(['load ' filename]);

[n_pr,ndrops]=size(Epsilon);

% put on a 2m grid
p_obs=0:0.02:2;
Obs = ones(length(p_obs),ndrops)*NaN;
for i=1:ndrops;
  drop=drops(i)
	eval(['load ' fstr1 int2str(drop)]);
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
	  obs=medfilt1(obs(good),filtl);
	  pr_obs=filtfilt(ones(filtl,1)./filtl,1,pr_obs(good));
  end;
	okay = find(p_obs>pr_obs(1) & p_obs<=pr_obs(length(pr_obs)));
  Obs(okay,i)=interp1(pr_obs,obs,p_obs(okay));
end;
pr_obs=p_obs;
eval(['save ' filename ' mmp drops yday Epsilon Sal Sigmat Theta Obs pr_eps pr_theta pr_obs']);
