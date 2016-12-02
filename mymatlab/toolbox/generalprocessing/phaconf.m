function [up,lw,stdpha] = phaconf(coh,pha,dof);
%-------------------------phaconf-------------------------------------------
%
%        PHACONF                 07-31-91               Ren-Chieh Lien
%
%        confidence interval of phase spectrum
%
%
%        function [up,lw,stdpha] = phaconf(coh,pha,dof);
%
%        up and lw indicates the error bar for phase
%
%------------------------------------------------------------------------------
  phavar = ((1-coh.^2)./coh.^2 )./dof;
  stdpha = asin(sqrt(phavar))*180/pi;
  phavar = asin(1.96*sqrt(phavar))*180/pi;
  up =  pha + phavar;
  lw =  pha - phavar;
