function w = fswindow(N,wt,a)
%FSWINDOW Generate Window Functions.
% FSWINDOW(N,TYPE) creates a window vector of type TYPE having
% a length equal to the scalar N.
% FSWINDOW(X,TYPE) creates a window vector of type TYPE having
% a length and orientation the same as the vector X.
% FSWINDOW(.,TYPE,alpha) provides a parameter alpha as required
% for some window types.
% FSWINDOW with no input arguments returns a string matrix whose
% i-th row is the i-th TYPE given below.
%
% TYPE is a string designating the window type desired:
% 'rec' = Rectangular or Boxcar
% 'tri' = Triangular or Bartlet
% 'han' = Hann or Hanning
% 'ham' = Hamming
% 'bla' = Blackman common coefs.
% 'blx' = Blackman exact coefs.
% 'rie' = Riemann {sin(x)/x}
% 'tuk' = Tukey,  0< alpha < 1; alpha = 0.5 is default
% 'poi' = Poisson, 0< alpha < inf; alpha = 1 is default
% 'cau' = Cauchy, 1< alpha < inf; alpha = 1 is default
% 'gau' = Gaussian, 1< alpha < inf; alpha = 1 is default
%
% Reference: F.J. Harris,"On the Use of Windows for Harmonic Analysis with the
% Discrete Fourier Transform," IEEE Proc., vol 66, no 1, Jan 1978, pp 51-83.

% D.C. Hanselman, University of Maine, Orono, ME  04469
% 1/10/95
% Copyright (c) 1996 by Prentice-Hall, Inc. 

if nargin==0
	w=['rec';'tri';'han';'ham';'bla';'blx';'rie';'tuk';'poi';'cau';'gau'];
	return
end
[r,c]=size(N);
n=max(r,c);
if n>1,N=n;end
wt=[wt(:)' '   '];
wt=wt(1:3);
if strcmp(wt,'rec')				% rectangular
	w = ones(1,N);
elseif strcmp(wt,'tri')			% triangular
	m=(N-1)/2;
	w=(0:m)/m;
	w=[w w(ceil(m):-1:1)];
elseif strcmp(wt,'han')			% hanning
	m=linspace(-pi,pi,N);
	w=0.5*(1 + cos(m));
elseif strcmp(wt,'ham')			% hamming
	m=linspace(-pi,pi,N);
	w=.54 + .46*cos(m);
elseif strcmp(wt,'bla')			% blackman
	m=linspace(-pi,pi,N);
	w=.42 +.5*cos(m) + .08*cos(2*m);
elseif strcmp(wt,'blx')			% blackman exact
	m=linspace(-pi,pi,N);
	w=(7938 + 9240*cos(m) + 1430*cos(2*m))/18608;
elseif strcmp(wt,'rie')			% riemann
	m=linspace(-pi,pi,N)+eps;
	w=sin(m)./(m);
elseif strcmp(wt,'tuk')			% tukey
	if nargin<3,a=0.5;end
	m=fix((a+1)*N/2);
	w=ones(1,N);
	if a>0&a<1
		w(m:N)=0.5*(1 + cos(pi*((m:N)-m)/(N-m)));
		w(1:N-m+1)=w(N:-1:m);
	end
elseif strcmp(wt,'poi')			% poisson
	if nargin<3,a=1;end
	m=round(N/2)-1;
	w=[(m:-1:0) (rem(N,2):m)]/m;
	w=exp(-abs(a)*w);
elseif strcmp(wt,'cau')			% cauchy
	if nargin<3,a=1;end
	m=round(N/2)-1;
	w=[(m:-1:0) (rem(N,2):m)]/m;
	w=(1+(a*w).^2).^(-1);
elseif strcmp(wt,'gau')			% gaussian
	if nargin<3,a=1;end
	m=round(N/2)-1;
	w=[(m:-1:0) (rem(N,2):m)]/m;
	w=exp(-0.5*(a*w).^2);
else
	error('Incorrect Window type requested');
end
if r>1,w=w.';end
