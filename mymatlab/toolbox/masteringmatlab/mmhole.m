function q=mmhole(x,y,z,xlim,ylim)
%MMHOLE Create Hole in 3D Graphics Data
% Z=MMHOLE(X,Y,Z,Xlim,Ylim) sets the data in Z to NaN
% corresponding to the limits in Xlim=[Xmin Xmax] and
% Ylim=[Ymin Ymax]. If Xlim or Ylim are empty they are
% assumed to be [-inf inf].
% X and Y can be plaid matrices, e.g., created by MESHGRID
% or they can be vectors defining the x and y axes.
%
% Z=MMHOLE(Z,Clim,Rlim) creates the NaN hole based on the 
% column index limits in Clim and the row index limits in Rlim
%
% Resulting data can be plotted using mesh or surf:
% MESH(X,Y,Z) or SURF(X,Y,Z)
% This function automates the procedure described on
% page 249 of "Mastering MATLAB".

% D.C. Hanselman, University of Maine, Orono ME,  04469
% 9/26/95
% Copyright (c) 1996 by Prentice-Hall, Inc.

if nargin==3	% MMHOLE(Z,Clim,Rlim)
	ylim=z;	xlim=y;	z=x;	% rearrange variables as required
	x=1:size(z,2);
	y=1:size(z,1);
end
if length(xlim)<2, xlim=[-inf inf];else xlim=xlim(1:2);end
if length(ylim)<2, ylim=[-inf inf];else ylim=ylim(1:2);end

sx=size(x);
sy=size(y);
sz=size(z);
if all(sx==sz), x=x(1,:); end		% get x-axis vector
if all(sy==sz), y=y(:,1); end		% get y-axis vector
i=find(y>=ylim(1) & y<=ylim(2));	% y indices of hole
j=find(x>=xlim(1) & x<=xlim(2));	% x indices of hole
q=z;
q(i,j)=nan*q(i,j);

