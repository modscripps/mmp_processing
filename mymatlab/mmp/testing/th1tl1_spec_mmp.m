function th1tl1_spec_mmp(drop, select, start, stop)
% th1tl1_spec_mmp
%   Usage: th1tl1_spec_mmp(drop, 'select', start, stop)
%      drop is mmp sequential drop number
% 	   select is pr, sampleno, or time
%      start is number to start analysis, whether pr, sample,
%	      or time in seconds
%   Function: Plots v1, v2, a1, a2 over ranges selected and gives
%      options to: 1) take and plot spectra and coherence of v1 
%      and a1, 2) take and plot spectra and coherence of v2 and 
%      a2, and 3) write a .mat file containing the v1 and a2 
%      spectra and coherence.

FS=400; % sample frequency
DT = 1/ FS;

% put indices of selected data into idata
if strcmp(select,'pr')==1
   % Obtain pr over specified range
   %prV=read_raw_mmpdata('pr', drop, 'volts');
   %pr=pr_mmp(prV);
   pr=pr2_mmp(drop,0);
   %clear prV
   idata=find(pr>start & pr < stop);
   yvar=pr(idata);
   clear pr
   ylblstr=['p / MPa']; % string label for y axis of data plots
   % compute average fall rate over pressure range
   deltat=length(idata) * DT;
   w = 100 * (start - stop) / deltat;
elseif strcmp(select,'sampleno')==1
   idata=(start:stop);
   yvar=idata;
   w=[];
   ylblstr=['Sample Number'];
elseif strcmp(select,'time')==1
   t0=start;
   t1=stop;
   yvar=(start:DT:stop);
   start=fix(t0/DT); % matching start sampleno
   stop=fix(t1/DT); % matching stop sampleno
   idata=(start:stop);
   ylblstr=['Time / s'];
else
   error('    improper select')
end

% get data with samplenos in idata
tl1V=read_rawdata_mmp('tl1', drop, 'volts');
tl1data=atod1_mmp(tl1V(idata));
clear tl1V
th1V=read_rawdata_mmp('th1', drop, 'volts');
th1data=atod1_mmp(th1V(idata));
clear th1V

% plot data
figure
orient tall
% plot tl1 data selected
rect=[.2, .78, .75, .16];
axes('position',rect)
plot(yvar,tl1data)
tl1max=max(tl1data); tl1min=min(tl1data);
ymax=max(yvar); ymin=min(yvar);
axis([ymin ymax tl1min tl1max])
ylabel(' tl1 / volts')
set(gca,'xticklabel','')
% plot th1 data selected
title(['   MMP ' , longint2str(drop)])
rect=[.2, .6, .75, .16];
axes('position',rect)
plot(yvar,th1data)
th1max=max(th1data); th1min=min(th1data);
axis([ymin ymax th1min th1max])
xlabel(ylblstr),ylabel(' th1 / volts')

DoSpec=input('Do Spectra? ', 's');
if strcmp(DoSpec,'y') | strcmp(DoSpec,'Y') == 1
   
   % calculate  spectra
   [Ptl1,f]=psd(tl1data, 512, FS);
   Ptl1 = Ptl1 / (FS/2);
   [Pth1,f]=psd(th1data, 512, FS);
   Pth1 = Pth1 / (FS/2);
   
   % set plotting limits
   fmax=FS/2; fmin=min(f);
   PTLMIN=min(Ptl1); PTLMAX=max(Ptl1);
   PTHMIN=min(Pth1); PTHMAX=max(Pth1);
   
   % plot tl spectrum
   rect=[.15, .15, .35, .35];
   axes('position',rect)
   loglog(f,Ptl1)
   axis([fmin fmax PTLMIN PTLMAX])
   xlabel('f / Hz'), ylabel('Ptl1 / volts^2 / Hz')
   grid on
   % plot th spectrum
   rect=[.6, .15, .35, .35];
   axes('position',rect)
   loglog(f,Pth1)
   axis([fmin fmax PTHMIN PTHMAX])
   xlabel('f / Hz'), ylabel('Pth1 / volts^2 / Hz')
   grid on
end

savespec=input('Type "y cr" to save v1 and tl1 spectra. ', 's')
if strcmp(savespec,'y')
   spec=f;
   spec(:,2)=Ptl1;
   spec(:,3)=Pth1;
   svstr=['save Pv1tl1' longint2str(drop) '.mat spec'];
   eval(svstr)
end