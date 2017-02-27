figure(91); clf; %maxfigure;

ha(1) = subplot(1,4,1:2);

semilogx(eps_chi(:,1),pr_chi); hold on
semilogx(eps_chi(:,2),pr_chi);
semilogx(epsilon(:,1),pr_chi);
semilogx(epsilon(:,2),pr_chi);
axis ij
legend('\epsilon_{\chi} 1','\epsilon_{\chi} 2','\epsilon 1','\epsilon 2','location','best')
title(['Drop ',num2str(drop)])

ha(2) = subplot(1,4,3);
semilogx(n2tmp,pout./100); hold on
semilogx(n2,pr_chi);
title('N^2')
axis ij

ha(3) = subplot(1,4,4);
semilogx(dthetadztmp,pout./100); hold on
semilogx(dthetadz,pr_chi)
title('dTdz')
axis ij
linkaxes(ha,'y')
print('-dpng', fullfile(procdata,cruise,'figs','pdf',[num2str(drop) '_eps_chi_n2_dTdz.png']));

% dTdz = abs(nonmoninterp1(pout/100,dthetadz,pr_chi));

figure(41); clf; %tallfigure
scatter(epsilon(:),eps_chi(:),20,repmat(log10(dthetadz),2,1),'filled');hold on;
plot([10^-12 10^-3],[10^-12 10^-3],'k--')
xlabel('\epsilon'); ylabel('\epsilon_{\chi}'); 
c = colorbar('southoutside'); xlabel(c,'log_{10}dTdz'); caxis([-3 0])
set(gca,'xscale','log','yscale','log','xlim',[10^-12 10^-3],'ylim',[10^-12 10^-3])


print('-dpng', fullfile(procdata,cruise,'figs','pdf',[num2str(drop) '_eps_chi_dTdz_scatter.png']));
