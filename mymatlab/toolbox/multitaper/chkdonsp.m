
  [x,nff,nspx] = genar(4,[2.7607;-3.8106;2.6535;-0.9238],2^10);
  [y,nff,nspy] =  genar(2,[0.75;-0.5],2^10);
  npts = length(x);

  load  AR2 -ascii
  y = AR2;

  load  AR4 -ascii
  x = AR4;

%
%    Different numbers of taper filters
%

  x0 = 0.1; y0 = 1; dx = 0.3; dy = 0.12; ddy = 0.015;
  noft = 11;

  clg
  clear i
  for i=1:2:noft;
      i
      y0 = y0 - dy -ddy;
      axes('position',[x0 y0 dx dy],'box','on','yscale','log');
      hold on
      plot(nff,nspx,'r','linewidth',2);
      [tap,mff]=multitapersp(detrend(x(:)),detrend(y(:)),i/2/length(x), 1);
      plot(mff,tap(:,1));
      l = [' k = ' int2str(i)];
      legend(l);
      if (i ~= noft);
         set(gca,'xticklabels','');
      end
      axis([0 0.5 0 Inf]);
  end

  x0 = 0.55; y0 = 1; dx = 0.3; dy = 0.12; ddy = 0.015;
  noft = 16;

  clear i
  for i=1:3:noft;
      i
      y0 = y0 - dy -ddy;
      axes('position',[x0 y0 dx dy],'box','on','yscale','log');
      hold on
      plot(nff,nspy,'r','linewidth',2);
      [tap,mff]=multitapersp(detrend(x(:)),detrend(y(:)),i/2/length(x), 1);
      plot(mff,tap(:,2));
      l = [' k = ' int2str(i)];
      legend(l);
      if (i ~= noft);
         set(gca,'xticklabels','');
      end
      axis([0 0.5 0 Inf]);
  end

  break
  loglog(ff,spx,mff,rainbow(:,1),[-Inf Inf],[1 1],'--',nff,nspx);
  pause
  loglog(ff,spy,mff,rainbow(:,2),[-Inf Inf],[1 1],'--',nff,nspy);

  bins = crtbins(npts,10,30);

  [ff,dof,spx,spy,xp]=specfun(x,y,bins,npts,npts,1,2,'','','','');
