function c = cross(fev1,fev2,evl)
% c= cross(fev1,fev2,evl)
%   Compute the cross spectrum from two eigenspectra fev1 and fev2.
% fev1 and fev2 may be produced from spectra(x,evc).  evl is
% the column vector of eigenvalues from window(l,f).
% By John Kuehne, June 1990.
a=fev1.*conj(fev2);
c=(a*evl)/sum(evl);
