%isopycnal: z = isopycnal(sigt_file,sigt_given) - depth of sigmat value
%------------------------------------------------------------------------------
%
%            ISOPYCNAL              11-18-93           Ren-Chieh Lien
%
%            Find Isopycnal Depth
%
%    function depth = isopycnal(sigma_theta,sigma_given);
%
%    ex.      depth = isopycnal(fituwosusigma1m,22.76);
%
%------------------------------------------------------------------------------


     function depth = isopycnal(D,sigma);

     [ndepth,nprf]=size(D);

     for i=1:nprf;
         dD = abs(D(:,i) - sigma);
         dep = find(~isnan(dD));
         depind = min(find(dD(dep) == min(dD(dep))));
         depth(i) = dep(depind);
     end
