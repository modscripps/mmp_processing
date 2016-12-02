function iforgot(n)
%IFORGOT Recursive Function Call Example.
%

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% 1/25/95
% Copyright (c) 1996 by Prentice-Hall, Inc.

if nargin==0,n=20;end
if n>1
	disp('I will remember to do my homework.')
	iforgot(n-1)
else
	disp('Maybe NOT!')
end