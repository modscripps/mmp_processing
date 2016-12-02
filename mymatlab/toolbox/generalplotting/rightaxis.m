function rightaxis(n);
% RIGHTAXIS Plots axes with origin in the upper right, rather
%           than lower left. Call this *after* you finish fiddling
%           with setting xtick, ylim, and all those other properties.
%          
%           RIGHTAXIS(1) - only draws the vertical axis
%

% Author: R. Pawlowicz (rich@boreas.whoi.edu).

nin=nargin;
if (nin<1) n=2; end;

ticklen=get(gca,'ticklength');
yy=get(gca,'ylim');
Xt=get(gca,'xtick');
Xl=get(gca,'xticklabel');
Yt=get(gca,'ytick');
Yl=get(gca,'yticklabels')
Xlm=get(gca,'xlim');
Ylm=get(gca,'ylim');
bk=1-get(gcf,'color');

line(Xlm(2)*[1 1],Ylm,'color',bk);
line([max(Xlm);max(Xlm)-ticklen(1)*diff(Xlm)]*ones(size(Yt)),[1;1]*Yt,'color',bk);
text((max(Xlm)+ticklen(1)*diff(Xlm))*ones(size(Yt)),Yt,Yl,'horiz','left','verti','middle','clip','off','color',bk);

if (n==2), 
%line([min(Xt) max(Xt)],Ylm(2)*[1 1],'clip','off','color',bk);
line(Xlm,Ylm(2)*[1 1],'clip','off','color',bk);
line([1;1]*Xt,[max(Ylm);max(Ylm)-ticklen(1)*diff(Ylm)]*ones(size(Xt)),'color',bk);
%text(Xt,(max(Ylm)+ticklen(1)*diff(Ylm))*ones(size(Xt)),Xl,'horiz','center','verti','bottom','clip','off','color',bk);

end;

set(gca,'visible','off','xticklabel',[],'yticklabel',[]);
