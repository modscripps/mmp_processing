function Hts=tsplot(s,t,p,d_sigt);
% Usage: Hts=tsplot(s,t,p,d_sigt);
%  inputs: t: potential temperature in deg C
%          s: salinity in concentration units
%          p: pressure in MPa
%          d_sigt: interval to contour sigma_theta

% Function: plot theta - s diagram with sigma_theta contours
% revised to add d_sigt input, 15nov97: mgregg

% Check that salinities are in c.u.  If not mult by .001 & print message
is=find(~isnan(s) & s >= 0);
ns=length(is);
isppt=find(s(is)>1); nsppt=length(isppt);
if nsppt/ns > .1
  s=s*.001;
  disp('tsplot: input salinity multiplied by .001')
end

% Determine boundaries of ts plot in units of degC and 10^4 c.u.
it=find(~isnan(t) & t>0);
mint=floor(min(t(it))); % units of degC, e.g. 22
maxt=ceil(max(t(it)));  % units of degC, e.g. 25
tspan=maxt-mint;
mint=mint-.05*tspan; maxt=maxt+.05*tspan;
mins=floor(min(10000 .* s(is)))/10; % units of ppt, e.g. 34.1
maxs=ceil(max(10000 .* s(is)))/10; % units of ppt, e.g. 35.0
sspan=maxs-mins;
mins=mins-.05*sspan; maxs=maxs+.05*sspan;

% Define array for computing sigma_theta contours
T=linspace(mint,maxt,200); S=linspace(mins,maxs,200);

% Compute sigma_theta for the grid
for i=1:length(T)
	sigt(i,:)=density(0.001.*S,T(i)*ones(1,length(S)),0) ;
end

s = 1000 .* s; % ppt for plotting
sigt=sigt  -  1000;
v=[ceil(min(sigt(:))):d_sigt:floor(max(sigt(:)))];

clf; hold off
c=contour(S,T,sigt,v,'k'); hold on; plot(s,t,'.k')
Hc=clabel(c);
set(gca,'fontsize',14,'ticklength',[.025 .025])

Hxl=xlabel('1000 s'); 
set(Hxl,'fontsize',14)
Hyl=ylabel('\theta / {}^o C');
set(Hyl,'fontsize',14)
