% check_analog2_mmp.m
%  Plots raw mmp data from the optional analog channels: ac,
%  obs, th2, tl2, and prt.  Requests drop number as an input.

drop=input('drop ');
mmpid=read_mmpid(drop);

nplots=0;
plot_obs='n'; plot_th2='n'; plot_tl2='n'; plot_ac='n'; plot_prt='n';

% See if obs is installed
[sensorid,electronicsid,filter,fc,scanpos]=read_chconfig_mmp('obs',mmpid,drop);
if ~isempty(scanpos)
   plot_obs='y';
   nplots=nplots+1;
else
   plot_th2='y'; plot_tl2='y';
   nplots=nplots+1;
end

% See if ac is installed
[sensorid,electronicsid,filter,fc,scanpos]=read_chconfig_mmp('ac',mmpid,drop);
if ~isempty(scanpos)
   plot_ac='y';
   nplots=nplots+1;
end

% See if prt is installed
[sensorid,electronicsid,filter,fc,scanpos]=read_chconfig_mmp('prt',mmpid,drop);
if ~isempty(scanpos)
   plot_prt='y';
   nplots=nplots+1;
end

% Get raw  data in volts
if strcmp(plot_obs,'y')
   obs=atod1_mmp(read_rawdata_mmp('obs',drop));
end
if strcmp(plot_th2,'y')
   th2=atod1_mmp(read_rawdata_mmp('th2',drop))  
end
if strcmp(plot_tl2,'y')
   tl2=atod1_mmp(read_rawdata_mmp('tl2',drop));
end
if strcmp(plot_ac,'y')
   ac=atod1_mmp(read_rawdata_mmp('ac',drop));
end
if strcmp(plot_prt,'y')
   prt=atod1_mmp(read_rawdata_mmp('prt',drop));
end
title_str=[mmpid ' drop ' int2str(drop)];
figure
orient tall

plotno=1;
subplot(nplots,2,plotno)
if strcmp(plot_obs,'y')
   plot(obs)
   ig=find(~isnan(obs));
   if ~isempty(ig)  
      y_max=max(obs(ig)); y_min=min(obs(ig)); x_max=length(obs);
      axis([0 x_max y_min y_max])
   end
   ylabel('obs / volts')
   if plotno==1;
      title(title_str)
   end
   if plotno>=nplots-1
      xlabel('sample number')
   end
   plotno=plotno+1;
end

subplot(nplots,2,plotno)
if strcmp(plot_th2,'y')
   plot(th2)
   ig=find(~isnan(th2));
   if ~isempty(ig)
      y_max=max(th2(ig)); y_min=min(th2(ig)); x_max=length(th2);
      axis([0 x_max y_min y_max])
   end
   ylabel('th2 / volts')
   if plotno==1;
      title(title_str)
   end
   if plotno>=nplots-1
      xlabel('sample number')
   end
   plotno=plotno+1;
end

subplot(nplots,2,plotno)
if strcmp(plot_tl2,'y')
   plot(tl2)
   ig=find(~isnan(tl2));
   if ~isempty(ig)
      y_max=max(tl2(ig)); y_min=min(tl2(ig)); x_max=length(tl2);
      axis([0 x_max y_min y_max])
   end
   ylabel('tl2 / volts')
   if plotno==1;
      title(title_str)
   end
   if plotno>=nplots-1
      xlabel('sample number')
   end
   plotno=plotno+1;
end

subplot(nplots,2,plotno)
if strcmp(plot_ac,'y')
   plot(ac)
   ig=find(~isnan(ac));
   if ~isempty(ig)
      y_max=max(ac(ig)); y_min=min(ac(ig)); 
      if y_min==y_max 
         y_max=y_max+abs(0.05*y_max); 
         y_min=y_min-abs(0.05*y_min);
      end
      x_max=length(ac);
      axis([0 x_max y_min y_max])
   end
   ylabel('ac / volts')
   if plotno==1;
      title(title_str)
   end
   if plotno>=nplots-1
      xlabel('sample number')
   end
   plotno=plotno+1;
end

subplot(nplots,2,plotno)
if strcmp(plot_prt,'y')
   plot(prt)
   ig=find(~isnan(prt));
   if ~isempty(ig)
      y_max=max(prt(ig)); y_min=min(prt(ig)); x_max=length(prt);
      axis([0 x_max y_min y_max])
   end
   ylabel('prt / volts')
   if plotno==1;
      title(title_str)
   end
   if plotno>=nplots-1
      xlabel('sample number')
   end
   plotno=plotno+1;
end