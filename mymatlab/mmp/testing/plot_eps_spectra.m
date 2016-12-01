load D:\mmp\jul01\eps\Psh1_12193.mat
load D:\mmp\jul01\eps\Psh2_12193.mat
load D:\mmp\jul01\eps\eps12193.mat

for ie=1:length(pr_eps)
   clf % plot spectra for nfft=1024 windows first
   loglog(ksh1(:,ie),Psh1(:,ie),'color','r','linewidth',2);
   hold on
   loglog(ksh2(:,ie),Psh2(:,ie),'color','g','linewidth',2);
   if isempty(find(isnan(ksh1(:,ie)+ksh2(:,ie))))
      pc1=interp1(ksh1(:,ie),Psh1(:,ie), kc(ie,1));
      pc2=interp1(ksh2(:,ie),Psh2(:,ie), kc(ie,2));
      loglog([kc(ie,1) kc(ie,2)], [pc1 pc2],'k+'); % mark cutoffs
   end
   xlabel('k / cpm (eps1=rd,eps=gr)');ylabel('Psh / s^{-2}/cpm');
   title(['MMP 12193 pr=' num2str(pr_eps(ie)) ' ,eps=' num2str(epsilon(ie,1)) ',' ...
         num2str(epsilon(ie,2))]);
   keyboard % to allow printing, saving, examining of figures or data
     
end
