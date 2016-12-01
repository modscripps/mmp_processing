function [a1,a2,a3,a4]=summary_plot1_mmp(filename);
% make a summary plot of the gridded data in "filename"
% function [a1,a2,a3,a4]=summary_plot1_mmp(filename);
%  
% filename must contain pr_eps, pr_theta, mmp_yday, Sal, Theta,
% Sigmat, Eps. 

eval(['load ' filename]);
good = find(~isnan(yday));
yday=yday(good);drops=drops(good);mmp=mmp(good);
Epsilon=Epsilon(:,good); Sal=Sal(:,good); Theta=Theta(:,good);
Sigmat=Sigmat(:,good); Obs=Obs(:,good);

% add NaN between data gaps greater that 0.5 hours....
in = find(diff(yday)>0.0208)
for i = 1:length(in)
  ins=in(i);
	N= length(yday);
  yday = [yday(1:ins); yday(ins)+0.0001; yday(ins+1:N)];
	mmp = [mmp(1:ins); 0; mmp(ins+1:N)];
	drops = [drops(1:ins); NaN; drops(ins+1:N)];
	Epsilon = [Epsilon(:,1:ins)...
	  NaN*Epsilon(:,1) Epsilon(:,ins+1:N)];
	Sal = [Sal(:,1:ins)...
	  NaN*Sal(:,1) Sal(:,ins+1:N)];
	Sigmat = [Sigmat(:,1:ins)...
	  NaN*Sigmat(:,1) Sigmat(:,ins+1:N)];
	Theta = [Theta(:,1:ins)...
	  NaN*Theta(:,1) Theta(:,ins+1:N)];
	Obs = [Obs(:,1:ins)...
	  NaN*Obs(:,1) Obs(:,ins+1:N)];
	in = in+1;
end;

mmp=mmp';
drop=drops;
minx=min(yday); maxx=max(yday); miny=0; maxy=max(pr_theta);
% miny=0;maxy=
deltax=maxx-minx; deltay=maxy-miny;

% Setup the contouring intervals:
sigmatv = [24.75:0.025:26];
thetav =[10:0.1:18];
epsv   = [-10:1:1];
salv   = [33.68:0.005:33.85];

% Setup the colormaps...
sigmacax=[24.8 26];
thetacax=[10 16];
salcax  =[33.6 33.84];
epscax  =[-10 -6];

% Setup style of the plot
clf
colormap(jet);
set(gcf,'defaulttextfontweight','bold');
set(gcf,'defaultaxesfontweight','bold');
set(gcf,'defaultaxesfontsize',12);
set(gcf,'defaulttextfontsize',12);
whitebg('w');
% set(gcf,'color',[1 1 1]);
set(gcf,'defaultaxescolor',[0.75 0.75 0.75]);
orient tall;

% Setup axes positions...
dy=0.05;
dx=0.05;
bott=0.075;
width=1-3*dx;
height=1-(5)*dy;height=height/4;
pos1=[2.2*dx 1-3*dy-height width height];
pos2=[2.2*dx 1-3*dy-2*height width height];
pos3=[2.2*dx 1-3*dy-3*height width height];
pos4=[2.2*dx 1-3*dy-4*height width height];
top_axis = [2.2*dx 1-1.5*dy width 0.01];
lab_axis = [2.2*dx 1-2.5*dy width 0.01];
% We want to put a label near the bottom approximately 8/10 to 9/10 of
% the way across for all plots...
xl = minx + 0.8*deltax; xw = 0.185*deltax;
yl = maxy - 0.1*deltay; yw = 0.125*deltay;

% Label the drops:
axes('units','normalized','position',lab_axis,'visible','off');
axis([minx maxx 0 1]);

