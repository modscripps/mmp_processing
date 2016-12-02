function K=fsround(kn,tol)
%FSROUND Round Fourier Series Coefficients.
% FSROUND(Kn) rounds the Fourier Series coefficients Kn
% to eliminate residual terms. Terms satisfying
% abs(Kn)<TOL*max(abs(Kn))        %terms of small magnitude, or
% abs(real(Kn))<TOL*abs(imag(Kn)) %terms with small real part, or
% abs(imag(Kn))<TOL*abs(real(Kn)) %terms with small imag part
% are set to zero. TOL is set equal to sqrt(eps) or can be
% can be specified by FSROUND(Kn,TOL)

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 1/2/95
% Copyright (c) 1996 by Prentice-Hall, Inc. 

if nargin<2,tol=sqrt(eps);end
K=kn(:).';
mkn=abs(kn);
rkn=abs(real(kn));
ikn=abs(imag(kn));

i=find(mkn<tol*max(mkn));K(i)=zeros(1,length(i));
i=find(rkn<tol*ikn);     K(i)=zeros(1,length(i));
i=find(ikn<tol*rkn);     K(i)=zeros(1,length(i));
