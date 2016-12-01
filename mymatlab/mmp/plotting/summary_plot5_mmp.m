function [a1,a2,a3,a4]=summary_plot5_mmp(filename);
% make a summary plot of the gridded data in "filename"
% function [a1,a2,a3,a4]=summary_plot1_mmp(filename);
%  
% filename must contain pr_eps, pr_theta, mmp_yday, Sal, Theta,
% Sigmat, Eps. 

eval(['load ' filename]);
mmp=mmp';
drop=drops;
minx=min(yday); maxx=max(yday); miny=0; maxy=max(pr_theta);
miny=0;maxy=0.7
deltax=maxx-minx; deltay=maxy-miny;

% Setup the contouring intervals:
sigmatv = [21:0.5:27];
thetav = [4:15];
epsv   = [-10:1];
salv   = [31:0.1:32.5];

% Setup the colormaps...
minSig=25.3; 
maxSig=[25.5];
minT=5.5;
maxT=7;
minS =32.28;
maxS= 32.35
epscax  =[-10 -6];
minP=0;maxP=0.75;

sigmacax=[25.3 25.5];
thetacax=[5.5 7];
salcax  =[32.28 32.35];
epscax  =[-10 -6];

% Setup style of the plot
clf
set(gcf,'defaulttextfontweight','bold');
set(gcf,'defaultaxesfontweight','bold');
set(gcf,'defaultaxesfontsize',12);
set(gcf,'defaulttextfontsize',12);
whitebg('w');
% set(gcf,'color',[1 1 1]);
% set(gcf,'defaultaxescolor','none');
orient tall;

% lets do four plots: T-S S-p T-p Sigma-p

% TS plot
subplot(2,2,1);
cm=hsv(3);
for i=1:3
  in = find(mmp==i);
	if length(in)>0
	T=Theta(:,in);
	S=Sal(:,in);
	size(S)
	size(T)
	plot(1000*S(:),T(:),'.','color',cm(i,:));
	hold on;
	end;
	axis([minS maxS minT maxT]);
end;
xlabel('S / psu'); ylabel('Theta / C');
hold on;
s=32.28:0.01:32.35;t=5.5:0.1:7;
[S,T]=meshgrid(s,t);
D=sw_dens(S/1000,T,0);
extcontour(s,t,D-1000,'label','fontsize',8,'color','c','linestyle','--');
title(['CMO 97  APL/UW  Gregg/Miller     From: ',...
   num2str(min(yday)), '  To: ', num2str(max(yday))]);

% T plot
subplot(2,2,2);
for i=1:3
  in = find(mmp==i);
	if length(in)>0
  	T=Theta(:,in);
  	P=ones(size(yday(in)))';
  	P=pr_theta'*P;
  	cm(i,:)
	  plot(T,P,'color',cm(i,:));
	  hold on;
	end;
	axis([minT maxT minP maxP]);
	axis('ij');
end;
xlabel('Theta / C');
ylabel('p / MPa');

 % S plot
subplot(2,2,3);
for i=1:3
  in = find(mmp==i);
	if length(in)>0
	S=Sal(:,in);
	P=ones(size(yday(in)))';
	P=pr_theta'*P;
	cm(i,:)
	plot(S*1000,P,'color',cm(i,:));
	hold on;
	end;
	axis([minS maxS minP maxP]);
	axis('ij');
end;
xlabel('S / psu');
ylabel('p / MPa');

  % Sigma plot
subplot(2,2,4);
for i=1:3
  in = find(mmp==i);
	if length(in)>0
	S=Sigmat(:,in);
	P=ones(size(yday(in)))';
	P=pr_theta'*P;
	cm(i,:)
	plot(S-1000,P,'color',cm(i,:));
	hold on;
	end;
	axis([minSig maxSig minP maxP]);
	axis('ij');
end;
xlabel('Sigmat / kg/m^3');
ylabel('p / MPa');
 
eval(['print -depsc ' filename '_ts.eps']);
