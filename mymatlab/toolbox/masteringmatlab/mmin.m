function [m,i]=mmin(a)
%MMIN Matrix Minimum Value.
% MMIN(A) returns the minimum value in the matrix A.
% [M,I] = MMIN(A) in addition returns the indices of
% the minimum value in I = [row col].

% D.C. Hanselman, University of Maine, Orono ME 04469
% 1/4/95
% Copyright (c) 1996 by Prentice Hall, Inc.

if nargout==2,	%return indices
	[m,i]=min(a);
	[m,ic]=min(m);
	i=[i(ic) ic];
else,
	m=min(min(a));
end
