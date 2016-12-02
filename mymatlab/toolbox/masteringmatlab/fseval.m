function y=fseval(kn,t,wo)
%FSEVAL Fourier Series Function Evaluation.
% FSEVAL(Kn,t,Wo) computes values of a real valued function given
% its complex exponential Fourier series coefficients Kn, at the
% points given in t where the fundamental frequency is Wo rad/s.
% K contains the Fourier coefficients in ascending order:
% Kn = [k   k     ... k  ...  k    k ]
%        -N  -N+1      0       N-1  N
% if Wo is not given, Wo=1 is assumed.
% Note: this function creates a matrix of size:
% rows = length(t) and columns = (length(K)-1)/2

% D. Hanselman, University of Maine, Orono, ME  04469
% 2/9/95
% Copyright (c) 1996 by Prentice Hall, Inc.

if nargin==2,wo=1;end
nk=length(kn);
if rem(nk-1,2)|(nk==1)
 error('Number of elements in K must be odd and greater than 1')
end
n=0.5*(nk-1);			% highest harmonic
nwo=wo*(1:n);			% harmonic indices
ko=kn(n+1);				% average value
kn=kn(n+2:nk).';		% positive frequency coefs
y=ko+2*(real(exp(j*t(:)*nwo)*kn))';
