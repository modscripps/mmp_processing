function plot_vac(drop,pr_beg,pr_end,c)
% Function: To aide viewing "wiggles" from raw vac1 and vac2 data.  
% Usage: vac1 and vac2 are subplotted versus pressure and overlaid, in red and black.
%        a1 and a2 are subplotted versus pressure and overlaid, in red and black.
%    `ginput' is used for selecting spikes by clicking on either side of them.
%    `input' then asks whether: 
%                  to zoom further 'z'
%                  to zoom back all the way 'r'
%                  to save to a file 's'
%						 to print to printer 'p'
%    The script begins by loading existing mpp files for the drop and setting
%    the marked pressure ranges to NaNs before making the first plots of vac1, vac2,
%    a1, a2.
% m. gregg 28oct98 (badflag1_v1v2_mmp.m)
% e. macdonald 10jun99
% e. macdonald 31aug99 (plot_mmp_spike.m)

set_mmp_paths

if read_afconfig2_mmp('v1',drop)=='mmp3';

	[mmpid,n1]=read_afconfig2_mmp('vac1',drop);
	[mmpid,n2]=read_afconfig2_mmp('vac2',drop);
	cruise=read_cruises_mmp(drop);

   % mmpid=read_mmpid(drop);
   scanlen_vac=2;
   scanlen_a=16;
   disp0_str=['Plotting channels vac1 and vac2 for drop ' int2str(drop)...
         ' on ' mmpid];
   disp(disp0_str)
   
   % Get raw vac1 and vac2 data
   vac1=atod1_mmp(read_rawdata_mmp('vac1',drop));
   vac2=atod1_mmp(read_rawdata_mmp('vac2',drop));
   
   % Shorten vac1, vac2 to match lengths of interpolated pressure
   vac1len=length(vac1);
   vac1=vac1(scanlen_vac/2:vac1len-scanlen_vac/2);
   vac2=vac2(scanlen_vac/2:vac1len-scanlen_vac/2);
   
   % Get raw a1 and a2 data
   a1=atod1_mmp(read_rawdata_mmp('a1',drop));
   a2=atod1_mmp(read_rawdata_mmp('a2',drop));
   
   % Shorten a1, a2 to match lengths of inerpolated pressure
   a1len=length(a1);
   a1=a1(scanlen_a/2:a1len-scanlen_a/2);
   a2=a2(scanlen_a/2:a1len-scanlen_a/2);
   
   % Get pressure.  Because there is only one pressure value per data scan,
   % interpolate to produce a pressure value for every vac1, vac2 value.
   % Ignore the first and last scanlen/2 samples of vac1, vac2,  so vac1 and vac2 will
   % have the same time intervals as pr
   
   pr=pr_offset1_mmp(drop,'vac1',pr3_mmp(drop));

   p_vac=interp1(scanlen_vac/2:2:vac1len-scanlen_vac/2,...
		pr,scanlen_vac/2:vac1len-scanlen_vac/2);
   p_vac=p_vac';
   
   p_a=interp1(scanlen_a/2:16:a1len-scanlen_a/2,...
   pr,scanlen_a/2:a1len-scanlen_a/2);
   p_a=p_a';
      
   % Set W (fall rate) 
	w=100*diff(pr)/(1/25);
	pr=pr(1:end-1)+diff(pr)/2;

	   
   % Filter data
   flen=100;fwts=ones(1,flen)/flen;
   
   vac1_lo=filter(fwts,[1],vac1);vac1_lo=vac1_lo(flen:length(vac1_lo));
   vac2_lo=filter(fwts,[1],vac2);vac2_lo=vac2_lo(flen:length(vac2_lo));
   p_vac_lo=filter(fwts,[1],p_vac);p_vac_lo=p_vac_lo(flen:length(p_vac_lo));
   
   vac1_hi=vac1(flen/2:length(vac1)-flen/2)-vac1_lo;
   vac2_hi=vac2(flen/2:length(vac2)-flen/2)-vac2_lo;
   p_vac_hi=p_vac(flen/2:length(p_vac)-(flen/2));
   
   a1=a1-(mean(a1(find(~isnan(a1)))));
   a2=a2-(mean(a2(find(~isnan(a2)))));  
   
   p1=0;p2=5;   
   if nargin>1
      p1=pr_beg;
      if nargin>2
         p2=pr_end;
         if nargin>3
            title_str(2)={[c]};
         end
      end
      ip_vac_lo=find(p_vac_lo>=p1 & p_vac_lo<=p2);
      vac1_lo=vac1_lo(ip_vac_lo);vac2_lo=vac2_lo(ip_vac_lo);
      p_vac_lo=p_vac_lo(ip_vac_lo);
      
      ip_vac_hi=find(p_vac_hi>=p1 & p_vac_hi<=p2);
      vac1_hi=vac1_hi(ip_vac_hi);vac2_hi=vac2_hi(ip_vac_hi);
      p_vac_hi=p_vac_hi(ip_vac_hi);
      
      ip_a=find(p_a>=p1 & p_a<=p2);
      a1=a1(ip_a);a2=a2(ip_a);
      p_a=p_a(ip_a);
      
      ipr=find(pr>=p1 & pr<=p2);
      w=w(ipr);pr=pr(ipr);
   end
   
   % Plot results and ask for preferences
	title_str(1)={[mmpid ',  drop = ' int2str(drop) ',  vac1 = ' n1...
		',  vac2 = ' n2]};
   title_str(2)={['filter length = ' num2str(flen)]};
   
   select='r';
   edit='y';
   
   Hf1=figure;
   set(Hf1,'Position',[20 40 700 670]);
   
   %%%%%%%%%% outer loop %%%%%%%%
   while strcmp(edit,'y')
      
      if strcmp(select,'r')
         
         % Subplot vac1_hi,vac2_hi vs p_vac_hi on (3,1,1),
         % vac1_lo, vac2_lo vs p_vac_lo on (3,1,2),
         % and a1,a2 vs p_a on (3,1,3)
         %%%% Plot vac1_hi in black and overlay vac2_hi in red. 
         clf
         Hl1=axes('position',[0.08 0.47 0.87 0.45]);
         Hp1=plot(p_vac_hi,vac1_hi,'-k');
         hold on
         Hp2=plot(p_vac_hi,vac2_hi,'-r');
         ylabel('vac1_{hi}(b), vac2_{hi}(r) / V')
         title(title_str)
         set(Hl1,'xlim',[p1 p2],'layer','top','xgrid','on','ygrid','on');
         set(Hl1,'ylim',[-0.05 0.05]);
         set(Hp1,'linewidth',[0.1]);
         set(Hp2,'linewidth',[0.1]);
         %%%% Plot vac1_lo in black and overlay vac2_lo in red.
         Hl2=axes('position',[0.08 0.27 0.87 0.15]);
         Hp3=plot(p_vac_lo,vac1_lo,'-k');
         hold on
         Hp4=plot(p_vac_lo,vac2_lo,'-r');
         ylabel('vac1_{lo}(b), vac2_{lo}(r) / V')
         set(Hl2,'xlim',[p1 p2],'layer','top','xgrid','on','ygrid','on');
         set(Hp3,'linewidth',[0.1]);
         set(Hp4,'linewidth',[0.1]);
         %%%% Plot a1 in black and overlay a2 in red.
         Hl3=axes('position',[0.08 0.07 0.87 0.15]);       
         Hp5=plot(p_a,a1,'-k');
         hold on
         Hp6=plot(p_a,a2,'-r');
         ylabel('a1(b), a2(r) / V')
         set(Hl3,'xlim',[p1 p2],'layer','top','xgrid','on');
         set(Hp5,'linewidth',[0.1]);
         set(Hp6,'linewidth',[0.1]);
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
         a1s=a1-(mean(a1(find(~isnan(a1) & p_a>=min(xi) & p_a<=max(xi)))));
         a2s=a2-(mean(a2(find(~isnan(a2) & p_a>=min(xi) & p_a<=max(xi)))));
         set(Hl1,'xlim',[min(xi) max(xi)]);
         set(Hl2,'xlim',[min(xi) max(xi)]);
         set(Hl3,'xlim',[min(xi) max(xi)]);
         set(Hp5,'ydata',a1s,'color','r');
         set(Hp6,'ydata',a2s,'color','k');
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
         if exist('xi','var')==0
            xi=p1;
         end
         wygiwys;
         lpr=1000+(floor(min(xi)*100));lpr=num2str(lpr);
         filedir=['E:\Eric\aug99\plots'];
         filename=[num2str(filedir) '\aug99_vac_' num2str(drop) '_' lpr(2:4)];
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
   
else disp('MMP 3 is not used for this drop number.')
end
