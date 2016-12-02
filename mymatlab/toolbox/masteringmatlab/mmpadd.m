function p=mmpadd(a,b)
%MMPADD Polynomial Addition.
% MMPADD(A,B) adds the polynomials A and B.

% D.C. Hanselman, University of Maine, Orono ME 04469
% 3/4/95
% Copyright (c) 1996 by Prentice Hall, Inc.

if nargin<2
	error('Not enough input arguments')
end
a=a(:).';		% make sure inputs are polynomial row vectors
b=b(:).';
na=length(a);	% find lengths of a and b
nb=length(b);
p=[zeros(1,nb-na) a]+[zeros(1,na-nb) b];  % pad with zeros as necessary
