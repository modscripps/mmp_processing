function grid3_mmp(cruise,first,filename)
%
% GRID1_MMP  Grid MMP data and store as filename.
%
%

% cruise='cmo96';t1=232.8;t2=233.3;filename='europaHD:boo';
% Make 1m grid for sigmat etc, and 4m grid for epsilon....
%

mmpfolders

% set up the loop variables we need to keep tabs on things:
old_plot=1;  % tells us whether to update the plot...
current = first-1; % tells us what the last drop was...

while 1==1


  % load timeplace.mat
  fstr1=[procdata FSP cruise FSP ]
  eval(['load ' fstr1 'mmplog.mat']);
  timeplace=mmplog;

  % find drops we want from the timeplace matrix
  in = find(timeplace(:,1)>=first);
	in=in(1:300);
  drops=timeplace(in,1);
  yday = timeplace(in,3);
  mmp = timeplace(in,11);
	[procdata FSP cruise FSP 'eps' FSP 'eps'...
	 int2str(current+1)]
	if ~exist([procdata FSP cruise FSP 'eps' FSP 'eps'...
	 int2str(current+1) '.mat']);
	  % do plot...
		if old_plot
		  figure(1);
		  summary_plot4_mmp(filename);
			drawnow;
			old_plot=0;
		end;
		fprintf(1,'Waiting for data drop %d\n',current+1); 
		pause(60);
  else
	  fprintf(1,'Gridding data drop %d\n',current+1);
	  if ~exist(filename)
    % setup dummy variables.  We can reduce their size later...
      ndrops=300;
      Sal = NaN*ones(201,ndrops); Theta=Sal;Eps=Sal(1:4:201,:);Sigmat=Sal;
      pr_theta=[0:0.01:2];
      pr_eps=[0:0.04:2];
      p_obs=0:0.02:2;
      Obs = ones(length(p_obs),ndrops)*NaN;
	  else
		  eval(['load ' filename]);
			good=find(~isnan(yday));
			current=max(drops(good));
	  end;	
    % start loading data.  
    drop=current+1;
		i=drop-first+1; % where in the matrix are we?
    [p,t,th,s,sgth]=get_thetasd2_mmp(drop,'t','th','s','sgth',0);
	  good = find(~isnan(p));
	  while ~isempty(find(diff(p(good))<=0))
	    good_ = find(diff(p(good))>0);
	  	good=good(good_);
  	end;
  	if length(good)>0
      Theta(:,i)=regrid(th(good),p(good),pr_theta)';
      Sal(:,i)=regrid(s(good),p(good),pr_theta)';
      Sigmat(:,i)=regrid(sgth(good),p(good),pr_theta)';
	  end;		
    [epsilon,p]=get_epsilon1_mmp(drop);
	  good = find(~isnan(p));
	  while ~isempty(find(diff(p(good))<=0))
	    good_ = find(diff(p(good))>0);
	    good=good(good_);
	  end;
	  if length(good)>0
      Eps(:,i)=regrid(epsilon(good),p(good),pr_eps)';
    end;
 
	  % Do the obs data
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
	    obs=medfilt1(obs(good),filtl);
	    pr_obs=filtfilt(ones(filtl,1)./filtl,1,pr_obs(good));
    end;
	  okay = find(p_obs>pr_obs(1) & p_obs<=pr_obs(length(pr_obs)));
    Obs(okay,i)=interp1(pr_obs,obs,p_obs(okay));
	  
	  % Save every once in a while in case of crash...
	  pr_obs=p_obs;
	  Epsilon=Eps;
	  eval(['save ' filename ' mmp pr_obs Obs drops yday Epsilon Sal Sigmat Theta pr_eps pr_theta']);
		old_plot=1;
		current=current+1;
  end;
end;

Epsilon=Eps;
pr_obs=p_obs;
eval(['save ' filename ' mmp drops pr_obs Obs yday Epsilon Sal Sigmat Theta pr_eps pr_theta']);
