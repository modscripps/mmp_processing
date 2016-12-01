% DisplayEpsSpec_mmp
%   Usage: cd to cruise:eps directory and verify that Psh<drop>.mat and
%      eps<drop>.mat are present.  Then execute.
%   Function: load shear spectra and epsilon for a drop and overlay each shear
%      spectrum with the Panchev spectrum for the same epsilon and kinematic
%      viscosity.  Also overlay wavenumber cutoffs.
%   M.Gregg, Jan 95

drop_str=input('drop: ', 's');

mmpfolders;
cruise=read_cruises_mmp(str2num(drop_str));


% edit drop numbers, after checking that files are present.
str=['load ' setstr(39) procdata '\' cruise '\eps\Psh1' drop_str '.mat' setstr(39)];
eval(str)
str=['load ' setstr(39) procdata '\' cruise '\eps\eps' drop_str '.mat' setstr(39)];
eval(str)

x=size(Psh1); nspec=x(2);

clf

for j=1:nspec
   loglog(ksh1(:,j),Psh1(:,j))
   xlabel('k / cpm'), ylabel('Pshear / s^-2 cpm^-1')
   title(['j=', int2str(j), ', pr=', num2str(pr_eps(j)), ...
         ', eps1=',  num2str(eps1(j)), ...
         ', eps1d=', num2str(eps1d(j)) ])
   hold on
   
   % overlay cutoffs
   ref(1,1)=max(Psh1(:,j)); ref(2,1)=min(Psh1(:,j));
   kcref(1,1)=kc1(j); kcref(2,1)=kc1(j);
   kmaxref(1,1)=kmax1(j); kmaxref(2,1)=kmax1(j);
   loglog(kcref,ref), loglog(kcref,ref,'x')
   loglog(kmaxref,ref), loglog(kmaxref,ref,'+')
   
   % overlay Panchev spectrum
   kvis=nu(s(j),t(j),pr_eps(j));
   [kpan,Ppan] = panchev(eps1(j),kvis);
   loglog(kpan,Ppan,'o')
   hold off
   
   pause(1)
end