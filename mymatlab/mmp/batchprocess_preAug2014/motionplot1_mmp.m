% motionplot1_mmp.m
% revised 07-sep-01 for better limits, lesser points

if drop_flag==1 | drop_flag==2

  Hf_main=figure;
  orient landscape
  wysiwyg
  ig=get(Hf_main,'position');
  set(Hf_main,'position',ig*.85); % to fit on screen better

  %
  % Determine the number of panels
  npanels=2; % min # for w,h and acceleration
  if ~exist('obs','var')
     obs=[];
  end
  if ~exist('dox','var')
     dox=[];
  end
  if ~isempty(obs) | ~isempty(dox)
     npanels=npanels+1;
  end
  
  if exist('vac')
     if ~isempty(vac)
        npanels=npanels+1;
     end
  end
  if exist('hdg')
     if ~isempty(hdg)
        npanels=npanels+1;
     end
  end
  %
  % Define positions of the panels
  x0=.1; y0=.2; xgap=.04; height=.75;
  width=(.95-x0-(npanels-1)*xgap)/npanels;
  panel_pos=NaN*ones(npanels,4);
  for i=1:npanels
     panel_pos(i,:)=[x0+(i-1)*(xgap+width) y0 width height];
  end
  text_pos=[.5 .05 .44 .1];
  %
  %%%%%%%%%%%%%%% Panel 1: w, altimeter, pbot %%%%%%%%%%%%%%%%%%%
  %
  % Determine plotting limits
  ig=find(~isnan(pr_thetasd));
  if ~isempty(ig)
     pmin=0; pmax=1.03*max(pr_thetasd(ig));
  else
	  pmin=NaN; pmax=NaN;
  end
  %
  fpr=0.02; % for plot limits, ignore shallower w's
  if pmax>0.15
     fpr=0.1;
  end
  ig=find(~isnan(w) & pr_thetasd>fpr);
   if ~isempty(ig)
      wmin=min(w(ig)); wmax=max(w(ig));
      psp = max(pmax-pmin, 0.01); % try to exclude drop-ends from range calc
      ig = find(pr_thetasd>(pmin+psp/20) & pr_thetasd<(pmax-psp/20) & ~isnan(w));
      if ~isempty(ig), wmin = max(wmin,min(w(ig))); end
      wspan=max(wmax-wmin,0.01);
      wmin=wmin-.03*wspan; wmax=wmax+.03*wspan;
      plotw='y'; 
   else
      plotw='n'; 
   end
  %
  % If altimeter data does not exist, make a simple plot of
  % fall rate, w.  Otherwise, determine the plotting limits
  % for h_tsbe, pr_thsbe, and pbot and do a multixaxis plot
  
  ipl_pr = [1:5:length(pr_thetasd)]; % plot only every 5th scan
  npl_pr = length(ipl_pr);
  
  if isempty(h_tsbe) | isempty(prh_tsbe)
     axes('position',panel_pos(1,:),'box','on','ydir','reverse', ...
      'xscale','linear')
     hold on
     Hl_w=plot(w(ipl_pr),pr_thetasd(ipl_pr));
     xlabel('w / m s^{-1}')
     ylabel('p / MPa')
     axis([wmin wmax pmin pmax])
  else
     ig=find(~isnan(pbot));
     if ~isempty(ig)
        pbmin=min(pbot(ig)); pbmax=1.1*max(pbot(ig));
     else
		  pbmin=0; pbmax=1;
     end
     %
     ig=find(~isnan(h_tsbe));
     if ~isempty(ig) & length(ig)>1
        hmin=min(h_tsbe(ig)); hmax=max(h_tsbe(ig)); hspan=hmax-hmin;
        hmin=hmin-.06*hspan; hmax=hmax+.06*hspan;
        ploth='y'; nh=length(h_tsbe);
     else
        ploth='n'; hmin=0; hmax=1; % use arbitrary plotting limits
        nh=1;
     end
     %
     Wlimits=[wmin wmax pmin pmax];
     hlimits=[hmin hmax pmin pmax];
     pblimits=[pbmin pbmax pmin pmax];
     
     h = h_tsbe(:); prh = prh_tsbe(:); pb = pbot(:);
     wp = w(ipl_pr); prp = pr_thetasd(ipl_pr);
     xpad = NaN*ones(abs(npl_pr-nh),1); % to make vectors same size
     if npl_pr>nh
        h = [h; xpad]; prh = [prh; xpad]; pb = [pb; xpad];
     elseif nh>npl_pr
        wp = [wp; xpad]; prp = [prp; xpad];
     end
    
     limits=[Wlimits; hlimits; pblimits];
     %
    
     X=[wp h pb];
     Y=[prp prh prh];
     xlabeltext=['  w / m s^{-1}  ';
                 '  h_{tsbe} / m  ';
			        '   pbot / MPa   '];
     titletext='';
     ylabeltext='p / MPa';
     linetype=['-k';'+r';'og'];
     dy=.06;
     %
     multixaxis3(X,Y,xlabeltext,ylabeltext,titletext,[],[],[],[],[],...
        panel_pos(1,:),dy,limits,1,1);
  end
  ndone=1;
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  %%%%%%%%%%%%%% Panel 2, accelerometers %%%%%%%%%%%%%%%%%%%%%%%
  %
  % Determine plotting limits, using a1 & a2 (mmp3: also use a3 & a4)
  psp = max(pmax-pmin, 0.01); % try to exclude drop-ends from range calc
  ig = find(pr_thetasd>max(pmin+psp/20, 0.08) & pr_thetasd<(pmax-psp/20));
  if isempty(ig), ig=ipl_pr(3:end-2); end % may still get error for small drop
  tiltmax=1.5*max(max(tilt(ig,:))); 
  tiltmin=1.5*min(min(tilt(ig,:))); 		
  [m,ntilt]=size(tilt);
  axes('position',panel_pos(2,:),'box','on','yticklabel','','ydir','reverse', ...
      'xscale','linear')
  hold on
  Hl_a1=plot(tilt(ipl_pr,1),pr_thetasd(ipl_pr),'linewidth',2,'color','r');
  Hl_a2=plot(tilt(ipl_pr,2),pr_thetasd(ipl_pr),'linewidth',1,'color','g');
  if ntilt==4
     Hl_a3=plot(tilt(ipl_pr,3),pr_thetasd(ipl_pr),'linewidth',2, ...
        'color','r','linestyle',':');
     Hl_a2=plot(tilt(ipl_pr,4),pr_thetasd(ipl_pr),'linewidth',1, ...
        'color','g','linestyle',':');
  end
  
  xlabel('tilt / deg')
  axis([tiltmin tiltmax pmin pmax])
  ndone=ndone+1;
  %
  %%%%%%%%%%%%%% obs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  if ~isempty(obs) | ~isempty(dox)
     obplot=0;
     X=[]; Y=[]; xlabeltext=[];
     ylabeltext=''; titletext='';
     lcolor=[]; limits=[];
     if ~isempty(obs)
        % Determine plotting limits
        ig=find(~isnan(obs));
        if ~isempty(ig)
           obsmax=max(obs(ig)); obsmin=min(obs(ig)); obsspan=obsmax-obsmin;
           obsmin=obsmin-.03*obsspan; obsmax=obsmax+.03*obsspan;
           X = obs(ipl_pr); Y = pr_obs(ipl_pr);
           xlabeltext = '  obs / FTU   ';
           limits=[obsmin obsmax pmin pmax];
           lcolor=[0 0 0];
           obplot=1;
        end
     end
     if ~isempty(dox)
        % Determine plotting limits
        ig=find(~isnan(dox));
        if ~isempty(ig)
           doxmax=max(dox(ig)); doxmin=min(dox(ig)); doxspan=doxmax-doxmin;
           doxmin=doxmin-.03*doxspan; doxmax=doxmax+.03*doxspan;
           X = [X dox(ipl_pr)]; Y = [Y pr_dox(ipl_pr)];
           xlabeltext = [xlabeltext; 'do / ml l^{-1}'];
           limits=[limits; doxmin doxmax pmin pmax];
           lcolor=[lcolor; 1 0 0];
        end
     end
     if ~isempty(X)
        dy=.06;
        multixaxis3(X,Y,xlabeltext,ylabeltext,titletext,[10 10 10],[],lcolor,[],[],...
           panel_pos(ndone+1,:),dy,limits,1,0);
        ndone=ndone+1;
     end
  end
  %
  %%%%%%%%%%%%%% vac %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  if exist('vac')
     if ~isempty(vac)
        % Determine plotting limits
        ig=find(pr_vac>0.08);
        if ~isempty(ig)
           vacmax=max(max(vac(ig,:))); 
           vacmin=min(min(vac(ig,:))); 
           vacspan=vacmax-vacmin;
           vacmin=vacmin-.03*vacspan; vacmax=vacmax+.03*vacspan;
           axes('position',panel_pos(ndone+1,:),'box','on','yticklabel','', ...
              'ydir','reverse', 'xscale','linear');
           hold on
           Hl_vac1=plot(vac(ipl_pr,1),pr_vac(ipl_pr));
           set(Hl_vac1,'color','r','linewidth',2)
           hold on
           Hl_vac2=plot(vac(ipl_pr,2),pr_vac(ipl_pr),'color','g');
           xlabel('vac1, vac2 / m s^{-1}')
           axis([vacmin vacmax pmin pmax])
           ndone=ndone+1;
        end
     end
  end
  %
  %%%%%%%%%%%%%%%%%%%% kvh %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %
  if exist('hdg')
     if ~isempty(hdg)
        % Determine plotting limits
        ig=find(~isnan(hdg));
        if ~isempty(ig)
           kvhmax=max(hdg(ig)); kvhmin=min(hdg(ig)); kvhspan=kvhmax-kvhmin;
           kvhmin=kvhmin-.03*kvhspan; kvhmax=kvhmax+.03*kvhspan;
           axes('position',panel_pos(ndone+1,:),'box','on','yticklabel','','ydir','reverse', ...
              'xscale','linear')
           hold on
           Hl_kvh=plot(hdg(ipl_pr),pr_scan(ipl_pr));
           xlabel('hdg / deg')
           axis([kvhmin kvhmax pmin pmax])
           ndone=ndone+1;
        end
     end
  end
  %
  %%%%%%%%%%%%%%%%%%% label %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  axes('position',text_pos,'box','off')
  hold on
  axis off
  %
  line1_str=['cruise=' cruise ',  drop=' int2str(drop) ', ' mmpid];
  Ht1=text(.05,.65, line1_str);
  set(Ht1,'fontsize',12,'fontweight','bold')
  line2_str=['tilt: a1 (solid, thick, red), a2 (solid, thick, green),'];
             
  text(.05,.35, line2_str)
  line3_str=['tilt: a3 (dotted, thin, green), a4 (dotted, thin, red)'];
  text(.05,.15, line3_str)

end


