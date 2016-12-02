function y=shiftud(a,n,cs)
%SHIFTUD Shift or Circularly Shift Matrix Rows.
% SHIFTUD(A,N) with N>0 shifts the rows of A DOWN N rows.
% The first N rows are replaced by zeros and the last N
% rows of A are deleted.
% 
% SHIFTUD(A,N) with N<0 shifts the rows of A UP N rows.
% The last N rows are replaced by zeros and the first N
% rows of A are deleted.
% 
% SHIFTUD(A,N,C) where C is nonzero performs a circular
% shift of N rows, where rows circle back to the other
% side of the matrix. No rows are replaced by zeros.
%

% D.C. Hanselman, University of Maine, Orono ME 04469
% 1/24/95
% Copyright (c) 1996 by Prentice-Hall, Inc. 

if nargin<3,cs=0;end	% if no third argument, default is False
cs=cs(1);				% make sure third argument is a scalar
[r,c]=size(a);			% get dimensions of input
dn=n>=0;				% dn is true if shift is down
n=min(abs(n),r);		% make sure shift amount is less than matrix rows

if n==0|(cs&n==r)					% simple no shift case
	y=a;
elseif ~cs&dn						% no circular and down
	y=[zeros(n,c); a(1:r-n,:)];
elseif ~cs&~dn						% no circular and up
	y=[a(n+1:r,:); zeros(n,c)];
elseif cs&dn						% circular and down
	y=[a(r-n+1:r,:); a(1:r-n,:)];
elseif cs&~dn						% circular and up
	y=[a(n+1:r,:); a(1:n,:)];
end
