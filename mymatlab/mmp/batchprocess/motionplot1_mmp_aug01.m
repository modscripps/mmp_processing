% motionplot1_mmp.m

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
     pmin=0; pmax=1.05*max(pr_thetasd(ig));
	else
	  pmin=NaN; pmax=NaN;
  end
	%
  ig=find(~isnan(w));
  if ~isempty(ig)
     wmin=min(w(ig)); wmin=max(wmin,0.48); % Hardwire for Home00
     wmax=max(w(ig)); wspan=wmax-wmin;
	  wmin=wmin-.03*wspan; wmax=wmax+.03*wspan;
	  plotw='y'; 
  else
     plotw='n'; 
  end
  %
  % If altimeter data does not exist, make a simple plot of
  % fall rate, w.  Otherwise, determine the plotting limits
  % for h_tsbe, pr_thsbe, and pbot and do a multixaxis plot
  
  % h_tsbe = [];  %%%%%% work around 
  if isempty(h_tsbe) | isempty(prh_tsbe)
     axes('position',panel_pos(1,:),'box','on','ydir','reverse', ...
      'xscale','linear')
     hold on
     Hl_w=plot(w,pr_thetasd);
     xlabel('w / m s^{-1}')
     ylabel('p / MPa')
     %axis([wmin wmax pmin pmax])
     axis([0.30 wmax pmin pmax])
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
    
     h=[h_tsbe(:); NaN*ones(nscans-nh,1)];
     prh=[prh_tsbe(:); NaN*ones(nscans-nh,1)];
     pb=[pbot(:); NaN*ones(nscans-nh,1)];
    
     % if w is being plotted separately, don't plot it here
    
     limits=[Wlimits; hlimits; pblimits];
     %
    
     X=[w(:) h pb];
     Y=[pr_thetasd(:) prh prh];
     xlabeltext=['  w / m s^{-1}  ';
                 '  h_{tsbe} / m  ';
			        '   pbot / MPa   '];
     titletext='';
     ylabeltext='p / MPa';
     linetype=['-k';'+r';'og'];
     dy=.06;
     %
     %multixaxis(X,Y,xlabeltext,ylabeltext,titletext,linetype, ...
     % panel_pos(1,:),dy,limits,1,1);
     multixaxis3(X,Y,xlabeltext,ylabeltext,titletext,[],[],[],[],[],...
        panel_pos(1,:),dy,limits,1,1);
  end
  ndone=1;
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  %%%%%%%%%%%%%% Panel 2, accelerometers %%%%%%%%%%%%%%%%%%%%%%%
  %
  % Determine plotting limits, using a2 & a2 (a3 & a4 on mmp aren't
	% very different)
  ig=find(~isnan(tilt(:,1)) & ~isnan(tilt(:,2)) & pr_thetasd>.08);
  if ~isempty(ig)
     tiltmax=1.5*max(max(tilt(ig,1)),max(tilt(ig,2))); 
     tiltmin=1.5*min(min(tilt(ig,1)),min(tilt(ig,2))); 		
     [m,ntilt]=size(tilt);
  end
  axes('position',panel_pos(2,:),'box','on','yticklabel','','ydir','reverse', ...
      'xscale','linear')
  hold on
  Hl_a1=plot(tilt(:,1),pr_thetasd,'linewidth',2,'color','r');
  Hl_a2=plot(tilt(:,2),pr_thetasd,'linewidth',1,'color','g');
  if ntilt==4
     Hl_a3=plot(tilt(:,3),pr_thetasd,'linewidth',2,'color','r','linestyle',':');
     Hl_a2=plot(tilt(:,4),pr_thetasd,'linewidth',1,'color','g','linestyle',':');
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
     lcolor=[];
     if ~isempty(obs)
        % Determine plotting limits
        ig=find(~isnan(obs));
        if ~isempty(ig)
           obsmax=max(obs(ig)); obsmin=min(obs(ig)); obsspan=obsmax-obsmin;
           obsmin=obsmin-.03*obsspan; obsmax=obsmax+.03*obsspan;
           X = obs; Y = pr_obs;
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
           X = [X dox]; Y = [Y pr_dox];
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
        ig=find(~isnan(vac(:,1)) & ~isnan(vac(:,2)) & pr_vac>0.08);
        if ~isempty(ig)
           vacmax=max(max(vac(ig,1)),max(vac(ig,2))); 
           vacmin=min(min(vac(ig,1)),min(vac(ig,2))); 
           vacspan=vacmax-vacmin;
           vacmin=vacmin-.03*vacspan; vacmax=vacmax+.03*vacspan;
           axes('position',panel_pos(ndone+1,:),'box','on','yticklabel','','ydir','reverse', ...
              'xscale','linear')
           hold on
           Hl_vac1=plot(vac(:,1),pr_vac);
           set(Hl_vac1,'color','r','linewidth',2)
           hold on
           Hl_vac2=plot(vac(:,2),pr_vac,'color','g');
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
           Hl_kvh=plot(hdg,pr_scan);
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


