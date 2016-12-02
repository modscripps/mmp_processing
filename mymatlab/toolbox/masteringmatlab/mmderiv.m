function z=mmderiv(x,y)
%MMDERIV Compute Derivative Using Weighted Central Differences.
% MMDERIV(X,Y) computes the derivative of the function y=f(x) given the
% data in X and Y. X must be a vector, but Y may be a column oriented
% data matrix. The length of X must equal the length of Y is Y is a
% vector, or it must equal the number of rows in Y if Y is a matrix.
%
% X need not be equally spaced. Weighted central differences are used.
% Quadratic approximation is used at the endpoints.
%
% See also mmintgrl

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 1/29/95
% Copyright (c) 1996 by Prentice-Hall, Inc. 

flag=0;						% flag is true if y is a row
x=x(:);nx=length(x);		% make x a column
[ry,cy]=size(y);
if ry==1&cy==nx,y=y.';ry=cy;cy=1;flag=1;end
if nx~=ry, error('X and Y not the right size'),end
if nx<3, error('X and Y must have at least three elements'),end

dx=x(2:nx)-x(1:nx-1);		% first difference in x
dx=dx+(dx==0)*eps;			% make infinite slopes finite
dxx=x(3:nx)-x(1:nx-2);		% second difference in x
dxx=dxx+(dxx==0)*eps;		% make infinite slopes finite
alpha=dx(1:nx-2)./dxx;		% central difference weight
alpha=alpha(:,ones(1,cy));	% duplicate for each column in y

dy=y(2:ry,:)-y(1:ry-1,:);	% first difference in y
dx=dx(:,ones(1,cy));		% duplicate dx for each column in y

% now apply weighting to dy
z=alpha.*dy(2:ry-1,:)./dx(2:nx-1,:)+(1-alpha).*dy(1:ry-2,:)./dx(1:nx-2,:);

z1=zeros(1,cy);zn=z1;
for i=1:cy	% fit quadratic at endpoints of each column
	p1=polyfit(x(1:3),y(1:3,i),2);          % quadratic at first point
	z1(i)=2*p1(1)*x(1)+p1(2);				% evaluate poly derivative
	pn=polyfit(x(nx-2:nx),y(ry-2:ry,i),2);  % quadratic at last point
	zn(i)=2*pn(1)*x(nx)+pn(2);				% evaluate poly derivative
end

z=[z1;z;zn];
if flag,z=z';end	% if y was a row, return a row
