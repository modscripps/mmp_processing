function [coh,pha,sig] = cohpha(level,xp,sp1,sp2,dof)

%---------------------------cohpha--------------------------------------------
%
%          COHPHA            05-16-89            Ren-Chieh Lien
%
%          Calculate coherence and phase spectrum, and significance level
%
%          [coh,pha,sig] = cohpha(level,xp,sp1,sp2,dof)
%
%           coh: coherence squared
%           sp1 : the spectrum of the first time series
%           sp2 : the spectrum of the second time series
%           xp : the cross-spectrum (C - i Q, C=co-specturm, Q=quad-spectrum)
%           level : confidence interval
%           dof : degree of freedom
%
%          Ex.  [coh,pha,sig] = cohpha(95,hdrvxp,hdsp,rvsp,dof)
%			positive phase occurs when the first time series
%			leads the second
%------------------------------------------------------------------------------
%
     xp=xp(:); sp1=sp1(:); sp2=sp2(:);
     coh = abs(xp).^2 ./ (sp1.*sp2);
     pha = atan2(-imag(xp),real(xp))*180/pi;
     sig = cohsig(level,dof);
