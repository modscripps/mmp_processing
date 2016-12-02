function [h,ih]=fsharm(kn,n)
%FSHARM Fourier Series Harmonic Component Selection.
% FSHARM(Kn,N) returns the (N)th harmonic component of the
% complex exponential FS given by Kn.
% FSHARM(Kn) returns the DC component.
% [H,i]=FSHARM(Kn,N) returns the index of the selected
% harmonic H in i.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 1/12/95
% Copyright (c) 1996 by Prentice-Hall, Inc. 

m=length(kn);
if nargin==1,n=0;end
if rem(m,2),      % kn has an odd number of elements
  ih=(m+1)/2+n;   % index of desired harmonic
  if (ih>m)|(ih<1)
   h=0;ih=[];     % desired harmonic is outside range
  else
   h=kn(ih);       % index is fine
   if n==0,h=real(h);end  %DC component is real only!
  end
else,             % x has an even number of harmonics
  h=[];ih=[];
  error('Kn must have an odd number of elements')
end
