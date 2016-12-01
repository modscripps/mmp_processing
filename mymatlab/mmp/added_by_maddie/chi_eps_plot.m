figure(10); clf
set(gcf,'Units','normalized','OuterPosition',[0 0 1 1]);

pos_tsd = [.05 .2 .3 .75];
pos_eps = [.355 .2 .15 .75];
pos_chi = [.51 .2 .15 .75];
pos_eps_chi = [.665 .2 .15 .75];
pos_dTdz = [.82 .2 .15 .75];
% pos_n2 =a


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot temp, salinity, sigma_theta on the left
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%MHA 5/2015: use salinity in PSU!!
theta=sw_ptmp(salinity*1000,temp,pr_thetasd,0);
sgth=sw_dens(salinity*1000,theta,zeros(size(salinity)))-1000;

axes('position',pos_tsd,'box','on','yticklabel','','ydir','reverse', ...
    'xscale','log','linewidth',1,'fontsize',12);
% Determine plotting limits
pmin=0;
ig=find(~isnan(pr_thetasd)); pmax=max(pr_thetasd(ig));
pmax=1.03*pmax;
igt=find(~isnan(theta)); igs=find(~isnan(salinity)); igth=find(~isnan(sgth));
tmin=min(theta(igt)); tmax=max(theta(igt)); tspan=tmax-tmin;
tmin=tmin-.03*tspan; tmax=tmax+.03*tspan;
S=1000*salinity;
smin=min(S(igs)); smax=max(S(igs)); span=smax-smin;
if span==0 span=1; end
smin=smin-0.1*span; smax=smax+0.1*span;
sgmin=min(sgth(igth)); sgmax=max(sgth(igth)); sgspan=sgmax-sgmin;
sgmin=sgmin-.03*sgspan; sgmax=sgmax+.03*sgspan;
Tlimits=[tmin tmax pmin pmax];
Slimits=[smin smax pmin pmax];
SGlimits=[sgmin sgmax pmin pmax];
limits=[Tlimits; Slimits; SGlimits];
%
ipl_pr = [1:5:length(pr_thetasd)]; % plot only every 5th scan
X=[theta(ipl_pr) S(ipl_pr) sgth(ipl_pr)];
Y=pr_thetasd(ipl_pr)*ones(1,3);
xlabeltext=['       \theta / {}^o C     ';
    '         1000 s            ';
    '\sigma_{\theta} / kg m^{-3}'];
titletext='';
ylabeltext='p  / MPa  ';
linetype=[' r-';' g-';' b-'];
dy=.06;
%
axestobelinked = multixaxis3(X,Y,xlabeltext,ylabeltext,titletext,[],[],[],[],[],...
    pos_tsd,dy,limits,1,1);
% linkaxes(axestobelinked,'y');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot epsilon
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~isempty(epsch)
    % Set plotting limits
    h = axes('position',pos_eps,'box','on','yticklabel','','ydir','reverse', ...
        'xscale','log','linewidth',1,'fontsize',12);
    axestobelinked = [axestobelinked h];
    hold on
    Hl_eps1=plot(epsilon(:,1),pr_eps,'r');
    set(Hl_eps1,'linewidth',[1]);
    Hl_eps2=plot(epsilon(:,2),pr_eps,'g');
    set(Hl_eps2,'linewidth',[1]);
    igeps=find(pr_eps>.05);
    maxeps=max(max(epsilon(igeps,:)));
    if maxeps>1e-5 maxeps=1e-5; end
    mineps=1e-10; maxeps=10^(ceil(log10(maxeps)));
    if maxeps<=mineps
        maxeps=10*mineps;
    end
    xtick=[floor(log10(mineps)):ceil(log10(maxeps))];
    xtick=10.^xtick;
    %xticklabel=num2str(xtick,2);
    
    %
    xlabel('\epsilon / W kg^{-1} (v1-r, v2-g)')
    axis([mineps maxeps pmin pmax])
    set(gca,'xtick',xtick)
    set(gca,'yminortick','on')
    %     linkaxes(axestobelinked,'y');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot chi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
