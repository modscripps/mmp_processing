function plot_thetasd_mmp(drop,pmin,pmax,tmin,tmax,smin,smax)
% plot_thetasd_mmp
%   USAGE: plot_thetasd_mmp(drop,pmin,pmax,tmin,tmax,smin,smax)
%      drop is the integer drop number
%      pmin & pmax are the pressure limits in MPa
%      tmin & tmax are the potential temperature limits in degC
%      smin & smax are the salinity limits in psu
%   FUNCTION: to plot potential temperature, salinity, & sigma_theta for a drop

% read thetasd file
mmpfolders;
cruise=read_cruises_mmp(drop);
str=['load ' setstr(39) procdata filesep cruise filesep ...
      'thetasd' filesep 'thetasd' num2str(drop) setstr(39)];
eval(str)

% compute potential temperature and potential density
theta = potemp(salinity,temp,pr_thetasd);
len=length(temp);
p0=zeros(len,1);
sigtheta=density(salinity,theta,p0)-1000;
salinity=1000*salinity;
clear temp

% set plotting limits
if nargin<=5 % compute salinity plotting limits to nearest tenth psu
	smin=min(salinity); smax=max(salinity);
end
if nargin <=3 % compute temp plotting limits to nearest tenth deg
	tmin=min(theta); tmax=max(theta);
end
if nargin <=1 % compute p plotting limits to nearest .01 MPa
	pmin=min(pr_thetasd); pmax=max(pr_thetasd);
end
sgmin=min(sigtheta); sgmax=max(sigtheta);  

Tlimits=[tmin tmax pmin pmax];               
Slimits=[smin smax  pmin pmax];              
STlimits=[sgmin sgmax pmin pmax];

% setup plot for two or three channels depending on whether salinity is zero
if smin==0 & smax==0
	X = [theta(:)  sigtheta(:)];
	Y = pr_thetasd(:) * ones(1,2);
	limits=[ Tlimits; STlimits ];
	xlabeltext=     ['    theta / deg C    ';
                     'sigma_theta / kg m^-3'];
	linetype = [' r-'; ' b-'];
else
	X = [theta(:)  salinity(:) sigtheta(:)];
	Y = pr_thetasd(:) * ones(1,3);
	limits=[ Tlimits; Slimits; STlimits ];
	xlabeltext=     ['    theta / deg C    ';
                     '      1000 * s       ';
                     'sigma_theta / kg m^-3'];
	linetype = [' r-';' g-';' b-'];
end

ylabeltext='p / MPa';
titletext=['mmp' num2str(drop)];		     
position = [0.15 0.25 0.8 0.6];
dy = 0.06;
clf
orient tall
multixaxis(X,Y,xlabeltext,ylabeltext,titletext,linetype,position,dy,limits);
 

