function plot_vac_spike(drop,pr_beg,pr_end,c)
% Function: To aide viewing spikes from raw v1,v2,a1,a2,p, and w data.  
% Usage: vac1 and vac2 are subplotted versus pressure and overlaid, in red and black.
%        a1 and a2 are subplotted versus pressure and overlaid, in red and black.
%    `ginput' is used for selecting spikes by clicking on either side of them.
%    `input' then asks whether: 
%                  to zoom further 'z'
%                  to zoom back all the way 'r'
%                  to save to a file 's'
%						 to print to printer 'p'
%    The script begins by loading existing mpp files for the drop and setting
%    the marked pressure ranges to NaNs before making the first plots of v1, v2,
%    a1, a2.
% m. gregg 28oct98 (badflag1_v1v2_mmp.m)
% e. macdonald 10jun99
% e. macdonald 31aug99

set_mmp_paths

[mmpid,afc1,afp1]=read_afconfig2_mmp('v1',drop);
[mmpid,afc2,afp2]=read_afconfig2_mmp('v2',drop);
cruise=read_cruises_mmp(drop);

% mmpid=read_mmpid(drop);
scanlen=16;
disp0_str=['Plotting v1 and v2 spikes for drop 'int2str(drop) ' on ' mmpid];
disp(disp0_str)

% Get raw v1 and v2 data
v1=atod1_mmp(read_rawdata_mmp('v1',drop));
v2=atod1_mmp(read_rawdata_mmp('v2',drop));

% Shorten v1, v2 to match lengths of interpolated pressure
v1len=length(v1);
v1=v1(scanlen/2:v1len-scanlen/2);
v2=v2(scanlen/2:v1len-scanlen/2);

% Get raw a1 and a2 data
a1=atod1_mmp(read_rawdata_mmp('a1',drop));
a2=atod1_mmp(read_rawdata_mmp('a2',drop));

% Shorten a1, a2 to match lengths of inerpolated pressure
a1len=length(a1);
a1=a1(scanlen/2:a1len-scanlen/2);
a2=a2(scanlen/2:a1len-scanlen/2);

% Get pressure.  Because there is only one pressure value per data scan,
% interpolate to produce a pressure value for every v1, v2 value.
% Ignore the first and last scanlen/2 samples of v1, v2,  so v1 and v2 will
% have the same time intervals as pr
pr=pr_offset1_mmp(drop,'v1',pr3_mmp(drop));
p=interp1(scanlen/2:16:v1len-scanlen/2,pr,scanlen/2:v1len-scanlen/2);
p=p';

% Set W (fall rate) 
w=100*diff(pr)/(1/25);
pr=pr(1:end-1)+diff(pr)/2;

title_str(1)={[mmpid ',  drop = ' int2str(drop) ',  v1 = ' num2str(afp1)...
      '/' afc1(3) ',  v2 = ' num2str(afp2) '/' afc2(3)]};
p1=0;p2=5;title_str(2)={''};
if nargin>1
   p1=pr_beg;
   if nargin>2
      p2=pr_end;
      if nargin>3
         title_str(2)={[c]};
      end
   end
   ip=find(p>=p1 & p<=p2);
   v1=v1(ip);v2=v2(ip);a1=a1(ip);a2=a2(ip);p=p(ip);
   ipr=find(pr>=p1 & pr<=p2);
   w=w(ipr);pr=pr(ipr);
end

a1=a1-(mean(a1(find(~isnan(a1)))));
a2=a2-(mean(a2(find(~isnan(a2)))));

select='r';
edit='y';

Hf1=figure;
set(Hf1,'Position',[20 110 600 600]);

%%%%%%%%%% outer loop %%%%%%%%
while strcmp(edit,'y')
   
   if strcmp(select,'r')
      
      % Subplot v1,v2 vs p (3,1,1) and a1,a2 on (3,1,2) and w on (3,1,3)
      %%%% Plot v1 in red and overlay v2 in black. 
      clf
      Hl1=subplot(3,1,1);
      plot(p,v1,'-r');
      hold on
      %plot(p,v2,'-k');
		ylabel('v1(r), v2(b) / V')
      title(title_str)
      set(Hl1,'xlim',[p1 p2],'layer','top','xgrid','on');

      %%%% Plot a1 in red and overlay a2 in black.
      Hl2=subplot(3,1,2);
      Hp1=plot(p,a1,'-r');
      hold on
      Hp2=plot(p,a2,'-k');
      ylabel('a1(r), a2(b) / V')
      set(Hl2,'xlim',[p1 p2],'layer','top','xgrid','on');
      
      %%%% Plot w in red
      Hl3=subplot(3,1,3);
      plot(pr,w,'-r');
      xlabel('p / MPa'), ylabel('w(r) / m/s')
      set(Hl3,'xlim',[p1 p2],'layer','top','xgrid','on');
   end
   
   %%%%%%%% inner loop to set xlim
   if strcmp(select,'z') | strcmp(select,'x')
      
      %%%%%%%% sub-inner loop to set xlim with mouse
      if strcmp(select,'z')
         disp('Click on the screen on either side of the area to be zoomed in on.')
         [xi,yi]=ginput(2);
      end
      %%%%%%%% end sub-inner loop
      
      %%%%%%%% sub-inner loop to set xlim from keyboard
      if strcmp(select,'x')
         xi=input('Enter lower and upper bounds: ');
      end
      %%%%%%%% end sub-inner loop
      
      a1s=a1-(mean(a1(find(~isnan(a1) & p>=min(xi) & p<=max(xi)))));
      a2s=a2-(mean(a2(find(~isnan(a2) & p>=min(xi) & p<=max(xi)))));
      % keyboard
      set(Hl1,'xlim',[min(xi) max(xi)]);
      set(Hl2,'xlim',[min(xi) max(xi)]);
      set(Hl3,'xlim',[min(xi) max(xi)]);
      Hps=get(Hl2,'children');
      set(Hps(1),'ydata',a1s,'color','r');
      set(Hps(2),'ydata',a2s,'color','k');
   end
   %%%%%%%% end inner loop
   
   %%%%%%%% inner loop to print current figure
   if strcmp(select,'p')
      wygiwys
      print -dwinc    
   end
   %%%%%%%% end inner loop
   
   %%%%%%%% inner loop to save current figure to a file
   if strcmp(select,'s')
      wygiwys;
      lpr=1000+(floor(min(xi)*100));lpr=num2str(lpr);
      filedir=['E:\Eric\aug99\plots'];
      filename=[num2str(filedir) '\aug99_spike_' num2str(drop) '_' lpr(2:4)];
      print_str=['print -depsc ' filename];
      eval(print_str)
      disp(['File is being saved with the filename - ' filename])
   end
   %%%%%%%% end inner loop
   
   select=input...
      ('Reply z(zoom), r(restart), x(set xlim), p(print), s(save), q(quit): ','s');
   
   if strcmp(select,'k')
      keyboard
   end
      
   if length(select)<1
      select='z';
   end
   
   if strcmp(select,'q')
      edit='n';
   end
   
end %%%%%%%%%%%%%%%%%%% end outer loop %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close(Hf1)
