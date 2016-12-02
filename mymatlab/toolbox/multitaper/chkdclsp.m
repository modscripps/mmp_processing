
  load /net/triton/export/home5/lien/tiwe/statistics/dclprop/dclprop

%
%    Different numbers of taper filters
%

  x0 = 0.1; y0 = 1; dx = 0.4; dy = 0.12; ddy = 0.015;
  noft = 12;
  x = log10(dceps(1:914));

  clg
  clear i
  for i=2:2:noft;
      i
      y0 = y0 - dy -ddy;
      axes('position',[x0 y0 dx dy],'box','on','yscale','log','xscale','log');
      hold on
    [tapR,mff]=multitapersp(detrend(x(:)),detrend(x(:)),i/2/length(x),1/24,'R');
    [tap,mff]=multitapersp(detrend(x(:)),detrend(x(:)),i/2/length(x),1/24,'n');
     plot(mff,tapR(:,1),'r','linewidth',2);
     plot(mff,tap(:,1));
      l = [' k = ' int2str(i)];
      legend(l);
      if (i ~= noft);
         set(gca,'xticklabels','');
      end
      axis([0.02 20 1.0e-4 2]);
   end

  x0 = 0.55; y0 = 1; dx = 0.4; dy = 0.12; ddy = 0.015;

  clear i
  for i=2:2:noft;
      i
      y0 = y0 - dy -ddy;
      axes('position',[x0 y0 dx dy],'box','on','yscale','log','xscale','log');
      hold on
    [tapR,mff]=multitapersp(detrend(x(:)),detrend(x(:)),i/2/length(x),1/24,'R');
    [tap,mff]=multitapersp(detrend(x(:)),detrend(x(:)),i/2/length(x),1/24,'n');
     plot(mff,tap(:,1));
      l = [' k = ' int2str(i)];
      legend(l);
      if (i ~= noft);
         set(gca,'xticklabels','');
      end
      axis([0.02 20 1.0e-4 2]);
   end
