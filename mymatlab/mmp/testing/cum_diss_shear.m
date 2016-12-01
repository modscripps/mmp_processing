% cum_diss_shear.m
% calculates and plots Panchev spectra of transverse shear
% at decade intervals

%dk=.5;
k=logspace(0,2);
kvis=2e-6;
%clf
%wysiwyg
%wygiwys
for i=-11:0
   epsilon=10^i; shearsq=epsilon/(7.5*kvis);
   knu=(epsilon/kvis^3)^(1/4)/(2*pi);
   %dk=knu/200;
   %k=dk:dk:200*dk;
   [kp,Pp] = panchev(epsilon,kvis,k);
   %cumsh=dk*cumsum(Pp);
   %j=find(cumsh>=.05*shearsq & cumsh<=0.95*shearsq);
   
   %loglog(kp(j),cumsh(j),'w','linewidth',[1])
   loglog(kp,Pp,'linewidth',[.5])
   hold on
   %text(kp(j(length(j)))*1.3,Pp(j(length(j))),num2str(i))
   %text(kp(j(length(j)))*1.3,cumsh(j(length(j))),num2str(i))
end
axis([1 100 1e-8 1e2])
xlabel('\14\times k / cpm')
ylabel('\14\times \Phi_{shear} (k) dk')
title('Panchev & Kesich (1969) transverse shear spectrum with a=1.6')