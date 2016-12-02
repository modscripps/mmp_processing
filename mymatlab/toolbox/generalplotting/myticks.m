%
%      MYTICKS make ticks on the existing aixs
%
%       ex. myticks('x',whichside,300:350,0.8,popupid);
%
%           whichside = 'y' (both sides), 'b' (bottom), 'u' (upper)
%                                         'l' (left),   'r' (right)
%
%           draw on x-axis (top and bottom both sides), minor ticks
%           at 300:305
%
     function h = myticks(xory,bothsides,ticks,tickscale,popupid);

      ticklen=get(gca,'ticklength');
      oticklen = ticklen;
      ticklen = ticklen*tickscale;
      Xt=get(gca,'xtick');
      Yt=get(gca,'ytick');
      Xlm=get(gca,'xlim');
      Ylm=get(gca,'ylim');
      bk=1-get(gcf,'color');
      position=get(gca,'position');
      xscale = get(gca,'xscale');
      yscale = get(gca,'yscale');
      dx = position(3);
      dy = position(4);
      if (dx >= dy);
          dy = dy/dx;
          dx = 1; 
      else
          dx = dx/dy;
          dy = 1;
      end
      
   if strcmp(yscale,'linear');
      if (xory == 'x' | xory == 'X');
         hold on
         tlen = min(ticklen)/dy;
         otlen = min(oticklen)/dy;
         if (bothsides == 'b' | bothsides == 'y');
             h1 = line(Xlm,min(Ylm)*[1 1],'color',bk);
             h2 = line([1;1]*Xt(:)',...
                   [min(Ylm);min(Ylm)+otlen*diff(Ylm)]*ones(size(Xt)),...
                    'color',bk,'clipping','on');
             h3 = line([1;1]*ticks(:)', ...
                   [min(Ylm);min(Ylm)+tlen*diff(Ylm)]*ones(size(ticks)),...
                    'color',bk,'clipping','on');

             h = [h1(:)' h2(:)' h3(:)'];
         end
	 if (bothsides == 'u' | bothsides == 'y');
             h1 = line([1;1]*Xt(:)',...
                  [max(Ylm);max(Ylm)-otlen*diff(Ylm)]*ones(size(Xt)),...
                  'color',bk,'clipping','on');
             h2 = line([1;1]*ticks(:)',...
                  [max(Ylm);max(Ylm)-tlen*diff(Ylm)]*ones(size(ticks)),...
                  'color',bk,'clipping','on');
             h3 = line(Xlm,max(Ylm)*[1 1],'color',bk);
             h = [h1(:)' h2(:)' h3(:)'];
	     popup(h);
         end
      end
   end
   if strcmp(xscale,'linear');
      if (xory == 'y' | xory == 'Y');
         hold on
         tlen = min(ticklen)/dx;
         otlen = min(oticklen)/dx;
	 if (bothsides == 'y' | bothsides == 'l');
            h1 = line(min(Xlm)*[1 1],Ylm,'color',bk);
            h2 = line([min(Xlm);min(Xlm)+otlen*diff(Xlm)]*ones(size(Yt)),...
                [1;1]*Yt(:)',...
                'color',bk,'clipping','on');
            h3 = line([min(Xlm);min(Xlm)+tlen*diff(Xlm)]*ones(size(ticks)),...
                [1;1]*ticks(:)',...
                'color',bk,'clipping','on');
             h = [h1(:)' h2(:)' h3(:)'];
         end
         if (bothsides == 'y' | bothsides == 'r');
             h1 = line(max(Xlm)*[1 1],Ylm,'color',bk);
             h2 = line([max(Xlm);max(Xlm)-otlen*diff(Xlm)]*ones(size(Yt)),...
                  [1;1]*Yt(:)',...
      	    'color',bk,'clipping','on');
             h3 = line([max(Xlm);max(Xlm)-tlen*diff(Xlm)]*ones(size(ticks)),...
                  [1;1]*ticks(:)',...
      	    'color',bk,'clipping','on');
             h = [h1(:)' h2(:)' h3(:)'];
         end
      end
   end
   
   if strcmp(yscale,'log');
      if (xory == 'x' | xory == 'X');
         hold on
	 fac = diff(log10(Ylm))*0.05;;
         if (bothsides == 'y' | bothsides == 'b');
            h1 = line(Xlm,min(Ylm)*[1 1],'color',bk);
            h2 = line([1;1]*Xt(:)',...
               [min(Ylm);min(Ylm)*(1+fac)]*ones(size(Xt)),...
               'color',bk,'clipping','on');
            h3 = line([1;1]*ticks(:)',...
               [min(Ylm);min(Ylm)*(1+fac*tickscale)]*ones(size(ticks)),...
               'color',bk,'clipping','on');
             h = [h1(:)' h2(:)' h3(:)'];
         end
         if (bothsides == 'y' | bothsides == 'u');
             h1 = line([1;1]*Xt(:)',...
                  [max(Ylm);max(Ylm)*(1-fac)]*ones(size(Xt)),...
                  'color',bk,'clipping','on');
             h2 = line([1;1]*ticks(:)',...
                  [max(Ylm);max(Ylm)*(1-fac*tickscale)]*ones(size(ticks)),...
                  'color',bk,'clipping','on');
             h3 = line(Xlm,max(Ylm)*[1 1],'color',bk);
             h = [h1(:)' h2(:)' h3(:)'];
         end
      end
   end

   if strcmp(xscale,'log');
      if (xory == 'y' | xory == 'Y');
         hold on
	 fac = diff(log10(Xlm))*0.05;;
	 if (bothsides == 'l' | bothsides == 'y');
            h1 = line(min(Xlm)*[1 1],Ylm,'color',bk);
            h2 = line([min(Xlm);min(Xlm)*(1+fac)]*ones(size(Yt)),...
                [1;1]*Yt(:)', ...
                'color',bk,'clipping','on');
            h3 = line([min(Xlm);min(Xlm)*(1+fac*tickscale)]*ones(size(ticks)),...
                [1;1]*ticks(:)', ...
                'color',bk,'clipping','on');
             h = [h1(:)' h2(:)' h3(:)'];
	     popup(h);
         end
	 if (bothsides == 'r' | bothsides == 'y');
             h1 = line(max(Xlm)*[1 1],Ylm,'color',bk);
             h2 = line([max(Xlm);max(Xlm)*(1-fac)]*ones(size(Yt)),...
                  [1;1]*Yt(:)',...
      	    'color',bk,'clipping','on');
             h3 = line([max(Xlm);max(Xlm)*(1-fac*tickscale)]*ones(size(ticks)),...
                  [1;1]*ticks(:)',...
      	    'color',bk,'clipping','on');
             h = [h1(:)' h2(:)' h3(:)'];
         end
      end
   end
   if exist('popupid');
      if (popupid == 'y');
         popup(h);
      end
   end

