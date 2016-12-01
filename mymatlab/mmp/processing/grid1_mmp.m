% function grid1_mmp(cruise,t1,t2,filename)
%
% GRID1_MMP  Grid MMP data and store as filename.
%
%
% Make 1m grid %

mmpfolders

% load timeplace.mat
fstr1=[procdata FSP cruise FSP ];
eval(['load ' fstr1 'mmplog.mat']);
timeplace=mmplog;

% find drops we want from the timeplace matrix
in = find(timeplace(:,3)>=t1 & timeplace(:,3)<=t2);
drops=timeplace(in,1);
yday = timeplace(in,3);
mmp = timeplace(in,11);
% setup dummy variables.  We can reduce their size later...
ndrops=length(drops);
Sal = NaN*ones(305,ndrops); Theta=Sal;Eps=Sal(1:305,:);Sigmat=Sal;
pr_avg=[0:0.01:3.05]; pr_theta=pr_avg; pr_eps=pr_avg;
% start loading data.  
for i=1:ndrops;
  drop=drops(i)
  [p,t,th,s,sgth]=get_thetasd2_mmp(drop,'t','th','s','sgth',0);
	good = find(~isnan(p));
	while ~isempty(find(diff(p(good))<=0))
	  good_ = find(diff(p(good))>0);
		good=good(good_);
	end;
	if length(good)>0
		goodth=find(~isnan(th(good)));
		good_=good(goodth);
    	okay = find(pr_theta>p(good_(1)) &...
	     pr_theta<p(good_(length(good_))));
      Theta(okay,i)=interp1(p(good_),th(good_),...
		  pr_theta(okay));
		goods=find(~isnan(s(good)));
		good_=good(goods);
   	okay = find(pr_theta>p(good_(1)) &...
	   pr_theta<p(good_(length(good_))));
      Sal(okay,i)=interp1(p(good_),s(good_),...
		  pr_theta(okay));
		goodst=find(~isnan(sgth(good)));
		good_=good(goodst);
    	okay = find(pr_theta>p(good_(1)) &...
	     pr_theta<p(good_(length(good_))));
      Sigmat(okay,i)=interp1(p(good_),...
		  sgth(good_),pr_theta(okay));
			
      [epsilon,p]=get_epsilon1_mmp(drop);
	   good = find(~isnan(p));
	   while ~isempty(find(diff(p(good))<=0))
	     good_ = find(diff(p(good))>0);
	     good=good(good_);
		end;
		if length(good)>0
		  goode=find(~isnan(epsilon(good)));
		  good_=good(goode);
		  okay = find(pr_eps>p(good_(1)) &...
	       pr_eps<p(good_(length(good_))));

        Eps(okay,i)=interp1(p(good_),...
		    epsilon(good_),pr_eps(okay));
      end;
   end;
 end;
eval(['save ' filename ' Eps Sal Sigmat Theta pr_avg']);
