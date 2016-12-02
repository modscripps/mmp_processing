function y=mmpsim(x,tol)
%MMPSIM Polynomial Simplification, Strip Leading Zero Terms.
% MMPSIM(A) Deletes leading zeros and small coefficients in the
% polynomial A(s). Coefficients are considered small if their
% magnitude is less than both one and norm(A)*1000*eps.
% MMPSIM(A,TOL) uses TOL for its smallness tolerance.  

% D.C. Hanselman, University of Maine, Orono ME,  04469
% 3/4/95
% Copyright (c) 1996 by Prentice-Hall, Inc. 

if nargin<2, tol=norm(x)*1000*eps; end
x=x(:).';						% make sure input is a row
i=find(abs(x)<.99&abs(x)<tol);  % find insignificant indices
x(i)=zeros(1,length(i));		% set them to zero
i=find(x~=0);					% find significant indices
if isempty(i) 
	y=0;						% the extreme case: nothing left!
else
	y=x(i(1):length(x));		% start with first significant term
end
