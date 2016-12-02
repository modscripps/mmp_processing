function [xout,navg]=geometric_avg(x,nmax,skipNaNs)
% Usage: [xout,navg]=geometric_avg(x,nmax,skipNaNs);
%  inputs:
%    x: vector of data to be averaged
%    nmax: positive-definite integer, max exponent of 2 for averaging
%    skipNaNs: optional string, 'y' to skip NaNs to average valid data
%  outputs:
%    xout: vector of averaged data
%    navg: vector of number of input values per averaged value
% M.Gregg, 31jul96

if nargin<3
  skipNaNs='n';
end

[m,n]=size(x);

% Check that nmax is a positive definite integer
if nmax<1 | rem(nmax,1)~=0
  msg1=['geometric_avg: nmax must be a positive-definite integer'];
	disp(msg1)
	xout=[]; navg=[];
  % If x is not a vector, output a null matrix.  Otherwise proceed.
elseif min(m,n)>1
  msg2=['geometric_avg: x must be a vector.  It is a matrix.'];
	disp(msg2)
	xout=[]; navg=[];
else
  npts=length(x);
	%
	% Determine the number of output points, nout.
	nout=0; nsum=0;
	i=1;
	while nsum+2^i<=npts
	  nout=nout+1;
	  nsum=nsum+2^i;
		if i<nmax i=i+1; end
	end
	%
	% Construct output vectors of same type as input vector
	if m>=n
	  xout=NaN*ones(nout,1); navg=zeros(nout,1);
	else
	  xout=NaN*ones(1,nout); navg=zeros(1,nout);
	end
	%
	% Do the averaging
	i=1; % power of 2 used in averaging
	last=1; % last input element used
	for j=1:nout
	  nn=2^i;
		% Select data to average, removing NaNs if specified
		idata=last:last+nn-1;
		if strcmp(skipNaNs,'y')
		  ig=find(~isnan(x(idata)));
		else
		  ig=1:length(idata);
		end
		if ~isempty(ig)
	    xout(j)=mean(x(idata(ig)));
		  navg(j)=length(ig);
		end
		last=last+nn;
		if j<nmax i=i+1; end
	end
end