if ~isempty(tlch)
    h=axes('position',pos_chi,'box','on','yticklabel','','ydir','reverse', ...
        'xscale','log');
    hold on
    Hl_chi1=plot(chi(:,1),pr_chi,'r');
    if length(tlch)==2
        Hl_chi2=plot(chi(:,2),pr_chi,'g');
        % following line causing problems 7/22/96  replace w/below
        %igchi=find(~isnan(chi(:,1)) & ~isnan(chi(:,2)) & pr_chi>.05);
        igchi=find(~isnan(chi(:,1))& pr_chi>.05);
    elseif length(tlch)==1
        igchi=find(~isnan(chi(:,1))& pr_chi>.05);
    end

    igeps=find(pr_chi>.05);
    maxeps=max(max(epsilon(igeps,:)));
    if maxeps>1e-5 maxeps=1e-5; end
    mineps=1e-10; maxeps=10^(ceil(log10(maxeps)));
    if maxeps<=mineps
        maxeps=10*mineps;
    end
    minchi=min(chi(igchi));minchi=max(minchi,1e-11); minchi=10^(floor(log10(minchi)));
    maxchi=max(chi(igchi));maxchi=min(maxchi,1e-5); maxchi=10^(ceil(log10(maxchi)));
    if minchi>maxchi/100 maxchi=100*minchi; end
    xtick=[floor(log10(mineps)):ceil(log10(maxeps))];
    xtick=10.^xtick;
    %
    set(Hl_chi1,'linewidth',[1.5]);
    xlabel('\chi / K^2 s^{-1}')
    axis([mineps maxeps pmin pmax]);
    axestobelinked = [axestobelinked h];
    set(gca,'xtick',xtick)
    set(gca,'yminortick','on')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot eps_chi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
if ~isempty(tlch)
    h=axes('position',pos_eps_chi,'box','on','yticklabel','','ydir','reverse', ...
        'xscale','log');
    hold on
    Hl_eps_chi1=plot(eps_chi(:,1),pr_chi,'r');
    if length(tlch)==2
        Hl_eps_chi2=plot(eps_chi(:,2),pr_chi,'g');
    end
    xtick=[floor(log10(minchi)):ceil(log10(maxchi))];
    xtick=10.^xtick;
    %
    set(Hl_chi1,'linewidth',[1.5]);
    xlabel('\epsilon_{\chi} / W kg^{-1}')
    axis([minchi maxchi pmin pmax]);
    axestobelinked = [axestobelinked h];
    set(gca,'xtick',xtick)
    set(gca,'yminortick','on')
end
% linkaxes(axestobelinked,'y');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot dTdz and n2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

axes('position',pos_dTdz,'box','on','yticklabel','','ydir','reverse', ...
    'xscale','log','linewidth',1,'fontsize',12);
% Determine plotting limits
pmin=0;
pmax=nanmax(pr_chi); pmax=1.03*pmax;
n2min=nanmin(n2); n2max=nanmax(n2); n2span=n2max-n2min;
n2min=n2min-.03*n2span; n2max=n2max+.03*n2span;
dTdzmin=nanmin(dthetadz); dTdzmax=nanmax(dthetadz); dTdzspan=dTdzmax-dTdzmin;
dTdzmin=dTdzmin-.03*dTdzspan; dTdzmax=dTdzmax+.03*dTdzspan;
n2limits=[n2min n2max pmin pmax];
dTdzlimits=[dTdzmin dTdzmax pmin pmax];
limits=[n2limits; dTdzlimits];
%
X=[n2 dthetadz];
Y=pr_chi*ones(1,3);
clear xlabeltext
xlabeltext=['      N^2 /  (rad/s)^2     '; ...
    'd{\theta}dz / {}^o C m^{-1}'];
titletext='';
ylabeltext='p  / MPa  ';
linetype=[' r-';' g-';' b-'];
dy=.06;
%
axestobelinked = multixaxis3(X,Y,xlabeltext,ylabeltext,titletext,[],[],[],[],[],...
    pos_dTdz,dy,limits,1,1);

