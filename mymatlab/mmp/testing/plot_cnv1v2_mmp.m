function plot_cnv1v2_mmp(drop,pr_beg,pr_end)

% function plot_cnv1v2_mmp(drop,pr_beg,pr_end)

% Function: To aide viewing spikes from raw v1,v2,a1,a2,p, and w data.  
% Usage: v1 and v2 are subplotted versus pressure and overlaid, in red and black.
%        a1 and a2 are subplotted versus pressure and overlaid, in red and black.
%    `ginput' is used for selecting spikes by clicking on either side of them.
%    `input' then asks whether: 
%                  to zoom further 'z'
%                  to zoom back all the way 'r'
%                  to save to a file 's'
%						 to print to printer 'p'
% adapted from badflag1_v1v2_mmp.m, m.gregg 28oct98
% e. macdonald 10jun99, e. macdonald 31aug99
% d.winkel - if pr_beg,pr_end are specified, plot only downward data

set_mmp_paths

[mmpid,afc1,afp1]=read_afconfig2_mmp('v1',drop);
[mmpid,afc2,afp2]=read_afconfig2_mmp('v2',drop);
cruise=read_cruises_mmp(drop);

% mmpid=read_mmpid(drop);
scanlen=16;

% Get raw v1 and v2 data
v1=atod1_mmp(read_rawdata_mmp('v1',drop));
v2=atod1_mmp(read_rawdata_mmp('v2',drop));

% Shorten v1, v2 to match lengths of interpolated pressure
v1len=length(v1);
v1=v1(scanlen/2:v1len-scanlen/2);
v2=v2(scanlen/2:v1len-scanlen/2);

% Get raw conductivity counts 
cn=read_rawdata_mmp('csbe',drop);

% get conducivity
mmpfolders
eval(['load ' procdata '/' cruise '/tc/tc' int2str(drop)])

% Get pressure.  Because there is only one pressure value per data scan,
% interpolate to produce a pressure value for every v1, v2 value.
% Ignore the first and last scanlen/2 samples of v1, v2,  so v1 and v2 will
% have the same time intervals as pr
pr=pr_offset1_mmp(drop,'v1',pr3_mmp(drop));
w=100*diff(pr)/(1/25);
p=interp1(scanlen/2:16:v1len-scanlen/2,pr,scanlen/2:v1len-scanlen/2);
p=p';

title_str(1)={[mmpid ',  drop = ' int2str(drop) ',  v1 = ' num2str(afp1)...
      '/' afc1(3) ',  v2 = ' num2str(afp2) '/' afc2(3)]};
p1=0;p2=3;title_str(2)={''}; 
if nargin>1
   p1=pr_beg;
   if nargin>2
      p2=pr_end;
      if nargin>3
         title_str(2)={[c]};
      end
   end
   %ip=find(p>=p1 & p<=p2);
   %keyboard
   ip=find(p>=p1 & p<=p2);
   v1=v1(ip);v2=v2(ip);p=p(ip);
   ip = find(pr_thetasd >= p1 & pr_thetasd <= p2);
   cn=cn(ip,:);csbe=csbe(ip);pr_thetasd = pr_thetasd(ip);
end

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
      plot(p,v2,'-k');
		ylabel('v1(r), v2(b) / V')
      title(title_str)
      set(Hl1,'xlim',[p1 p2],'layer','top','xgrid','on');

      %%%% Plot a1 in red and overlay a2 in black.
      Hl2=subplot(3,1,2);
      Hp1=plot(pr_thetasd,csbe,'-r');
      ylabel('csbe / s m^{-1}')
      set(Hl2,'xlim',[p1 p2],'layer','top','xgrid','on');
      
      %%%% Plot w in red
      Hl3=subplot(3,1,3);
      plot(pr_thetasd,cn(:,2),'-g',pr_thetasd,cn(:,1),'-r');
      xlabel('p / MPa'), ylabel('cn word1 (r) word2(g)')
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

      % keyboard
      set(Hl1,'xlim',[min(xi) max(xi)]);
      set(Hl2,'xlim',[min(xi) max(xi)]);
      set(Hl3,'xlim',[min(xi) max(xi)]);
      Hps=get(Hl2,'children');
      %set(Hps(1),'ydata',a1s,'color','r');
      %set(Hps(2),'ydata',a2s,'color','k');
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
