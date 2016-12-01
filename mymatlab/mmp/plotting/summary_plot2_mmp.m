function summary_plot2_mmp(t1,t2);
% make a ts plot and a density countour plot of
% pre-gridded data between the times of t1 and t2

cruise='bs98';
mmpfolders

eval(['load ' procdata FSP cruise FSP 'mmplog']);
idrop=find((mmplog(:,1)>=t1)&(mmplog(:,1)<=t2));
% load data files and reduce to desired portion
eval(['load ' procdata FSP cruise FSP 'gridded' FSP 'Sal'])
eval(['load ' procdata FSP cruise FSP 'gridded' FSP 'Sigmat'])
eval(['load ' procdata FSP cruise FSP 'gridded' FSP 'Theta'])
Sal=Sal(:,idrop); Theta=Theta(:,idrop); Sigmat=Sigmat(:,idrop)-1000;
yday=mmplog(idrop,3); drops=mmplog(idrop,1); mmp=mmplog(idrop,11);
clear mmplog
minx=min(yday); maxx=max(yday); miny=0; maxy=max(pr);
P=pr'*ones(1,length(drops));
deltax=maxx-minx; deltay=maxy-miny;

% setup variables for T-S plotting
ig=find((~isnan(Sal))&(~isnan(Theta)));
smin=min(Sal(ig))*1000; smax=max(Sal(ig))*1000;
tmin=min(Theta(ig)); tmax=max(Theta(ig));
s=smin:.01:smax; t=tmin:.1:tmax;
[S,T]=meshgrid(s,t);
D=sw_dens(S/1000,T,0);

% add NaNs to Sgth data for contouring
in = find(diff(yday)>0.042);
for i = 1:length(in)
  	ins=in(i);
	N= length(yday);
  	yday = [yday(1:ins); yday(ins)+0.0001; yday(ins+1:N)];
	mmp = [mmp(1:ins); 0; mmp(ins+1:N)];
	drops = [drops(1:ins); NaN; drops(ins+1:N)];
	Sigmat = [Sigmat(:,1:ins)...
         NaN*Sigmat(:,1) Sigmat(:,ins+1:N)];
   in=in+1;
end;
drop=drops;
sigmatv = [21:0.2:27];
sigmacax=[21 26];

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
height=1-(5)*dy;height=height/2;
pos1=[2.2*dx 1-2*dy-height width height];
pos2=[2.2*dx 1-3*dy-2*height width height];
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
in = [0 ;find(diff(mmp)~=0)]+1;
for j=1:length(in)
  i = in(j);
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
yday_off=yearday(1,10,1998,0,0,0)-1;
ydmin=min(yday);ydmax=max(yday);
day = [ydmin ydmax]-yday_off; 
bad = find(day>=32);
month=[10 10];
if ~isempty(bad)
  day(bad)=day(bad)-31;
	month(bad)=11 + 0*bad;
end;
hour = 24*(day-floor(day));
minute = floor(60*(hour-floor(hour))); 
hour = floor(hour);
day=floor(day);
if month(1)==10
  month1='Oct';
else
	month1='Nov';
end;
if month(2)==10
  month2='Oct';
else
	month2='Nov';
end;
if minute(1)<10
   min1str=['0' int2str(minute(1))];
else
   min1str=int2str(minute(1));
end
if minute(2)<10
   min2str=['0' int2str(minute(2))];
else
   min2str=int2str(minute(2));
end

  text(0,0,['BS 98   APL/UW  Gregg/Miller  ']);
	text(0.6,0,['From: ' ...
	 int2str(day(1)) ' ' month1 ' 98 '...
	  int2str(hour(1)) min1str...
		'   To: '  int2str(day(2)) ' ' month2 ' 98 '...
	  int2str(hour(2)) min2str],'fontsize',10);

% Do the top plot = sgth contour
axes('units','normalized','position',pos1);
axis('ij');
extcontour(yday,pr,Sigmat,sigmatv,...
  'fill','label','color','white','fontsize',9);
patch([xl xl xl+xw xl+xw],[yl yl-yw yl-yw yl],[1000 1000 1000 1000],'w');
text(xl,yl-yw,2000,' \sigma_{\theta}','verticalalign','top');
axis([minx  minx+deltax miny miny+deltay]);
xlabel('yearday');
ylabel('p / MPa');
axis('ij');
caxis(sigmacax)

% Do the bottom plot = T-S plot
axes('units','normalized','position',pos2);
j=flipud(jet(length(idrop))); hold on
for i=1:length(idrop)
      h=plot(Sal(:,i)*1000,Theta(:,i));
   set(h,'Color',j(i,:))
end
extcontour(s,t,D-1000,'label','fontsize',8,'color','c','linestyle','--');
axis([smin smax tmin tmax])
xlabel('S / psu'); ylabel('Theta / C');

