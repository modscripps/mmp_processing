% eps_sigtheta
%   Function: to overlap profiles of epsilon and sigma_theta

pmin=.4;
pmax=.75;

clf

ie=find(p_eps>pmin & p_eps<pmax);
is=find(p>pmin & p<pmax);

% plot epsilon as filled stairstep
axes('position',[0.32 0.2 0.48 0.6],'ydir','reverse', ...
     'xscale','log','ticklength',[0.02 0.03]);
hold on
fillstair(eps_x(ie),p_eps(ie),'y',1e-10,[0.8 0.8 0.8],'w');

% plot, label, and scale epsilon axis
set(gca,'layer','top');
sxlabel('\15\times {\16 \symb e} / W kg^{-1}');
axis([1e-10 1e-1 pmin pmax])

% label y axis
ylabel('p / MPa')

% plot sigma_theta
axes('position',[0.32 0.2 0.48 0.6],'ydir','reverse','box', ...
     'on','xtick',[]);
hold on
plot(sigtheta(is),p(is),'w','linewidth',2);
axis([1014 1027 pmin pmax]);

% make sigma_theta axis above plot by plotting an invisible
% profile in a tiny box and then labeling it
axes('position',[0.32 0.86 0.48 0.0005],'ydir','reverse', ...
	 'box', 'off','xtick',[]);
plot(sigtheta(is),p(is),'k','linewidth',2); % plot invisible line	 
stitle('\16\times  {\18 \symb s_q} / kg m^{-3}');
axis([1014 1027 pmin pmax]);
