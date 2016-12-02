function m=mmtest(a,b,c)
%MMFIND Intersection of Elements in Two Matrices.
% MMFIND(A,B) returns a logical matrix the size of A
% having ones where the corresponding elements of A
% also appear in B. A and B need not be the same size.

% This function shows how vectorizing using index manipulations
% is faster than repeated interpretation of statements in a loop
% even when many more flops are involved.
%
% For comparison and illustration MMFIND(A,B,1) uses a FOR loop
% to compute the result.

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% 8/24/95
% Copyright (c) 1996 by Prentice-Hall, Inc.


b=sort(b(:));
b(~[diff(b);1])=[];         % discard duplicate values in b


[ra,ca]=size(a);
m=zeros(ra,ca);             % make output mask vector of FALSE

a=a(:);                     % convert to column vector
na=length(a);
if nargin==3                % due slow way, comment out if you wish
	for i=1:na
		m(i)=any(a(i)==b);
	end
	return
end
[sa,ia]=sort(a);            % sort to look for duplicates in a
d=[~diff(sa);0];            % true where duplicates exist in sa 
ida=ia(d);                  % indices of duplicates in a
for i=ida.'
	m(i)=any(a(i)==b);      % check duplicates and poke in TRUE
end
a(ida)=nan*ones(length(ida),1);% change duplicates to nan
                               % nan's go to end when sorted

[x,ix]=sort([a;b]);     % sort a and b together
dx=[diff(x);1];         % look for differences
i=ix(dx==0);            % indices of a that have matching values in b
m(i)=ones(length(i),1); % poke TRUE into these indices
