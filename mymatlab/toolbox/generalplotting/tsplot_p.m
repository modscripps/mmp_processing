function tsplot_p(s,t,p,dp,mins,maxs,mint,maxt)
% tsplot_p
% Usage: tsplot_p(s,t,p,dp,mins,maxs,mint,maxt)
%  inputs
%   s is a vector of salinities, in c.u.
%   t is a vector of potential temperatures, in degC
%   p is a vector of pressures, in MPa
%   dp is a number giving the pressure interval to be marked on the ts plot
%   mins, maxs, mint, maxt are optional specifications of the plotting box
% Function:
%      To plot a theta-s diagram for one profile and mark

% Revise input arrays to contain only good data
ig=find(~isnan(t) & ~isnan(s) & ~isnan(p));
t=t(ig); s=1000*s(ig); p=p(ig);

if nargin<=4
  % Determine boundaries of ts plot in units of degC and 10^4 c.u.
  mint=min(t); maxt=max(t);  tspan=maxt-mint;
  mint=floor(mint-.05*tspan); maxt=ceil(maxt+.05*tspan);
  mins=min(s); maxs=max(s); span=maxs-mins;
  mins=floor(10*(mins-.05*span))/10;
  maxs=ceil(10*(maxs+.05*span))/10;
elseif mins<.1 & maxs<.1
  mins=1000*mins; maxs=1000*maxs;
end

% Define array for computing sigma_theta contours
T=mint:0.1:maxt; % e.g. 22, 22.1 , ..., 24.9, 25
S=mins:0.1:maxs; % e.g. 34.1, 34.2, ..., 34.9, 35

% Compute sigma_theta for the grid
sigt=zeros(length(T),length(S));
for i=1:length(T)
	sigt(i,:)=density(0.001 .*S,T(i)*ones(1,length(S)),0)-1000;
end

% calculate sigtref as a vector of sigma_theta values to be contoured
minsigt=min(min(sigt)); maxsigt=max(max(sigt));
sigt_span=maxsigt-minsigt;
if sigt_span>=10
  sigtref=[ceil(minsigt):2:floor(maxsigt)];
elseif sigt_span<10 & sigt_span>=1 % set
  sigtref=[ceil(minsigt/.5)*.5:.5:floor(maxsigt/.5)*.5];
else
  sigtref=[ceil(minsigt/.1)*.1:.1:floor(maxsigt/.1)*.1];
end

clf; hold off
%wysiwyg

c=contour(S,T,sigt,sigtref,'k'); hold on; 
clabel(c)
tsp=plot(s,t,'.k');
set(tsp,'linewidth',[1.5])
set(gca,'fontsize',14,'ticklength',[.025 .025])

Hxl=xlabel('1000 s'); set(Hxl,'fontsize',14)
Hyl=ylabel('\theta / {}^o C'); set(Hyl,'fontsize',14)

% plot circles every dp along the ts curve
% pref is a vector of pressures, in multiples of dp, to place the marks.
% iref is a vector of indices of p values closest to the pref values 
if dp>0
  pref=[ceil(min(p)/dp)*dp:dp:floor(max(p)/dp)*dp];
  iref=NaN*ones(size(pref));
  for i=1:length(pref)
    ip=find(p>=pref(i));
    iref(i)=min(ip);
  end
  plot(s(iref),t(iref),'or')
end

