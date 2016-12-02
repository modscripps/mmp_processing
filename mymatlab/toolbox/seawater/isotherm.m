%isotherm: z=isotherm(D) - depth of isotherm
%------------------------------------------------------------------------------
%
%            ISOTHERM              11-18-93           Ren-Chieh Lien
%
%            Find Isothermal  Depth
%
%    function depth = isotherm(D);
%
%------------------------------------------------------------------------------


     function depth = isotherm(D);

     load /ue/lien/tiwe/combined/daily/dailytsd
  
     for i=1:39;
         dD = abs(daytheta(:,i) - D);
         dep = find(dD ~= NaN);
         depind = find(dD(dep) == min(dD(dep)));
         depth(i) = dep(depind);
     end
