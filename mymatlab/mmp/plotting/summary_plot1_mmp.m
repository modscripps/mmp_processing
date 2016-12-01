function summary_plot1_mmp(t1,t2);
% make a summary plot of the gridded data between t1 and t2
% function summary_plot1_mmp(t1,t2);
%  
% gridded files for Eps, N2,Sal,Sigmat,Theta, and Obs must 
% already exist, along with vectors yday and pr

cruise='bs98';
mmpfolders

eval(['load ' procdata FSP cruise FSP 'mmplog']);
idrop=find((mmplog(:,1)>=t1)&(mmplog(:,1)<=t2));
% load data files and reduce to desired portion
eval(['load ' procdata FSP cruise FSP 'gridded' FSP 'Sal'])
eval(['load ' procdata FSP cruise FSP 'gridded' FSP 'Sigmat'])
eval(['load ' procdata FSP cruise FSP 'gridded' FSP 'Theta'])
eval(['load ' procdata FSP cruise FSP 'gridded' FSP 'Eps'])
eval(['load ' procdata FSP cruise FSP 'gridded' FSP 'N2'])
eval(['load ' procdata FSP cruise FSP 'gridded' FSP 'Obs'])
Sal=Sal(:,idrop); Theta=Theta(:,idrop); Sigmat=Sigmat(:,idrop)-1000;
Epsilon=Eps(:,idrop); N2=N2(:,idrop); Obs=Obs(:,idrop); 
yday=mmplog(idrop,3); drops=mmplog(idrop,1); mmp=mmplog(idrop,11);
clear mmplog Eps  %less clutter in memory

% add NaN between data gaps greater that 1 hours....
in = find(diff(yday)>0.042)
for i = 1:length(in)
  ins=in(i);
	N= length(yday);
  yday = [yday(1:ins); yday(ins)+0.0001; yday(ins+1:N)];
	mmp = [mmp(1:ins); 0; mmp(ins+1:N)];
	drops = [drops(1:ins); NaN; drops(ins+1:N)];
	Epsilon = [Epsilon(:,1:ins)...
     NaN*Epsilon(:,1) Epsilon(:,ins+1:N)];
   N2 = [N2(:,1:ins)...
     NaN*N2(:,1) N2(:,ins+1:N)];
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
Krho=.2*Epsilon./N2;
mmp=mmp';
drop=drops;
minx=min(yday); maxx=max(yday); miny=0; maxy=max(pr);
P=pr'*ones(1,length(drops));
deltax=maxx-minx; deltay=maxy-miny;

% Setup the contouring intervals:
sigmatv = [21:0.2:27];
thetav =[10:1:31];
epsv   = [-10:.5:-1];
salv   = [33.7:0.05:34.7];
n2v		 = [-6:.5:-2];
krhov  = [-8:1:2];

% Setup the colormaps...
sigmacax=[21 26];
thetacax=[10 30];
salcax  =[33.9 34.55];
epscax  =[-10 -7];
n2cax   =[-5 -3];
krhocax =[-6 -3];

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
height=1-(4)*dy;height=height/3;
pos1=[2.2*dx 1-3*dy-height width height];
pos2=[2.2*dx 1-3*dy-2*height width height];
pos3=[2.2*dx 1-3*dy-3*height width height];
%pos4=[2.2*dx 1-3*dy-4*height width height];
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


% Do the Temperature axis
axes('units','normalized','position',pos1);
axis('ij');
extcontour(yday,pr,Theta,thetav,...
  'fill','label','color','white','fontsize',9);

patch([xl xl xl+xw xl+xw],[yl yl-yw yl-yw yl],...
  1*[1000 1000 1000 1000],'w');
text(xl,yl-yw,2000,'Theta / C','verticalalign','top');
axis([minx  minx+deltax miny miny+deltay]);
set(gca,'xticklabel',[]);
ylabel('p / MPa');
axis('ij');
caxis(thetacax);

% Do the Salinity axis
axes('units','normalized','position',pos2);
axis('ij');
extcontour(yday,pr,1000*Sal,salv,...
  'fill','label','color','white','fontsize',9);

patch([xl xl xl+xw xl+xw],[yl yl-yw yl-yw yl],[1000 1000 1000 1000],'w');
text(xl,yl-yw,2000,' S / psu','verticalalign','top');
axis([minx  minx+deltax miny miny+deltay]);
set(gca,'xticklabel',[]);
ylabel('p / MPa');
axis('ij');
caxis(salcax);

% Do the Sigmat axis

axes('units','normalized','position',pos3);
axis('ij');
extcontour(yday,pr,Sigmat,sigmatv,...
  'fill','label','color','white','fontsize',9);
patch([xl xl xl+xw xl+xw],[yl yl-yw yl-yw yl],[1000 1000 1000 1000],'w');
text(xl,yl-yw,2000,' sigma_theta','verticalalign','top');
axis([minx  minx+deltax miny miny+deltay]);
xlabel('yearday');
ylabel('p / MPa');
axis('ij');
caxis(sigmacax)

% page 2
figure
colormap(jet);
set(gcf,'defaulttextfontweight','bold');
set(gcf,'defaultaxesfontweight','bold');
set(gcf,'defaultaxesfontsize',12);
set(gcf,'defaulttextfontsize',12);
whitebg('w');
% set(gcf,'color',[1 1 1]);
set(gcf,'defaultaxescolor',[0.75 0.75 0.75]);
orient tall;

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

 text(0,0,['BS 98   APL/UW  Gregg/Miller  ']);
	text(0.6,0,['From: ' ...
	 int2str(day(1)) ' ' month1 ' 98 '...
	  int2str(hour(1)) min1str...
		'   To: '  int2str(day(2)) ' ' month2 ' 98 '...
	  int2str(hour(2)) min2str],'fontsize',10);

% Do the Epsilon axis 

axes('units','normalized','position',pos1);
axis('ij');
extcontour(yday,pr,log10(Epsilon),epsv,...
 'fill','label','color','white','fontsize',9);
caxis(epscax);
patch([xl xl xl+xw xl+xw],[yl yl-yw yl-yw yl],[1000 1000 1000 1000],'w');
text(xl,yl-yw,2000,'log_{10} (\epsilon)','verticalalign','top');
axis([minx  minx+deltax miny miny+deltay]);
set(gca,'xticklabel',[]);
ylabel('p / MPa');
axis('ij');


% Do the N^2 axis

axes('units','normalized','position',pos2);
axis('ij');
extcontour(yday,pr,log10(N2),n2v,...
 'fill','label','color','white','fontsize',9);
caxis(n2cax);
patch([xl xl xl+xw xl+xw],[yl yl-yw yl-yw yl],[1000 1000 1000 1000],'w');
text(xl,yl-yw,2000,'log_{10}(N^2)','verticalalign','top');
axis([minx  minx+deltax miny miny+deltay]);
set(gca,'xticklabel',[]);
ylabel('p / MPa');
axis('ij');

% Do the Krho axis

axes('units','normalized','position',pos3);
axis('ij');
extcontour(yday,pr,log10(Krho),krhov,...
 'fill','label','color','white','fontsize',9);
caxis(krhocax);
patch([xl xl xl+xw xl+xw],[yl yl-yw yl-yw yl],[1000 1000 1000 1000],'w');
text(xl,yl-yw,2000,'log_{10} (K_{\rho})','verticalalign','top');
axis([minx  minx+deltax miny miny+deltay]);
xlabel('yearday')
ylabel('p / MPa');
axis('ij');


%eval(['print -depsc ' filename '.eps']);
