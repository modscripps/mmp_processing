function [xout,pout]=bartlett(x,p)
% Usage: [xout,pout]=bartlett(x,p);
%  inputs
%   x is a vector with data to be filtered
%   p is a vector of the same length with matching pressures
%  outputs
%   xout is a number containing the weighted output
%   pout is the matching pressure number
% Function: to apply the Bartlett filter to data in vector x
%   with matching pressure in vector p.  The filter is a
%   triangular weighting with no weights equal to zero.
%   The function is eqns 11.15 and 11.16 in "Digital Filter
%   Designer's Handbook", C. B. Rorabaugh, McGraw-Hill, 1993.
% M.Gregg, 29dec95

x=x(:)'; p=p(:)';

% test that x and p have same lengths
N=length(x);
if N ~= length(p)
  error('length(x) not equal to length(p)')
end

% define filter weights
w=ones(size(x));
if rem(N,2)==1 % N odd
  n=[-(N-1)/2:(N-1)/2];
  w=w-abs(2*n)/(N+1);
else % N even
  n=[-N/2:N/2-1]; % N even
  w=w-abs(2*n+1)/(N+1);
end
 
xout=x*w'/sum(w);
pout=p*w'/sum(w);
