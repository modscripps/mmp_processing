function grid4_mmp(startdrop,stopdrop)
%
% GRID4_MMP  Grid MMP data of a specified drop range into 1 m bins
% and place into pre-existing gridded files for each variable.  
%		startdrop=drop to start with
%		stopdrop=last drop to grid
%
% modified from grid2_mmp 22/10/98 by j. mackinnon

mmpfolders
cruise=read_cruises_mmp(startdrop);

% load mmplog
fstr1=[procdata FSP cruise FSP ];
eval(['load ' fstr1 'mmplog.mat']);


% load grids to insert data into
load E:\mmp\bs98\gridded\Sal
load E:\mmp\bs98\gridded\Sigmat
load E:\mmp\bs98\gridded\Theta
load E:\mmp\bs98\gridded\Eps
load E:\mmp\bs98\gridded\N2
load E:\mmp\bs98\gridded\Obs

% find drops we want from the timeplace matrix
in = find(mmplog(:,1)>=startdrop & mmplog(:,1)<=stopdrop);
yday=mmplog(:,3);
mmp=mmplog(:,11);
dp=mean(diff(pr));
ndrops=length(in);

% start loading data.  
for i=1:ndrops;
  	drop=drops(in(i))
  	% start with thetasd quantities
  	[p,t,th,s,sgth]=get_thetasd2_mmp(drop,'t','th','s','sgth',0);
   good = find(~isnan(p));
 	if length(good)>0
    Theta(:,in(i))=regrid(th(good),p(good),pr)';
    Sal(:,in(i))=regrid(s(good),p(good),pr)';
    Sigmat(:,in(i))=regrid(sgth(good),p(good),pr)';
 	end;	
   % do nsq
   [ps,isort]=sort(p);
   ig=find(~isnan(s(isort))&~isnan(t(isort))&~isnan(p(isort)));
   [n2,pn,dthetadz,dsdz]=nsqfcn(s(isort(ig)),t(isort(ig)),p(isort(ig)),pr(1)-dp/2,dp);
    % find appropriate place to stick nsq value
    N2(:,in(i))=interp1(pn,n2,pr)';    
   
    
   % load epsilon, using simple bin averages to regrid
   [epsilon, p]=get_epsilon1_mmp(drop);
    good = find(~isnan(p));
	if length(good)>0
      Eps(:,in(i))=regrid2(epsilon(good),p(good),pr,.01)';
   end;
   
	% load obs data
  	[obsin,p]=get_obs_mmp(drop);
   good = find(~isnan(p));
	if length(good)>0
    Obs(:,in(i))=regrid(obsin(good),p(good),pr)';
  	end;


	% Save every once in a while in case of crash...
	if rem(i,20)==0
      disp('saving intermediate results...')
      save E:\mmp\bs98\gridded\Sal.mat Sal yday drops pr
		save E:\mmp\bs98\gridded\Sigmat Sigmat yday drops pr
		save E:\mmp\bs98\gridded\Theta Theta yday drops pr
		save E:\mmp\bs98\gridded\Eps Eps yday drops pr
		save E:\mmp\bs98\gridded\N2 N2 yday drops pr
		save E:\mmp\bs98\gridded\Obs Obs yday drops pr

   end;
end;

disp('All done :) saving final results...')
save E:\mmp\bs98\gridded\Sal.mat Sal yday drops pr
save E:\mmp\bs98\gridded\Sigmat Sigmat yday drops pr
save E:\mmp\bs98\gridded\Theta Theta yday drops pr
save E:\mmp\bs98\gridded\Eps Eps yday drops pr
save E:\mmp\bs98\gridded\N2 N2 yday drops pr
save E:\mmp\bs98\gridded\Obs Obs yday drops pr

