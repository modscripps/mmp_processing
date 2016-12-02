function yprime=vdpol(t,y);
%VDPOL(t,y) returns the state derivatives of the Van der Pol equation:
%
%	x'' - mu*(1-x^2)*x' + x = 0    (' = d/dx, '' = d^2/dx^2)
%
%	let y(1) = x   and y(2) = x'
%
%	then  y(1)' = y(2)
%         y(2)' = mu*(1-y(1)^2)*y(2) -y(1)

global MU

yprime=[y(2);MU*(1-y(1)^2)*y(2)-y(1)]; % output must be a column
