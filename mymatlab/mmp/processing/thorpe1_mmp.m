function [plb,pub,rmsd,maxd,tlb,tub,slb,sub,nsq]=thorpe1_mmp(drop,p0,p1,variable,change_w_p,threshold,plt);
% thorpe1_mmp
%   Usage: [plb,pub,rmsd,maxd,tlb,tub,slb,sub,nsq]
%          =thorpe1_mmp(drop,p0,p1,variable,change_w_p,threshold,plt);
%      inputs
%        drop: integer drop number
%        p0,p1: lower & upper pressure bounds for analysis
%        variable: 'temp', 'theta', 'salinity', or 'sigma_theta'
%        change_w_p: 'incr' or 'decr', depending on whether
%            mean of variable increases or decreases with pressure
%        threshold: distance in meters for defining overturn from
%            cumsum of displacements.  Usually .01 m.
%        plt: optional string. 'y' to plot outputs
%     Output variables are:
%       	plb, pub: bounds of overturn (MPa)
%       	rmsd,maxd: root-mean-square and maximum displacements (m)
%       	tlb tub slb sub: observed at pr_lb & pr_ub
%       	nsq: across overturns using resorted temp & sal.
%   Function: compute displacements of hydrographic variables in MMP data.
%    	M.Gregg, 22oct98: adapted from thorpe3_amp

nin=nargin;

testing='n';
if strcmp(testing,'y')
  clear
	drop=7000;
	variable='sigma_theta';
	change_w_p='incr';
	threshold=.01;
	plt='n';
	nin=4;
end

G=9.80655;

mmpfolders
cruise=read_cruises_mmp(drop);

if nin<7
  plt='n';
end

% Calculate thetasd profile with theta & sigma_theta referenced to surface
[pr_tsd,temp,theta,sal,sigma_theta]=get_thetasd2_mmp(drop,'t','th','s','sgth',0);

% Select variable to be sorted
str=['v=' variable ';'];
eval(str)
clear theta sigma_theta
sort_variable=variable;

% Remove NaNs from data or terminate if there are no good data
igd=find(~isnan(pr_tsd) & ~isnan(temp) & ~isnan(sal) ...
         & pr_tsd>=p0 & pr_tsd<=p1);
if ~isempty(igd)
  pr_tsd=pr_tsd(igd); temp=temp(igd); sal=sal(igd); 
	v=v(igd);
else
	disp_str=['thorpe1_mmp: ' variable ' empty for MMP' int2str(drop)];
	disp(disp_str)
  return
end

% Determine how v changes with pressure
npts=length(v);
if v(1)>v(npts)
  change_w_p='decr';
elseif v(1)<v(npts)
  change_w_p='incr';
else
  disp_str0=['thorpe1_mmp: ' v ' has zero net change for MMP' int2str(drop)];
	disp(disp_str0)
end 

% Sort profile and get displacements from monotonic profile
[y_mono,displ,pr_thorpe,isort]=sort_profile2(v,pr_tsd,change_w_p);
npts=length(pr_thorpe);

% Find the indices marking the starts and ends of overturns.
% These are determined by summing the displacements and considering
% overturns as the intervals between sum exceeding the threshold
% and then becoming smaller than the threshold.
%	
sum=cumsum(displ);
%
% Select sMMPles with sums > threshold
i_overturn=find(sum>threshold | (displ~=0 & sum<threshold));
%
% Terminate processing if there are no overturns
if isempty(i_overturn)
  disp_str=['thorpe1_mmp: no overturns for MMP' int2str(drop)];
	disp(disp_str)
	return
end
%
% Select first points of an overturn as the first points
% after a gap in the indices of i_overturn.  This will not pick
% up the start of the uppermost overturn.
i_first=i_overturn(find(diff(i_overturn)>1)+1); 
%
% Select the last points in an overturn as the last points
% before a gap in the indices of i_overturn.  This will not pick
% up the bottom of an overturn that ends before the end of the
% record.
i_last=i_overturn(find(diff(i_overturn)>1));
%
% Find the start of the first overturn by checking that
% the first value of i_first should be less than the first
% value of i_last.
if i_first(1)>1 & i_last(1) < i_first(1)
  i_first=[i_overturn(1); i_first];
end
%
% Find the end of the last overturn by checking if the last
% value of i_last is less than the last value of i_first.
if i_last(length(i_last)) < i_first(length(i_first))
  i_last=[i_last; i_overturn(length(i_overturn))];
end

