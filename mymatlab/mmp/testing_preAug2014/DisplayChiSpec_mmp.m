function DisplayChiSpec_mmp(drop)
% DisplayChiSpec_mmp
%   Function: load shear spectra and epsilon for a drop and overlay each shear
%      spectrum with the Panchev spectrum for the same epsilon and kinematic
%      viscosity.  Also overlay wavenumber cutoffs.
%   M.Gregg, Jan 95


mmpfolders;
cruise=read_cruises_mmp(drop);
% load eps file for drop
eps_str=['load ' setstr(39) procdata '\' cruise '\eps\eps' num2str(drop) ...
      '.mat' setstr(39)];
eval(eps_str)
% load chi file for drop
chi_str=['load ' setstr(39) procdata '\' cruise '\chi\chi' num2str(drop) ...
      '.mat' setstr(39)];
eval(chi_str)
% load tgrad spectra
spec_str=['load ' setstr(39) procdata '\' cruise '\chi\Ptg1' num2str(drop) ...
      '.mat' setstr(39)];
eval(spec_str)

x=size(Ptg1); nspec=x(2);

clf

for j=1:nspec
   loglog(ktg1(:,j),Ptg1(:,j))
   xlabel('k / cpm'), ylabel('Ptgrad / (K/m)^2 cpm^-1')
   title(['j=', int2str(j) , ', pr=' num2str(pr_eps(j)), ', w=' num2str(w(j)), ...
         ', eps1=',  num2str(eps1(j)) ,  ', chi1=' num2str(chi1(j)) ])
   hold on;
   
   % overlay cutoffs
   ref(1,1)=max(Ptg1(:,j)); ref(2,1)=min(Ptg1(:,j));
   kcref(1,1)=kcth1(j); kcref(2,1)=kcth1(j);
   loglog(kcref,ref), loglog(kcref,ref,'x')
   
   % overlay Batchelor spectrum
   kvis=nu(s(j),t(j),pr_eps(j));
   ktemp=kt(s(j),t(j),pr_eps(j));
   if ~isnan(eps1(j)) & ~isnan(chi1(j)) & ~isnan(kvis) & ~isnan(ktemp)
      [kbat,Pbat] = batchelor_logspace(eps1(j),chi1(j),kvis,ktemp);
      loglog(kbat,Pbat,'o')
   end
   hold off;
   
   pause
end