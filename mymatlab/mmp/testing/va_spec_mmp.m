function va_spec_mmp(drop, select, start, stop)
% va_spec_amp
%   Usage: va_spec_mmp(drop, 'select', start, stop)
%      drop is sequential mmp drop number.
%      select is pr, sampleno, or time.
%      start is initial value of pr, sampleno, or time (sec).
%      stop is final value of pr, sampleno, or time (sec).
%   Function: Plots v1, v2, a1, and a2 over selected range,
%      then gives options 1) to take and plot spectra and
%      coherence of v1 and a1, 2) to do the same with v2 and a2,
%      and 3) to save the v1 and a1 spectra and coherence in
%      a .mat file.

% plotting limits
PVMAX=1e-2;
PVMIN=1e-9;
PAMAX=1e-2;
PAMIN=1e-8;

FS=400; % sample frequency
DT = 1/ FS;

mmpid=read_mmpid(drop);
cruise=read_cruises_mmp(drop);
[scanid,voffsetid]=read_config_mmp(mmpid,drop);

% put indices of selected data into idata
if strcmp(select,'pr')==1
   % Obtain pr over specified range
   [sensorid,electronicsid,filter,fc,scanpos] = read_chconfig_mmp('pr',mmpid,drop);	
   prV=read_rawdata_mmp('pr', drop, scanid, scanpos);
   prV=atod1_mmp(prV);
   pr=pr_mmp(prV);
   clear prV
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
[sensorid,electronicsid,filter,fc,scanpos] = read_chconfig_mmp('a1',mmpid,drop);	
a1=read_rawdata_mmp('a1', drop, scanid,scanpos);
a1=atod1_mmp(a1);
a1data=a1(idata);
clear a1
[sensorid,electronicsid,filter,fc,scanpos] = read_chconfig_mmp('a2',mmpid,drop);	
a2=read_rawdata_mmp('a2', drop, scanid,scanpos);
a2=atod1_mmp(a2);a2data=a2(idata);
clear a2
[sensorid,electronicsid,filter,fc,scanpos] = read_chconfig_mmp('v1',mmpid,drop);	
v1=read_rawdata_mmp('v1', drop, scanid,scanpos);
v1=atod1_mmp(v1);
v1data=v1(idata);
clear v1
[sensorid,electronicsid,filter,fc,scanpos] = read_chconfig_mmp('v2',mmpid,drop);	
v2=read_rawdata_mmp('v2', drop, scanid,scanpos);
v2=atod1_mmp(v2);
v2data=v2(idata);
clear v2

% plot data
figure
orient landscape
rect=[.12, .1, .2, .8];
axes('position',rect)
plot(a1data, yvar)
set(gca,'YDIR','reverse')
a1max=max(a1data); a1min=min(a1data);
ymax=max(yvar); ymin=min(yvar);
axis([a1min a1max ymin ymax])
xlabel(' a1 / volts'), ylabel(ylblstr)
title(['   MMP ' , longint2str(drop)])
rect=[.33, .1, .2, .8];
axes('position',rect)
plot(a2data, yvar)
a2max=max(a2data); a2min=min(a2data);
set(gca,'YDIR','reverse')
set(gca,'yticklabels','')
axis([a2min a2max ymin ymax])
xlabel(' a2 / volts')
rect=[.54, .1, .2, .8];
axes('position',rect)
plot(v1data, yvar)
set(gca,'YDIR','reverse')
set(gca,'yticklabels','')
v1max=max(v1data); v1min=min(v1data);
axis([v1min v1max ymin ymax])
xlabel(' v1 / volts')
rect=[.75, .1, .2, .8];
axes('position',rect)
plot(v2data, yvar)
set(gca,'YDIR','reverse')
set(gca,'yticklabels','')
v2max=max(v2data); v2min=min(v2data);
axis([v2min v2max ymin ymax])
xlabel(' v2 / volts')

Dov1Spec=input('Do v1 Spectra? ', 's');
if strcmp(Dov1Spec,'y') | strcmp(Dov1Spec,'Y') == 1
   
   % calculate  spectra
   [Pv1,f]=psd(v1data, 1024, FS);
   Pv1 = Pv1 / (FS/2);
   [Pa1,f]=psd(a1data, 1024, FS);
   Pa1 = Pa1 / (FS/2);
   Ca1v1=cohere(a1data, v1data, 1024, FS);
   
   figure
   orient tall
   rect=[.15, .6, .8, .35];
   axes('position',rect)
   loglog(f,Pv1)
   fmax=FS/2; fmin=min(f);
   axis([fmin fmax PVMIN PVMAX])
   ylabel('Pv1 / volts^2 / Hz')
   grid on
   titlestr=['MMP ' , longint2str(drop), ' : ' ylblstr ' = ' num2str(start) ' - ' num2str(stop)];
   if strcmp(select,'pr')
      titlestr=[titlestr ' , w = ' num2str(w) ' m/s'];
   end	title(titlestr)
   rect=[.15, .3, .8, .25];
   axes('position',rect)
   ymax=max(Pa1); ymin=min(Pa1); fmax=max(f); fmin=min(f);
   loglog(f,Pa1)
   axis([fmin fmax PAMIN PAMAX])
   ylabel('Pa1 / volts^2 / Hz')
   grid on
   rect=[.15, .1, .8, .15];
   axes('position',rect)
   semilogx(f,Ca1v1)
   axis([fmin fmax 0 1])
   xlabel('f / Hz'), ylabel('Coh^2 a1 v1')
   grid
end

Dov2Spec=input('Do v2 Spectra? ', 's');
if strcmp(Dov2Spec,'y') | strcmp(Dov2Spec,'Y') == 1
   
   % calculate  spectra
   [Pv2,f]=psd(v2data, 1024, 400);
   Pv2 = Pv2 / (FS/2);
   [Pa2,f]=psd(a2data, 1024, 400);
   Pa2 = Pa2 / (FS/2);
   Ca2v2=cohere(a2data, v2data, 1024, 400);
   
   figure
   orient tall
   rect=[.1, .6, .8, .25];
   axes('position', rect);
   loglog(f,Pv2)
   ymax=max(Pv2); ymin=min(Pv2); fmax=FS/2; fmin=min(f);
   axis([fmin fmax PVMIN PVMAX])
   ylabel('Pv2 / volts^2 / Hz')
   grid on
   titlestr=['MMP ' , longint2str(drop), ' : ' ylblstr ' = ' num2str(start) ' - ' num2str(stop)];
   if strcmp(select,'pr')
      titlestr=[titlestr ' , w = ' num2str(w) ' m/s'];
   end
   title(titlestr)
   rect=[.1, .3, .8, .25];
   axes('position',rect)	
   ymax=max(Pa2); ymin=min(Pa2);
   loglog(f,Pa2)
   axis([fmin fmax PAMIN PAMAX])
   ylabel('Pa2 / volts^2 / Hz')
   grid on
   rect=[.1, .1, .8, .15];
   axes('position', rect);
   semilogx(f,Ca2v2)
   axis([fmin fmax 0 1])
   xlabel('f / Hz'), ylabel('Coh^2 a2 v2')
   grid
end

savespec=input('Type "y cr" to save v1 and a1 spectra. ', 's')
if strcmp(savespec,'y')
   spec=f;
   spec(:,2)=Pv1;
   spec(:,3)=Pa1;
   spec(:,4)=Ca1v1;
   svstr=['save Pv1a1' longint2str(drop) '.mat spec'];
   eval(svstr)
end