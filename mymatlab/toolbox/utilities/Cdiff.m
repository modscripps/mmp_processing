function [fder,xmid]=Cdiff(f,x,n,decimate)
% Usage: [fder,xmid]=Cdiff(f,x,n,decimate);
%  inputs: f: vector to be differentiated
%          x: vector of independent variable, same length as f
%          n: integer with half interval for differentiation
%          decimate: string, 'y' to decimate input by factor of
%            2n
%  outputs: fder: column vector with derivative of f
%           xmid: column vector with midpoints of x intervals
% Function: Centered differentiation of a vector.
% Note: If decimate='n', outputs will correspond to samples
%   (1+n:length(f)-n) of the inputs
% M.Gregg, 29dec96

if nargin<4
  decimate='y';
end

f=f(:); x=x(:);

nf=length(f);
nx=length(x);

if nf~=nx
  disp('Cdiff: f and x must have same lengths')
	return
end

if strcmp(decimate,'n')
  fder=(f(1+2*n:nf)-f(1:nf-2*n)) ./ (x(1+2*n:nf)-x(1:nf-2*n));
	xmid=x(1+n:nx-n);
else
  fder=diff(f(1:2*n:nf)) ./ diff(x(1:2*n:nx));
  xmid=x(1+n:2*n:nx);

  lenxm=length(xmid);
  lenfd=length(fder);
  if lenxm==lenfd+1
    xmid=xmid(1:lenxm-1);
  end
end

