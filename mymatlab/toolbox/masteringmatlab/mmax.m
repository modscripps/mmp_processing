function [m,i]=mmax(a)
%MMAX Matrix Maximum Value.
% MMAX(A) returns the maximum value in the matrix A.
% [M,I] = MMAX(A) in addition returns the indices of
% the maximum value in I = [row col].

% D.C. Hanselman, University of Maine, Orono ME 04469
% 1/4/95
% Copyright (c) 1996 by Prentice Hall, Inc.

if nargout==2,	%return indices
	[m,i]=max(a);
	[m,ic]=max(m);
	i=[i(ic) ic];
else,
	m=max(max(a));
end
