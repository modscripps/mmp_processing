%isopycpropfun: [sigt,s,theta]=isoycpropfun(lct,z_given) - ?
%------------------------------------------------------------------------------
%
%           ISOPYCPROPFUN             03-22-94            Ren-Chieh Lien
%
%           properties on the isopycnal surface
%
%   function [sigma,salin,theta]=isopycpropfun(lct,givendepth)
%
%------------------------------------------------------------------------------

    function [sigma,salin,theta]=isopycpropfun(lct,givendepth)


    load /ue/lien/tiwe/combined/theta_sd/combsigma1m
    load /ue/lien/tiwe/combined/theta_sd/combsalin1m
    load /ue/lien/tiwe/combined/theta_sd/combtheta1m
    fituwosulct = fituwosujday - 9/24;
    good = find(fituwosulct >= min(lct) & fituwosulct <= max(lct));
    fituwosusigma1m = fituwosusigma1m(:,good);
    fituwosusalin1m = fituwosusalin1m(:,good);
    fituwosutheta1m = fituwosutheta1m(:,good);
    fituwosulct = fituwosulct(good);

    for k = 1:length(givendepth);

        sigma(k) = mymean(fituwosusigma1m(givendepth(k),:)',20,30,NaN);
        depth = isopycnal(fituwosusigma1m,sigma(k));
        for i=1:length(fituwosulct);
            theta(k,i) = fituwosutheta1m(depth(i),i);
            salin(k,i) = fituwosusalin1m(depth(i),i);
        end
    end
