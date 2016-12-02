function plot_tsreps_mmp(drop,pmin,pmax,tmin,tmax,smin,smax,sgmin,sgmax)

clf

mmpfolders
cruise=read_cruises_mmp(drop);

% load data files
str=['load ' setstr(39) procdata '/' cruise '/thetasd/thetasd' ...
      num2str(drop)  setstr(39)];
eval(str)
str=['load ' setstr(39) procdata '/' cruise '/eps/eps' num2str(drop) ...
     setstr(39)];
eval(str)

theta=potemp(salinity,temp,pr_thetasd);
p0=zeros(length(pr_thetasd),1);
sigtheta=density(salinity,theta,p0)-1000; clear p0;
salinity=1000*salinity;

% pressure  limits and ticks for plots
if nargin==1
  pmin=min(pr_thetasd); pmax=max(pr_thetasd);
end

%
% t, s, sig_theta, set plotting limits to nearest tenth, in deg C, psu, kg/m^3
i_ts=find(pr_thetasd>=pmin & pr_thetasd <= pmax);
tmin=min(theta(i_ts)); tmax=max(theta(i_ts)); tspan=tmax-tmin;
tmin=tmin-.02*tspan; tmax=tmax+.02*tmax;
smin=min(salinity(i_ts)); smax=max(salinity(i_ts)); span=smax-smin;
smin=smin-0.05*span; smax=smax+.05*span;
sgmin=min(sigtheta(i_ts)); sgmax=max(sigtheta(i_ts)); sgspan=sgmax-sgmin;
sgmin=sgmin-.03*sgspan; sgmax=sgmax+.03*sgspan; 
Tlimits=[tmin tmax pmin pmax];                
Slimits=[smin smax  pmin pmax];               
STlimits=[sgmin sgmax pmin pmax];
%

%   plot instructions for temperature, salinity and potential density: 
X = [theta(i_ts)  salinity(i_ts) sigtheta(i_ts)];
Y = pr_thetasd(i_ts) * ones(1,3);
tlabel= ['    theta / deg C     '];
slabel= ['    1000 * s          '];
sglabel=[' sigma_theta / kg m^-3'];
xlabeltext=[tlabel; slabel; sglabel];
ylabeltext='p / MPa';
titletext=' ';		     
linetype = [' r-';' g-';' b-'];
position = [0.15 0.4 0.35 0.5];
dy = 0.086;
limits=[ Tlimits; Slimits; STlimits ];
multixaxis(X,Y,xlabeltext,ylabeltext,titletext,linetype,position,dy,limits);

%  epsilon plot in second panel	
i_eps=find(pr_eps>=pmin & pr_eps<=pmax);
epsilon=eps1(i_eps);
pr_eps=pr_eps(i_eps);
  
epsmin=min(epsilon(~isnan(epsilon))); epsmax=max(epsilon(~isnan(epsilon)));

linetype = [' r-';' g-'];
format short e

axes('position',[0.55 0.4 0.3 0.5],'ydir','reverse','box','on', ...
     'xscale','log','ticklength',[0.03 0.03],'yticklabels',' ');
hold on
h=fillstair(epsilon,pr_eps,'y',epsmin,[0.8 0.8 0.8],'w');
axis([epsmin epsmax pmin pmax])
set(gca,'layer','top')
sxlabel('\16\times {\16 \symb e} / W kg^{-1}');

% add labelfor amp drop number below epsilon plot
plabel=['MMP' num2str(drop)];
axes('position',[0.65 0.3 0.2 0.1],'box','off','xtick',[],'ytick',[], ...
     'xcolor','k','ycolor','k');
text(0,0,plabel);
