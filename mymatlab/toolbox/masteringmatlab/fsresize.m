function [y,iy]=fsresize(kn,n)
%FSRESIZE Resize a Fourier Series.
% FSRESIZE(Kn,N) resizes the complex exponential FS Kn to
% have N harmonics. If N is greater than the number of
% harmonics in Kn, zeros are added to the result.
% If N is less than the number of harmonics in Kn, the
% result is a truncated version of the input.
%
% FSRESIZE(Kn,Un) resizes the complex exponential FS Kn to
% have the same number of harmonics as the FS Un.
%
% [Yn,iy]=FSRESIZE(Kn,N) additionally returns the harmonic
% index of the result.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 1/12/95
% Copyright (c) 1996 by Prentice-Hall, Inc. 

m=length(kn);
N=length(n);
if N>1, n=(N-1)/2; end
nkn=(m-1)/2;	% number of harmonics in kn
if n>=nkn
  zpadd=zeros(1,n-nkn);
  y=[zpadd kn(:).' zpadd];
else
  no=nkn+1;		%index of DC harmonic
  y=kn(no-n:no+n);
end
m=(length(y)-1)/2;
iy=-m:m;
