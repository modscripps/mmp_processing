function c = coherence(p1,p2,c12)
% c= coherence(p1,p2,c12)
%  Compute the simple squared coherence between two time series.
% p1 is the power spectrum of one times series, p2 is the power
% spectrum of the other time series, and c12 is the cross spectrum.
% p1 and p2 are computed from power(fev,evl) and c12 is computed
% from cross(fev1,fev2,evl).
%   By John Kuehne, June 1990.
a=c12.*conj(c12);
b=p1.*p2;
c=a./b;

