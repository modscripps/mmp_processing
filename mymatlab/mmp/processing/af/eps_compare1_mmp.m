function eps_compare1_mmp(drop,cruise,procdata)
% eps_compare1_mmp
%   Usage: eps_compare1_mmp(drop)
%   Function: Load MMP:cruise:eps:eps<drop>.mat and compute epsilon as the average
%     of eps1 & eps2 when they differ less than fourfold.  The lower is taken when
%     eps1 and eps2 differ more than a factor of 4.  The same is done to compute
%     epsilond using the direct estimates, epsd1 & eps2d.  epsilon, epsilond, 
%     and pr_eps are saved in the cruise:epsilon directory as epsilon<drop>.mat
%	  M.Gregg, 6 March 1995

EPS_RATIO=4; % allowable ratio between eps1 & eps2

% read mmpfolders to get procdata string if it is not input
if nargin<3
	mmpfolders;
end
% get cruise if it is not input
if nargin<2
	cruise=read_cruises_mmp(drop);
end

% load MMP\cruise\eps\eps<drop>.mat
str=['load ' setstr(39) procdata '\' cruise '\eps\eps' num2str(drop) setstr(39)];
eval(str)

% setup output arrays
len=length(eps1);
epsilon=NaN*ones(len,1); epsilond=NaN*ones(len,1);

% find & average standard epsilons differing less than EPS_RATIO
igood=find(eps1<EPS_RATIO*eps2 & eps1>eps2/EPS_RATIO);
x=[eps1(igood) eps2(igood)];
epsilon(igood)=mean(x')';

% take the lowest of those differing more than EPS_RATIO
ibad=isnan(epsilon);
x=[eps1(ibad) eps2(ibad)];
epsilon(ibad)=min(x');

% find & average direct-integration epsilons differing less than EPS_RATIO
igood=find(eps1d<EPS_RATIO*eps2d & eps1d>eps2d/EPS_RATIO);
x=[eps1d(igood) eps2d(igood)];
epsilond(igood)=mean(x')';

% take the lowest of those differing more than EPS_RATIO
ibad=isnan(epsilond);
x=[eps1d(ibad) eps2d(ibad)];
epsilond(ibad)=min(x');

% save the averages
str=['save ' setstr(39) procdata '\' cruise '\epsilon\epsilon' ...
      num2str(drop) '.mat'  setstr(39) ' epsilon epsilond pr_eps'];
eval(str)
