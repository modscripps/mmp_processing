function sig = cohsig(level,dof),

%-----------------------------cohsig----------------------------------------
%         COHSIG               Documented at 05-15-89      Ren-Chieh Lien
%
%         calculate significance level of coherence spectrum
%
%         sig = cohsig(level,dof)
%         Ex. sig = cohsig(95,dof)
%-----------------------------------------------------------------------------
smdof = find(dof <= 2);
if (length(smdof) ~= 0);
    sig(smdof) = dof(smdof)./dof(smdof);
end
lgdof = find(dof > 2);
if (length(lgdof) ~= 0);
  gsq = 2.*exp(-log(dof(lgdof)));
end
c = gsq./(1-gsq);
csq = 1-exp(c*log(1-0.01*level));
sig(lgdof) = sqrt(csq);
