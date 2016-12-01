% test_eps_wind.m - investigate how spectral window sizes (512 vs 1024)
%	affect epsilon results, for Lk.Wash drop 12108 during july 2001

%batchprocess4G_mmp % 1024
% Processing drop=12108
% print -depsc -adobecset D:\mmp\jul01\figures\profs12108Weps.eps

%batchprocess4G_mmp % 512
% Processing drop=12108
% print -depsc -adobecset D:\mmp\jul01\figures\profs12108Neps.eps
%% rename epsilon, Psh files (Wide, Nar = 1024,512 pts);  Then:

if 1
   load eps12108Wide
   epsW=epsilon;prW=pr_eps;wW=w_eps;kcW=kc;
   load Psh1_12108Wide
   PsW1=Psh1;ksW1=ksh1;
   load Psh2_12108Wide
   PsW2=Psh2;ksW2=ksh2;
   load eps12108Nar
   load Psh2_12108Nar
   load Psh1_12108Nar
   if 0
      plot(wW,prW,'k-',w_eps,pr_eps,'r-')
      axis ij
      zoom on
      xlabel('W / m s_{-1}');ylabel('p / MPa')
      xlabel('W / m s^{-1}');ylabel('p / MPa')
      title('MMP 12108 (jul01, Lk.Wash), bk=1024 (W), rd=512 (N)')
      print -depsc -adobecset D:\mmp\jul01\figures\fall12108.eps
   end
end

for ie=1:length(prW)
   clf % plot spectra for nfft=1024 windows first
   loglog(ksW1(:,ie),PsW1(:,ie),'color','r','linewidth',3);
   hold on
   loglog(ksW2(:,ie),PsW2(:,ie),'color','g','linewidth',3);
   if isempty(find(isnan(ksW1(:,ie)+ksW2(:,ie))))
      pc1=interp1(ksW1(:,ie),PsW1(:,ie), kcW(ie,1));
      pc2=interp1(ksW2(:,ie),PsW2(:,ie), kcW(ie,2));
      loglog([kcW(ie,1) kcW(ie,2)], [pc1 pc2],'k+'); % mark cutoffs
   end
   % plot spectra for nfft=512 windows covering same data
   for ieN = 2*ie-1:2*ie+1
      loglog(ksh1(:,ieN),Psh1(:,ieN),'color','m','linewidth',1);
      loglog(ksh2(:,ieN),Psh2(:,ieN),'color','c','linewidth',1);
      if isempty(find(isnan(ksh1(:,ieN)+ksh2(:,ieN))))
         pc1=interp1(ksh1(:,ieN),Psh1(:,ieN), kc(ieN,1));
         pc2=interp1(ksh2(:,ieN),Psh2(:,ieN), kc(ieN,2));
         loglog([kc(ieN,1) kc(ieN,2)], [pc1 pc2],'b+'); % mark cutoffs
      end
   end
   xlabel('k / cpm (e1W=rd,e2W=gr; e1N=mg,e2N=cy)');ylabel('Psh / s^{-2}/cpm');
   title(['MMP 12018 prW=' num2str(prW(ie)) ' ,eps=' num2str(epsW(ie,1)) ',' ...
         num2str(epsW(ie,2)) ';' num2str(epsilon(2*ie,1)) ',' ...
         num2str(epsilon(2*ie,2))])
   keyboard % to allow printing, saving, examining of figures or data
     
end