cm=hsv(3);
hold on;
in = [0 find(diff(mmp)~=0)]+1;
for j=1:length(in)
  i = in(j)
	if mmp(i)>0
    plot([yday(i) yday(i)],[0 0.5],'color',cm(mmp(i),:));
    text(yday(i),0.5,int2str(drop(i)),'color',cm(mmp(i),:),...
    'rotation',50,'fontsize',9);
    for k=i:10:in(min(j+1,length(in)))-5
      plot([yday(k) yday(k)],[0 0.5],'color',cm(mmp(k),:));
      text(yday(k),0.5,int2str(drop(k)),'color',cm(mmp(k),:),...
    'rotation',50,'fontsize',9);
    end;
  end; 
end;
hold on;
for i=1:length(drop)
	if mmp(i)>0
    plot(yday(i),0,'.','color',cm(mmp(i),:));
  end;
end;	

% Do the title:
axes('units','normalized','position',top_axis);
axis([0 1 0 1]);
set(gca,'visible','off');
% get the date...
yday_off=yearday(1,4,1997,0,0,0)-1;
ydmin=min(yday);ydmax=max(yday);
day = [ydmin ydmax]-yday_off; 
bad = find(day>=31);
month=[4 4];
if ~isempty(bad)
  day(bad)=day(bad)-30;
	month(bad)=5+ 0*bad;
end;
hour = 24*(day-floor(day));
minute = floor(60*(hour-floor(hour))); 
hour = floor(hour);
day=floor(day);
if month(1)==4
  month1='Apr';
else
	month1='May';
end;
if month(2)==4
  month2='Apr';
else
	month2='May';
end;

  text(0,0,['CMO 97   APL/UW  Gregg/Miller  ']);
	text(0.6,0,['From: ' ...
	 int2str(day(1)) ' ' month1 ' 97 '...
	  int2str(hour(1)) int2str(minute(1))...
		'   To: '  int2str(day(2)) ' ' month2 ' 97 '...
	  int2str(hour(2)) int2str(minute(2))],'fontsize',10);


% Do the Temperature axis
axes('units','normalized','position',pos1);
axis('ij');
h=pcolor(yday,pr_theta,Theta);
set(h,'edgecolor','none');
patch([xl xl xl+xw xl+xw],[yl yl-yw yl-yw yl],...
  1*[1000 1000 1000 1000],'w');
text(xl,yl-yw,2000,'Theta / C','verticalalign','top');
axis([minx  minx+deltax miny miny+deltay]);
set(gca,'xticklabels',[]);
ylabel('p / MPa');
axis('ij');
caxis(thetacax);

% Do the Salinity axis
axes('units','normalized','position',pos2);
axis('ij');
h=pcolor(yday,pr_theta,1000*Sal);
set(h,'edgecolor','none');

patch([xl xl xl+xw xl+xw],[yl yl-yw yl-yw yl],[1000 1000 1000 1000],'w');
text(xl,yl-yw,2000,' S / psu','verticalalign','top');
axis([minx  minx+deltax miny miny+deltay]);
set(gca,'xticklabels',[]);
ylabel('p / MPa');
axis('ij');
caxis(salcax);

% Do the Sigmat axis

axes('units','normalized','position',pos3);
axis('ij');
h=pcolor(yday,pr_theta,Sigmat-1000);
set(h,'edgecolor','none');

patch([xl xl xl+xw xl+xw],[yl yl-yw yl-yw yl],[1000 1000 1000 1000],'w');
text(xl,yl-yw,2000,' sigma_theta','verticalalign','top');
axis([minx  minx+deltax miny miny+deltay]);
set(gca,'xticklabels',[]);
ylabel('p / MPa');
axis('ij');
caxis(sigmacax)

axes('units','normalized','position',pos4);
axis('ij');
bad=find(isnan(Epsilon));
logE=log10(Epsilon);
logE(bad)=0*bad;
h=pcolor(yday,pr_eps,logE);
set(h,'edgecolor','none');

caxis(epscax);
patch([xl xl xl+xw xl+xw],[yl yl-yw yl-yw yl],[1000 1000 1000 1000],'w');
text(xl,yl-yw,2000,'log10(epsilon)','verticalalign','top');
axis([minx  minx+deltax miny miny+deltay]);
xlabel('yearday');
ylabel('p / MPa');
axis('ij');

