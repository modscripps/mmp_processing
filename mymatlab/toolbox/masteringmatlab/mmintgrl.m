function z=mmintgrl(x,y)
%MMINTGRL Compute Integral using Trapezoidal Rule.
% MMINTGRL(X,Y) computes the integral of the function y=f(x) given the
% data in X and Y. X must be a vector, but Y may be a column oriented
% data matrix. The length of X must equal the length of Y if Y is a
% vector, or it must equal the number of rows in Y if Y is a matrix.
%
% X need not be equally spaced. The trapezoidal algorithm is used.
%
% See also mmderiv

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 1/29/95
% Copyright (c) 1996 by Prentice-Hall, Inc. 

flag=0;					% flag is true if y is a row
x=x(:);nx=length(x);	% make x a column
[ry,cy]=size(y);
if ry==1&cy==nx,y=y.';ry=cy;cy=1;flag=1;end
if nx~=ry, error('X and Y not the right size'),end

dx=x(2:nx)-x(1:nx-1);	% width of each trapezoid
dx=dx(:,ones(1,cy));	% duplicate for each column in y
yave=(y(2:ry,:)+y(1:ry-1,:))/2; % average of heights
z=[zeros(1,cy); cumsum(dx.*yave)];
if flag,z=z';end		% if y was a row, return a row