% Determine the pressure bounds of the overturns and the number of
% overturns
pr_lb=pr_thorpe(i_first); pr_ub=pr_thorpe(i_last);
n_overturns=length(i_first);

% Get temperatures and salinities at the top and bottom of the
% overturns; lb & ub correspond to pressure limits, not temp
% or sal limits.
temp_lb=temp(i_first); temp_ub=temp(i_last);
sal_lb=sal(i_first); sal_ub=sal(i_last);

% Compute nsq across the overturns using resorted temp & sal
pr_avg=(pr_lb+pr_ub)/2;
%
% Obtain sorted temp & sal at pr_lb & pr_ub
tl=temp(isort(i_first)); tu=temp(isort(i_last));
sl=sal(isort(i_first)); su=sal(isort(i_last));
%
% Compute potential temp & potential density at pr_avg
%   for sMMPles at tops of overturns (pr_lb)
thl=sw_ptmp(sl,tl,pr_lb,pr_avg); 
sgthl=sw_pden(sl,thl,pr_lb,pr_avg);
%   for sMMPles at bottoms of overturns (pr_ub)
thu=sw_ptmp(su,tu,pr_ub,pr_avg);
sgthu=sw_pden(su,thu,pr_ub,pr_avg);
%
% Use difference in sigma_thetas at pr_avg to compute nsq
nsq=G^2*(sgthu-sgthl)./(1e6*(pr_ub-pr_lb));

% Calculate the rms, mean, and largest displacements in each overturn.
rms_displ=NaN*ones(n_overturns,1); max_displ=NaN*ones(n_overturns,1);
for ii=1:n_overturns
  jj=find(pr_thorpe>=pr_lb(ii) & pr_thorpe<=pr_ub(ii));
  rms_displ(ii)=std(displ(jj));
  abs_displ=abs(displ(jj));
  max_displacement=max(abs_displ);
  imax=find(abs_displ==max_displacement);
  max_displ(ii)=displ(jj(imax(1)));
end

if strcmp(plt,'y')==1
  	figure
	orient landscape
	wysiwyg, wygiwys

	% Overlay measured and resorted profiles on the left
   position1=[.1 .1 .35 .8];
   position1a=[.1 .93 .25 .05];
	axes('position', position1,'ydir','rev','box','on');
	hold on
	pmin=min(min(pr_thorpe),min(pr_tsd));
	pmax=max(max(pr_thorpe),max(pr_tsd));
	plot(y_mono,pr_thorpe,'.')
	plot(v,pr_tsd,'.r')
   set(gca,'ylim',[pmin pmax])
   if strcmp(variable,'temp')
      xstr=['T'];
   elseif strcmp(variable,'theta')
      xstr=['\theta'];
   elseif strcmp(variable,'salinity')
      xstr=['s'];
   elseif strcmp(variable,'sigma_theta')
      xstr=['\sigma_{\theta}'];
   end
	ylabel('p / MPa'),xlabel(xstr)
   title_str=['MMP' int2str(drop)];
   axes('position',position1a,'visible','off')
   axis([0 1 0 1])
   text(.6,0,title_str)
	%title(title_str)
	
	% Plot displacements on the right, marking starts of overturns
	% in green and ends of overturns in red
   position2=[.55 .1 .35 .8];
   position2a=[.55 .93 .25 .05];
	axes('position', position2,'ydir','rev','box','on','yticklabel',[]);
	hold on
  	not=length(i_first);
	npts=length(pr_thorpe);
	ipts=1:npts;
  	% Identify points not in overturns
  	ipts(i_overturn)=zeros(size(i_overturn));
  	i_not=find(ipts~=0);
   
  	plot(displ(i_not),pr_thorpe(i_not),'.','linewidth',2)
  	set(gca,'ylim',[pmin pmax])
  	plot(displ(i_overturn),pr_thorpe(i_overturn),'.','linewidth',2)
  	plot(displ(i_first),pr_thorpe(i_first),'.g','linewidth',2)
  	plot(displ(i_last),pr_thorpe(i_last),'.r','linewidth',2)
  	xlabel('displ / m')
  	titlestr=['overturn threshold = ' num2str(threshold) ' m'];
     %title(titlestr)
   axes('position',position2a,'visible','off')
   axis([0 1 0 1])
   text(.4,0,titlestr)
  
end

plb=pr_lb; pub=pr_ub; tlb=temp_lb; tub=temp_ub; slb=sal_lb; sub=sal_ub;
rmsd=rms_displ; maxd=max_displ;
