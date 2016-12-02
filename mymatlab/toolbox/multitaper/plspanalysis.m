%
% plspanalysis(ff,dof,spx,spy,coh,pha,xlim,splabel1,splabel2,xlab,titletext);
%

 function []= ...
     plspanalysis(ff,dof,spx,spy,coh,pha,xlim,splabel1,splabel2,xlab,titletext);

 if isscalar(dof);
    dof = dof*ones(size(spx));
 end

 clg
 axes('position',[0.3 0.6 0.5 0.3],'xscale','log','yscale','log','box','off');
 hold on
 plot(ff,spx,'linewidth',2);
 sylabel(splabel1);
 [minspx,maxspx]=myminmax(spx(:));
 [conup,conlow]=conospec(dof,minspx);
 plainshaded(ff,conup,ff,conlow(:),[0.9 0.9 0.9]);
 plot(ff,spx,'linewidth',2);
 axis([xlim conup(1)*0.5 maxspx]);
 set(gca,'xticklabels','');
 if exist('titletext');
    title(titletext);
 end

 axes('position',[0.3 0.6 0.5 0.3],'xscale','log','yscale','log','box','on');
 hold on
%plainshaded(ff,spy(:).*conup(:),ff,spy(:).*conlow(:),[0.9 0.9 0.9]);
 plot(ff,spy,'linewidth',1);
 [minspy,maxspy]=myminmax(spy(:));
 axis([xlim minspy maxspy]);
 set(gca,'xticklabels','','yticklabels','','xtick',[],'ytick',[]);

 axes('position',[0.9 0.6 0.01 0.3],'xscale','log','yscale','log','box','off');
 hold on
 plot(ff,spy,'k');
 sylabel(splabel2);
 set(gca,'xticklabels','','xtick',[]);
 axis([xlim minspy maxspy]);


 axes('position',[0.3 0.38 0.5 0.2],'xscale','log','box','on');
 hold on
%fillstair(ff,sig,'x',0,[0.7 0.7 0.7]);
 sig = cohsig(95,dof);
 sigcoh = find(coh(:)./sig(:) >= 1);
 plainfill(ff,sig,'x',0,[0.9 0.9 0.9],'n');
 plot(ff,coh,'o');
 ylabel('Coherence');
 set(gca,'layer','top','xticklabels','');
 axis([xlim 0 1]);


 axes('position',[0.3 0.16 0.5 0.2],'xscale','log','box','on');
 hold on
 [phaup,phalow,stdpha]=phaconf(coh,pha,dof);
 plainshaded(ff,phaup,ff,phalow,[0.9 0.9 0.9]);
 plot(ff,pha,'o');
 if length(sigcoh)>= 1;
    plot(ff(sigcoh),pha(sigcoh),'r.','markersize',20);
 end
%myerrorbar(ff(:),[uppha(:) pha(:) lwpha(:)],'o',0.02);

 plot(xlim,[0 0],'--')
 xlabel(xlab)
 sylabel('Phase (^o)')
 axis([xlim -180 180]);
