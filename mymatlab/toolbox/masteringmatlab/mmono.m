function f=mmono(x)
%MMONO Test for Monotonic Vector.
% MMONO(X) where X is a vector returns:
%     2 if X is strictly increasing,
%     1 if X is non decreasing,
%    -1 if X is non increasing,
%    -2 if X is strictly decreasing,
%     0 otherwise.

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% 2/7/95
% Copyright (c) 1996 by Prentice-Hall, Inc.

x=x(:);			% make x a vector
y=diff(x);		% find differences between consecutive elements

if all(y>0)
					f=2;	% test for strict first
elseif all(y>=0)
					f=1;
elseif all(y<0)
					f=-2;	% test for strict first
elseif all(y<=0)
					f=-1;
else
					f=0;	% default response
end
