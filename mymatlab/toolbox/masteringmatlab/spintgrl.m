function z=spintgrl(x,y,xi)
%SPINTGRL Cubic Spline Integral Interpolation.
% YI=SPINTRGL(X,Y,XI) uses cubic spline interpolation to fit the
% data in X and Y, integrates the spline, and returns
% values of the integral evaluated at the points in XI.
%
% PPI=SPINTGRL(PP) returns the piecewise polynomial vector PPI
% describing the integral of the cubic spline described by
% the piecewise polynomial in PP. PP is returned by the function
% SPLINE and is a data vector containing all information to
% evaluate and manipulate a spline.
%
% YI=SPINTGRL(PP,XI) integrates the cubic spline given by
% the piecewise polynomial PP, and returns the values of the
% integral evaluated at the points in XI.
%
% See also SPLINE, PPVAL, MKPP, UNMKPP, SPDERIV

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 1/27/95
% Copyright (c) 1996 by Prentice-Hall, Inc. 

if nargin==3
	pp=spline(x,y);
else
	pp=x;
end
[br,co,npy,nco]=unmkpp(pp);	% take apart pp
if pp(1)~=10
	error('Spline data does not have the correct form.')
end
sf=nco:-1:1;								% scale factors for integration
ico=[co./sf(ones(npy,1),:) zeros(npy,1)];	% integral coefficients
nco=nco+1;									% integral spline has higher order
for k=2:npy									% find constant terms in polynomials
	ico(k,nco)=polyval(ico(k-1,:),br(k)-br(k-1));
end
ppi=mkpp(br,ico);							% build pp form for integral
if nargin==1
	z=ppi;
elseif nargin==2
	z=ppval(ppi,y);
else
	z=ppval(ppi,xi);
end

